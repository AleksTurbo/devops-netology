#!/usr/bin/env python3

import socket
import os
import json
import yaml
import time
hostslist = ['drive.google.com', 'mail.google.com', 'google.com']
host_tmp = {}
readip={}
need_write=0

def check_services(hostslist):
	print ("---Read data.json")
	
	with open('data.json', 'r') as fp:
		readip=json.load(fp)

	print(readip['hostlist'])
	print ("---")

	for host in hostslist:
		tempip = ''
		ip = socket.gethostbyname(host)
		tempip = readip['hostlist'][host]
		print(host, tempip, ip)
		if tempip == ip:
			print("GOOD - IP is not changed")
			need_write=0
		else:
			print("ATETTION - IP is changed!")
			need_write=1
		host_tmp[host]= ip

	result={"hostlist": host_tmp}

	if need_write:=1:
		print("---Write data.json")
		print(json.dumps(result['hostlist']))
		with open('data.json', 'w') as fp:
			json.dump(result, fp)
		print("---Write data.yaml")
		print(yaml.dump(result['hostlist']))
		with open("data.yaml", "w") as fp_yaml:
				yaml.dump(result, fp_yaml, explicit_start=True, explicit_end=True)
			
	return result

while True:
	site_dict = check_services(hostslist )
	print(end='\n')
	time.sleep(5)