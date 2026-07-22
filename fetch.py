import urllib.request, urllib.error
try:
    print(urllib.request.urlopen('http://localhost:8080/promotions').read().decode('utf-8'))
except urllib.error.HTTPError as e:
    print(e.read().decode('utf-8'))
