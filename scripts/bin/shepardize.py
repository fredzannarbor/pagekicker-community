
# Mendeley API "Shepardize for Scientists"

# check for updated citations to articles cited in bibliography

# task flow

	# authenticate to Mendeley

	# select group

	# select "update since" date

	# for i = 1 to (documents in group)

		# search for n documents related to i and date gt update since

		# if n > 0 increment docsupdated counter by 1 and increment totaldocstoreview by n

		# save documents 1...n in group (subgroup for review)

		# save document titles 1...n to file

	# report

		#checked n documents from group name

		# there were new citations related to docsupdated

		# totalsdocs to review have been added to group(for review)


from pprint import pprint
from mendeley_client import MendeleyClient
mendeley = MendeleyClient('13a47f20711f5d5ffe8e8f4db1df1daa04f8bd9b6', '394d64a2907f23c7f6ea5d94fb386865')
try:
    mendeley.load_keys()
except IOError:
<<<<<<< HEAD
    mendeley.get_required_keys()
    mendeley.save_keys()
=======
	mendeley.get_required_keys()
	mendeley.save_keys()
>>>>>>> 02c3d39556dd37836a5933188a7b2798d3eada36


folders = mendeley.group_folders(groupId)
pprint(folders)
