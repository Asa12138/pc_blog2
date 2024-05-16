#!/usr/bin/env python3

# https://www.jianshu.com/p/07466bf02ef7
# python replace_md.py xxx.md
import requests
import json
import os
import sys
import datetime
import re
import imghdr
import _locale
_locale._getdefaultlocale = (lambda *args: ['zh_CN', 'utf8'])

cookie_file = 'cookies.txt'
upload_url = 'https://upload.qiniup.com/'

# get cookie from cookie file
def getCookie(path):
    try:
        with open(path, 'r') as f:
            content = f.readline()
            return content.strip()      
    except Exception as error:
        print(error)

def uploadImage(cook_path, filepath, name=''):
    cookStr = getCookie(cook_path)
    #print(cookStr)
    filename = os.path.basename(filepath)
    fname,suffix=os.path.splitext(filepath)
    if suffix == '':
        suffix = imghdr.what(filepath)
        filename = fname+'.'+suffix

    token_url = 'https://www.jianshu.com/upload_images/token.json?filename={}'.format(filename)
    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0',
        'Cookie': cookStr,
    }

    requests.packages.urllib3.disable_warnings()
    response = requests.get(token_url, headers=headers, verify=False)
    response.encoding = response.apparent_encoding
    token_key = json.loads(response.text)
    if 'token' not in token_key:
        return None

    with open(filepath, 'rb') as file:
        files = {
            'file': (filename, file),
            'token': (None, token_key['token']),
            'key': (None, token_key['key']),
        }
        requests.packages.urllib3.disable_warnings()
        response = requests.post(upload_url, headers=headers, files=files, verify=False)
        response.encoding = response.apparent_encoding
        img_url = json.loads(response.text)['url']
        img_md = '![{text}]({img_url})'.format(text=name, img_url=img_url)
        return img_md
 
def outputFile(path):
    try:
        with open(path, 'r') as fd, open("output.md", "w") as fd1:
            tmpPath = '__tmp__'
            content = fd.readlines()
            for line in content:
                # match http link image
                obj = re.search( r'!\[(.*)\]\((http.+)\)', line)
                if obj:
                    name = obj.group(1)
                    filePath = obj.group(2)
                    with open(tmpPath, 'wb') as tmpFd:
                        ir = requests.get(filePath)
                        tmpFd.write(ir.content)

                    newline = uploadImage(cookie_file, tmpPath, name)
                    if newline is None:
                        print('Err: ', 'uploadImage() error!')
                    else:
                        print('Ok: ', 'uploadImage() ok!')
                        line = newline
                    
                    fd1.write(line)
                    continue

                # match local file image
                obj = re.search( r'!\[(.*)\]\((.+)\)', line)
                if obj:
                    name = obj.group(1)
                    filePath = obj.group(2)
                    newline = uploadImage(cookie_file, filePath, name)
                    if newline is None:
                        print('Err: ', 'uploadImage() error!')
                    else:
                        print('Ok: ', 'uploadImage() ok!')
                        line = newline

                fd1.write(line)

            if os.path.exists(tmpPath):
                os.remove(tmpPath)
            return None
    except Exception as error:
        print('err:', error)


def main(path):
    if not os.path.exists(cookie_file):
        print("%s not exist!" % (cookie_file))
        return False
    if os.path.exists(path):
        outputFile(path)
        return True
    else:
        print("File path %s not exist!" % (path))
        return False

if __name__ == '__main__':
    if len(sys.argv) <= 1:
        print("Usage error: replace_md.py %path")
        sys.exit(-1)
    else:
        main(sys.argv[1])
    sys.exit(0)
