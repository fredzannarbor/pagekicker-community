#!/bin/bash
# nonportable test script for bitnami
bin/xform.sh /opt/bitnami/apps/magento/htdocs/media/webforms/xml mdtest.xml
# next job tests exit on insufficient words
# bin/xform.sh /opt/bitnami/apps/magento/htdocs/media/webforms/xml 3401.xml

