__author__ = 'sushaoxiang911'

import BaseHTTPServer
import urllib
import cgi
import json
import requests

PORT = 5050

class File:
    def __init__(self, name, relaPath, localName, isFolder):
        self.name = name
        self.relaPath = relaPath
        self.localName = localName
        self.isFolder = isFolder

class BaseDrive:
    def __init__(self, token):
        self.token = token
    def push(self, rootPath, file):
        return

    def get(self, rootPath, file):
        return
    def ls(self, rootPath, folder):
        return


class File:
    def __init__(self, furl, fname):
        self.url = furl
        self.name = fname

class HttpRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_POST(self):
        print "get request"
        contentType = self.headers.getheader('content-type')
        # check the json
        if contentType == 'application/json':
            length = int(self.headers.getheader('content-length'))
            rawData = self.rfile.read(length)
            driveRequest = json.loads(rawData)
            print driveRequest["dropboxToken"]
            print driveRequest["toDrive"]

        return


if __name__ == '__main__':
    server = BaseHTTPServer.HTTPServer(('0.0.0.0', PORT), HttpRequestHandler)
    print "Server starts"
    server.serve_forever()


