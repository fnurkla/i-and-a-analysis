#!/usr/bin/env python3
import requests
from bs4 import BeautifulSoup
import time

headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}

jars = []

jars_file = "jars.txt"
with open(jars_file, "a") as outfile:
    for i in range(1, 11):
        url = "https://mvnrepository.com/popular?p=" + str(i)
        page = requests.get(url, headers=headers)

        soup = BeautifulSoup(page.content, "html.parser")

        s = soup.find_all("h2", class_="im-title")

        for entry in s:
            a = entry.find("a")
            entry_url = "https://mvnrepository.com" + a.get("href") + "/latest"
            print("doing " + entry_url)
            entry_page = requests.get(entry_url, headers=headers, allow_redirects=True)
            time.sleep(10)      # No rate limit, plz
            if not entry_page.ok:
                print("you might be rate limited! got " + str(entry_page.status_code))
                continue

            entry_soup = BeautifulSoup(entry_page.content, "html.parser")
            def is_jar_link(tag):
                c = tag.contents
                return len(c) > 0 and c[0] == "jar\n"
            jar_anchor = entry_soup.find(is_jar_link)

            if jar_anchor != None:
                outfile.write(jar_anchor.get("href") + "\n")
            else:
                print("failed")
                outfile.write("# failed to do " + entry_url + "\n")
