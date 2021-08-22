#!/usr/bin/env python
import os
import requests
from datetime import datetime
from urlextract import URLExtract


def imagePull():

    jsonUrl = 'https://arc.msn.com/v3/Delivery/Placement?pid=209567&fmt=json&ua=WindowsShellClient%2F0&cdm=1&pl=en-US&lc=en-IN&ctry=in&time=' + \
        str(datetime.utcnow().isoformat(timespec='seconds')) + 'Z'
    r = requests.get(jsonUrl)
    json = r.json()
    url = json['batchrsp']['items'][0]['item']
    url = URLExtract().find_urls(url)[0]
    return url


def setSpotlight(url):
    r = requests.get(url)
    furl = os.path.join(os.path.expanduser("~"), '.spotlight.jpg')
    open(furl, 'wb').write(r.content)
    os.path.isfile(furl)
    cmd = 'kwriteconfig5 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file://' + furl + '"'
    os.system(cmd)
    # For SDDM /usr/share/sddm/themes/<theme>/theme.conf.user background=<full_path>


if __name__ == '__main__':
    url = imagePull()
    setSpotlight(url)
