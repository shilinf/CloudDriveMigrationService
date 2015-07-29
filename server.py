__author__ = 'sushaoxiang911'

import BaseHTTPServer
import json
import connection

PORT = 5050

class HttpRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_POST(self):
        print "get request"
        contentType = self.headers.getheader('content-type')
        # check the json
        if contentType == 'application/json':
            length = int(self.headers.getheader('content-length'))
            rawData = self.rfile.read(length)
            driveRequest = json.loads(rawData)
            dropboxToken = driveRequest["dropboxToken"]
            onedriveToken =  driveRequest["onedriveToken"]
            fromPath = driveRequest["fromPath"]
            connection.slave(dropboxToken, onedriveToken, fromPath)
        return


if __name__ == '__main__':
    server = BaseHTTPServer.HTTPServer(('0.0.0.0', PORT), HttpRequestHandler)
    print "Server starts"
    server.serve_forever()


