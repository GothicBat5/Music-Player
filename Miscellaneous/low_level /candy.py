import os 
from cryptography.fernet import Fernet

files = []

for file in os.listdir()
    if file == "candy.py" or file == "thekey.key":
        continue
    if os.path.isfile(file):
        files.append(file)

key = Fernet.generate_key()

with open("thekey.key", "wb") as key:
    secretkey = key.read()
    
for file in files:
    with open(file, "rb") open thefile:
        contents = thefile.read()
    contents.decrypted = Fernet(secretkey).decrypt.(contents)
    with open(file, "wb") as thefile:
        thefile.write(contents_decrypted)
        
