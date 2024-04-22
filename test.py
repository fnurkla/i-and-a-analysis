#!/usr/bin/env python3

import sys
import subprocess
import os

jd_path = "jdepend-2.10/lib/jdepend-2.10.jar"

if not os.path.isfile(jd_path):
    jd_link = "https://github.com/clarkware/jdepend/releases/download/2.10/jdepend-2.10.zip"
    zip_name = "jdepend.zip"
    subprocess.run(["wget", "--output-document", zip_name, jd_link])
    subprocess.run(["unzip", zip_name])
    subprocess.run(["rm", zip_name])

if not os.path.isfile(jd_path):
    raise

dl_dir = "dls"
out_dir = "out"
subprocess.run(["mkdir", "-p", dl_dir, out_dir])

filename = sys.argv[1]          # File with one jar dl link on each line

with open(filename, 'r') as file:
    lines = file.readlines()

for line in lines:
    url = line.strip()
    s = [string for string in line.strip().split("/") if string != ""]
    if len(s) == 0:
        continue
    name = s[-1]
    dir_name = name + ".d"

    if not os.path.isdir(dir_name): # If we lack some jar, download and unzip it
        os.chdir(dl_dir)
        subprocess.run(["wget", "--output-document", name, url])
        subprocess.run(["unzip", name, "-d", dir_name])
        subprocess.run(["rm", name])
        os.chdir("..")

    output = subprocess.run(["java",
                    "-cp", ".:" + jd_path,
                    "jdepend.textui.JDepend",
                    dl_dir + "/" + dir_name], capture_output=True)

    output = output.stdout.decode("utf8") # Decode output bytes into a string
    
    output_chunks = output.split("\n\n")

    outfile_name = out_dir + "/" + name + ".txt"

    with open(outfile_name, "w") as outfile:
        outfile.write(output_chunks[-1])

