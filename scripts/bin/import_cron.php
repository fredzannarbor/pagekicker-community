<?php
 require_once 'app/Mage.php';
umask(0);
 ini_set("memory_limit","1024M");
//$_SERVER['SERVER_PORT']='443';
Mage::app();
$profileId = 7; //put your profile id here

$logFileName= "import.log";
$recordCount = 0;
// This won't work if Logging settings is disabled
// To activate it go to System->Configuration->Developer
Mage::log("Import Started",null,$logFileName);

exec('echo -n "Magento import profile is busy" > /opt/bitnami/apps/magento/htdocs/var/import/status.txt');

$profile = Mage::getModel('dataflow/profile');

$userModel = Mage::getModel('admin/user');
$userModel->setUserId(0);
Mage::getSingleton('admin/session')->setUser($userModel);

if ($profileId) {
	$profile->load($profileId);
	if (!$profile->getId()) {
		Mage::getSingleton('adminhtml/session')->addError('The profile you are trying to save no longer exists');
	}
}

Mage::register('current_convert_profile', $profile);

$profile->run();

$batchModel = Mage::getSingleton('dataflow/batch');
if ($batchModel->getId()) {
	if ($batchModel->getAdapter()) {
		$batchId = $batchModel->getId();
		$batchImportModel = $batchModel->getBatchImportModel();
		$importIds = $batchImportModel->getIdCollection();
		$batchModel = Mage::getModel('dataflow/batch')->load($batchId);
		$adapter = Mage::getModel($batchModel->getAdapter());
		foreach ($importIds as $importId) {
			$recordCount++;
			try{
				$batchImportModel->load($importId);
				if (!$batchImportModel->getId()) {
					$errors[] = Mage::helper('dataflow')->__('Skip undefined row');
					continue;
				}

				$importData = $batchImportModel->getBatchData();
				try {
					$adapter->saveRow($importData);
				} catch (Exception $e) {
					Mage::log($e->getMessage(),null,$logFileName);
					continue;
				}

				if ($recordCount%20 == 0) {
					Mage::log($recordCount . ' - Completed!!',null,$logFileName);
				}
			} catch(Exception $ex) {
				Mage::log('Record# ' . $recordCount . ' - SKU = ' . $importData['sku']. ' - Error - ' . $ex->getMessage(),null,$logFileName);
			}
		}
		foreach ($profile->getExceptions() as $e) {
			Mage::log($e->getMessage(),null,$logFileName);
		}

	}
}

Mage::log("Import Completed",null,$logFileName);

exec('echo -n "Magento import profile is available" > /opt/bitnami/apps/magento/htdocs/var/import/status.txt');

// Catalog Rewrites
try {
	Mage :: getSingleton( 'catalog/url' ) -> refreshRewrites();
}
catch ( Exception $e ) {
	Mage::log($e -> getMessage(),null,$logFileName);
}
// LAYERED NAV
    try {
        $flag = Mage::getModel('catalogindex/catalog_index_flag')->loadSelf();
        if ($flag->getState() == Mage_CatalogIndex_Model_Catalog_Index_Flag::STATE_RUNNING) {
            $kill = Mage::getModel('catalogindex/catalog_index_kill_flag')->loadSelf();
            $kill->setFlagData($flag->getFlagData())->save();
        }

        $flag->setState(Mage_CatalogIndex_Model_Catalog_Index_Flag::STATE_QUEUED)->save();
        Mage::getSingleton('catalogindex/indexer')->plainReindex();
        Mage::log('Layered Navigation Indices were refreshed successfully', null, $logFileName);
    }
    catch (Mage_Core_Exception $e) {
        Mage::log($e -> getMessage(). "\n",null,$logFileName);
    }
    catch (Exception $e) {
        Mage::log('Error while refreshed Layered Navigation Indices. Please try again later', null,$logFileName);
    }
 ?>
