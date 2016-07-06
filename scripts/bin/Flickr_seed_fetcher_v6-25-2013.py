#!/usr/local/bin/python
###################################################
#Inputs:
#1) a seed term 
#2) a uuid 
#Outputs:
#1) url_list.txt - a list of images that are retrieved from Flickr 

import os, sys, json, flickrapi, codecs, urllib

#=================================================
def callTheApi(api_key, seed, per_page_num):
	#This calls the API with a search term or 'seed'
	flickr = flickrapi.FlickrAPI(api_key)
	json_photos = json.loads(flickr.photos_search(text=seed, \
	per_page=str(per_page_num), format = 'json', nojsoncallback=1, \
	license = '4,6' ));
	#print json_photos
	return json_photos

#=================================================
def getFlickrUsername(api_key, pic_owner):
	#calls API to retrieve username for photo
	flickr = flickrapi.FlickrAPI(api_key)
	user_info = json.loads(flickr.people_getInfo(user_id = pic_owner, \
	format = 'json', nojsoncallback = 1))
	
	#Filters out those users who don't have their real name available
	#and uses their username instead
	if 'realname' in user_info['person']:
		username = user_info['person']['realname']['_content']
		if username == '':
			username = user_info['person']['path_alias']
			if username == None:
				username = user_info['person']['username']['_content']
	else:
		username = user_info['person']['path_alias']
	return username

#=================================================
def imageDownloader(url, index):
	if url != None:
		urllib.urlretrieve(url, 'SeedImage_'+str(index) + '.jpg')
		


#=================================================
def parser(json_photos, per_page_num, api_key, seed):
	#here we can do a quick dirty parsing now
	#ideally, we go back and make a class that will hold all the data
	
	#filters out null results 
	if json_photos['photos']['total'] != '0':
		
		f = codecs.open('seed_url_list.txt', encoding = 'utf-8', mode = 'w')
		index = 1;
		for pic in range(per_page_num):
			pic_title = json_photos["photos"]['photo'][int(pic)]['title']
			pic_owner = json_photos['photos']['photo'][int(pic)]['owner']
			pic_id = json_photos['photos']['photo'][int(pic)]['id']
			pic_farm = json_photos['photos']['photo'][int(pic)]['farm']
			pic_server = json_photos['photos']['photo'][int(pic)]['server']
			pic_secret = json_photos['photos']['photo'][int(pic)]['secret']
			username = getFlickrUsername(api_key, pic_owner)
			url = "http://farm" + unicode(pic_farm) + ".static.flickr.com/"\
			+ pic_server + "/" + pic_id + "_" + pic_secret + ".jpg"
			print seed
			print pic_title
			print username
			print url
			f2 = codecs.open('SeedImage_'+unicode(index)+'.txt', encoding = 'utf-8', mode = 'a')
			f2.write('Seed: '+ seed + '\n' +'Title: ' + pic_title + '\n' + 'User: ' + username + '\n' +'URL: ' + str(url) )
			f2.close()
			f.write(seed + ': "' + pic_title + '", An image by Flickr user: ' + username + ' : ' + url + '\n')
			imageDownloader(url, index)
			index += 1
		f.close()
		

#=================================================
def main():
	seed = str(sys.argv[1])
	uuid_path = str(sys.argv[2])
	os.chdir(uuid_path)
	api_key = 'e7a1dbf3d545efe6dfe297f3745c1dbd'
	per_page_num = 10
	json_photos = callTheApi(api_key, seed, per_page_num);
	#print json_photos
	parser(json_photos, per_page_num, api_key, seed)
    
#=================================================
if __name__ == '__main__':
    main()
