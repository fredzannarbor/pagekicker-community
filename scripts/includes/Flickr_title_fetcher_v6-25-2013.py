#!/usr/local/bin/python
###################################################
#Inputs:
#1) a text file containing seeds for image calls and 
#2) a uuid 
#Outputs:
#1) url_list.txt - a list of images that are retrieved from Flickr 

import os, sys, json, flickrapi, codecs, urllib.request, urllib.parse, urllib.error 

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
	#print user_info['person']
	#Filters out those users who don't have their real name available
	#and uses their username instead
	username = None;
	if 'realname' in user_info['person']:
		
		username = user_info['person']['realname']['_content']
		if username == '':
			username = user_info['person']['path_alias']
			if username == None:
				username = user_info['person']['username']['_content']
			
	elif user_info['person']['path_alias'] != None:
		username = user_info['person']['path_alias']
	else:
		username = user_info['person']['username']['_content']
	return username




#=================================================
def parser(json_photos, per_page_num, api_key, seed, index):
	#here we can do a quick dirty parsing now
	#ideally, we go back and make a class that will hold all the data
	
	#filters out null results 
	if json_photos['photos']['total'] != '0':
		
		f = codecs.open('title_url_list.txt', encoding = 'utf-8', mode = 'a')
		for pic in range(per_page_num):
			f2 = codecs.open('TitleImage_'+str(index+1)+'.txt', encoding = 'utf-8', mode = 'a')
			pic_title = json_photos["photos"]['photo'][int(pic)]['title']
			pic_owner = json_photos['photos']['photo'][int(pic)]['owner']
			pic_id = json_photos['photos']['photo'][int(pic)]['id']
			pic_farm = json_photos['photos']['photo'][int(pic)]['farm']
			pic_server = json_photos['photos']['photo'][int(pic)]['server']
			pic_secret = json_photos['photos']['photo'][int(pic)]['secret']
	
			username = getFlickrUsername(api_key, pic_owner)
			url = "http://farm" + str(pic_farm) + ".static.flickr.com/"\
			+ pic_server + "/" + pic_id + "_" + pic_secret + ".jpg"
			print(seed)
			print(pic_title)
			print(username)
			print(url)
			
			#I'm having some troubles with usernames here's a quick fix:
			if username == None: 
				continue
			f2.write('Seed: '+ seed + '\n' +'Title: ' + pic_title + '\n' + 'User: ' + username + '\n' +'URL: ' + str(url) )
			f.write(seed + ': "' + pic_title + '", An image by Flickr user: ' + username + ' : ' + url + '\n')
			
			f2.close()
		f.close()
		return url
#=================================================
def imageDownloader(url, index):
	if url != None:
		urllib.request.urlretrieve(url, 'TitleImage_'+str(index+1) + '.jpg')

#=================================================
def main():
	seedlist_path = str(sys.argv[1])
	uuid_path = str(sys.argv[2])
	os.chdir(uuid_path)
	api_key = 'e7a1dbf3d545efe6dfe297f3745c1dbd'
	per_page_num = 1
	with codecs.open(seedlist_path) as f:
		for index, line in enumerate(f):
			line = line.strip()
			if line: 
				#print line
				json_photos = callTheApi(api_key, line, per_page_num);
				
				url = parser(json_photos, per_page_num, api_key, line, index)
				imageDownloader(url, index)
    
#=================================================
if __name__ == '__main__':
    main()
