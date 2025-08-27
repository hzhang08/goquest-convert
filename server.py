from http.server import HTTPServer, SimpleHTTPRequestHandler
import urllib.request
import json

class ProxyHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith('/proxy/'):
            kifu_id = self.path.split('/proxy/')[1]
            try:
                url = f'https://kifu.questgames.net/game/{kifu_id}.json'
                response = urllib.request.urlopen(url)
                data = response.read()
                
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(data)
            except Exception as e:
                self.send_error(500, str(e))
        else:
            return SimpleHTTPRequestHandler.do_GET(self)

httpd = HTTPServer(('localhost', 8000), ProxyHandler)
print("Server running at http://localhost:8000")
httpd.serve_forever()
