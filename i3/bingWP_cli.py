#!/usr/bin/env python
import os
import requests


def getImageUrl():
    jsonUrl = 'https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-in'
    r = requests.get(jsonUrl)
    json = r.json()
    url = json['images'][0]['url']
    url = url.split('&')[0]
    url = 'https://www.bing.com' + url
    return url


def setWallpaper(url):
    r = requests.get(url)
    fname = '.bbg.' + url.split('.')[-1]
    furl = os.path.join(os.path.expanduser("~"), fname)
    open(furl, 'wb').write(r.content)
    os.path.isfile(furl)
    cmd = 'feh --no-fehbg --bg-scale ' + furl
    os.system(cmd)


if __name__ == '__main__':
    url = getImageUrl()
    setWallpaper(url)
