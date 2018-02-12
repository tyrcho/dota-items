# from http://mfukar.github.io/2013/10/31/HTTPS.html
# run  "openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes"
# to generate the certificate then access from https://localhost:4443

import http.server, ssl

server_address = ('localhost', 4443)
httpd = http.server.HTTPServer(server_address, http.server.SimpleHTTPRequestHandler)
httpd.socket = ssl.wrap_socket(httpd.socket,
                               server_side=True,
                               certfile='server.pem',
                               ssl_version=ssl.PROTOCOL_TLSv1)
httpd.serve_forever()