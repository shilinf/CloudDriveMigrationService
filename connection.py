# Include the Dropbox SDK
import dropbox
from dropbox.client import DropboxClient
from dropbox.session import DropboxSession
import requests
import json
import re
from urllib import urlencode, quote



class MyFile:
    def __init__(self, path, isFolder):
        self.path = path
        self.isFolder = isFolder


class BaseDrive:
    def __init__(self, token, rootPath):
        self.token = token
        self.rootPath = rootPath
    def push(self, myfile, temp_filename):
        return
    def get(self, myfile, temp_filename):
        return
    def ls(self, path):
        return


class OneDrive(BaseDrive):
    def __init__(self, token, rootPath):
        BaseDrive.__init__(self, token, rootPath)
    def push(self, myfile, temp_filename):
        myUrl = 'https://api.onedrive.com/v1.0/drive/root:'+ r'/'.join([quote(s) for s in re.split(r'\/', myfile.path)])+':/content?'\
                + urlencode({'access_token': self.token})
        with open(temp_filename) as fh:
            mydata = fh.read()
            response = requests.put(myUrl, 
                data=mydata,)



class DropBox(BaseDrive):
    def __init__(self, token, rootPath):
        BaseDrive.__init__(self, token, rootPath)
        APP_KEY = '5a91csqjtsujuw7'
        APP_SECRET = 'x5wbkk2o273jqz7'
        session = DropboxSession(APP_KEY, APP_SECRET)
        print token
        access_key, access_secret = token.split(',')
        session.set_token(access_key, access_secret)
        first_client = DropboxClient(session)
        token1 = first_client.create_oauth2_access_token()
        self.client = DropboxClient(token1)
    def ls(self, path):
        folder_metadata = self.client.metadata(path)
        contents = folder_metadata['contents']
        files = []
        for content in contents:
            if content['is_dir']:
                files.append(MyFile(content['path'], True))
            else:
                files.append(MyFile(content['path'], False))
        return files
    def get(self, myfile, temp_filename):
        out = open(temp_filename, 'wb')
        f = self.client.get_file(myfile.path)
        out.write(f.read())
        out.close()


def slave(dropbox_token, onedrive_token, rootPath):
    mydropbox = DropBox(dropbox_token, rootPath)
    onedrive = OneDrive(onedrive_token, rootPath)
    uploadFolder(mydropbox, onedrive, rootPath)



def uploadFolder(mydropbox, onedrive, path):
    files = mydropbox.ls(path)
    for myfile in files:
        if not myfile.isFolder:
            mydropbox.get(myfile, 'temp')
            onedrive.push(myfile, 'temp')
        else:
            uploadFolder(mydropbox, onedrive, myfile.path)



if __name__ == '__main__':
    slave('3ydFc4zVO4AAAAAAAAAABkzEqshhVNQv-C2LQu1Zx4mF4SVLq5rsiAzvvoxVbvju', 'EwB4Aq1DBAAUGCCXc8wU/zFu9QnLdZXy+YnElFkAATrELwlbY3t36BSlOr4PDLeh6Hr9axI9h1/ViNug90xFInI6B8blEcWu+NFypnHpbz4a/BbOzXD525pzUcKojUdPz9eQzVQA57RaAuozGwQD8VkgKbzAItNSp5lJ5TQJt0jP51tPWPiD7SXcHv0sOZ2tM1K7Hfoy+bOhaLPshlr4rgayik+AB5kEyHIM4hZS96MHqWGpTJ4WMhHJsjpWxSrntHOmAmVyclWjzNWRJFEn0IJ1hk5025oq2dZbwGosmKEesPTJhWevPjOkdFDRa1lJaKqzBjqGrTlYriAsKH/IJmu8uH1Tn4/pHAogK75FWG51rnc4EbN35dJcssmVTYcDZgAACMlAGRZJRBOPSAEOWMvQvwxJlSAdxAWQiZP1NotS0hWzvUlPevGbpnclaaye5Z4oVtemteJvTc1K15qT0zLz7gGkvuoMZkBrN0j4dAyHgDXpTRnXbgQZosoIZdf9VliTc5Xt9pNDEukiq/QXAc0KfG3wDgLiO8g1eQGFjiTktYq+/FaY+YiYMyVaZsrek4aXChGwNHxwrygUAi49mE8bgETciH4Z//fmodt7CP0oJ45tCtgVrmh1ZqFnVeC0yc544kBjOpRyPH972eJQ9SHSkHAEakR2QHv1lTWB2Q8Xn5vrN830zdok8B7KoCax75tSz3voACAs0ytO0sYahKFCMv3ygxmzoW29NzP1yqyY5OMipCQ0Ey/i7+wo4OMX2lB6nkwKO3NjeO9S0mZh8pDZfP0AVTZstGo/kBK5Myms8lyXw3x3rGcEjSdQGNw1WNf6TPy8YwE=', '/')
    client = dropbox.client.DropboxClient('3ydFc4zVO4AAAAAAAAAABkzEqshhVNQv-C2LQu1Zx4mF4SVLq5rsiAzvvoxVbvju')
    #print 'linked account: ', client.account_info()

    folder_metadata = client.metadata('/')
    print "metadata:", json.dumps(folder_metadata, indent=2)

    f, metadata = client.get_file_and_metadata('/Get Started with Dropbox.pdf')
    out = open('Dropbox.pdf', 'wb')
    out.write(f.read())
    out.close()





