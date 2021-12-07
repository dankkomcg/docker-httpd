1. install certs
`sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./conf/ssl/server.key -out ./conf/ssl/server.crt`

2. build image (replace the vendor)
`docker build . -t dankkomcg/httpd:x.y.z`
