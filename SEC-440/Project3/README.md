## Educational Ransomware Encryption Script

### This is for EDUCATIONAL purposes only, not for commercial use

* The script created for project 3, ransom.ps1, is designed to encrpyt files similar to a ransomware process. I am using powershell and openSSL, and am demoing this script on a Windows 10 box. 

* The script, as detailed in the comments of the script, is designed to create a random key on a compromised system and encrypt it using our public key. Then, our job is to delete this new key and encrypt a targeted directory of files, change their file extension, and delete the originals. Lastly, once we receive our "payment", we need to decrypt the files. 




