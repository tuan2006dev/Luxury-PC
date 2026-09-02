import urllib.request, urllib.parse, http.cookiejar

for u in ['leecookcu@gmail.com', 'leecookcu', 'admin', 'admin@luxurypc.vn']:
    cj = http.cookiejar.CookieJar()
    opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
    data = urllib.parse.urlencode({'username': u, 'password': '123456'}).encode('utf-8')
    req = urllib.request.Request('http://localhost:8080/login', data=data, headers={'Content-Type': 'application/x-www-form-urlencoded'})
    res = opener.open(req)
    print(f'Login with "{u}": {res.geturl()} (status: {res.status})')
