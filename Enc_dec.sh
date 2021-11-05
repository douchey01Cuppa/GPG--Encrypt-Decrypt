#!/bin/bash


#========================================================
#                                                       ||
#      GPG Enc/Dec shell script                         ||
#=========================================================
#                                                       ||
# Author : IC1101                                       ||
#                                                       ||
# Date Created : 05/11/2021                             ||
#                                                       ||
# Last Modified: 05/11/2021                             ||
#========================================================


# Script to encrypt or decrypt files/directories using "gnupg"

# provides plausibly two ways ; encryption & decryption 
# NOTE: For now this script relies on defulat AES CFB.. might switch to  "--full-generate-key" later


echo "GPG Encrypt shell script  v1.0"

read -p "path to a File/Directory: " enc_obj

read -p "1 For Encryption
 2 For  Decryption:  "  choice

####### Encrypt block START

function encrypt {

if [ -f  $1 ]; then
   echo "It's a file.. Encrypting the file..."
   gpg -c --no-symkey-cache $1 && echo  "Encrypted file stored as ${1##*/}.gpg" #to prevent storing pass cache in memory


elif [ -d $1 ]; then
   echo "You entered a Directory"
   rm -f $1.tar.gz  
   tar czf $1".tar.gz" -C $1  $(ls $1)  2>/dev/null
   gpg -c --no-symkey-cache $1.tar.gz 
   echo  "Encrypted file stored as ${1##*/}.tar.gz.gpg"
    rm -f $1.tar.gz

else
	 echo "Invalid enc_object type detected!!"
fi
} # Encrypt Func block END ----------------------------------------------------


########Decrypt func block  START 

function decrypt  {

if [[ "$1"  == *.tar.gz.gpg ]]; then

    rm -r "${1%.gpg}"
    echo "You entered a Directory"
    gpg --no-symkey-cache $1 
    mkdir -p "${1%%.tar.gz.gpg}" && tar -xzf "${1%.gpg}" 2>/dev/null  && echo "Successfully decrypted directoy"
    
elif [[ $1  == *.gpg  ]]; then
   echo "It's a file.. Decrypting the file..."
   gpg --no-symkey-cache $1 && echo  "File Succefully decrypted!"
else
   echo "Invalid enc_object type detected!!"
fi
}
# Decrypt func Block END -----------------------------
if [ $choice == 1 ]; then 
   encrypt $enc_obj
   
elif [ $choice == 2 ];then 
    decrypt $enc_obj
else 
  echo "invalid choice"    
fi 
exit 0 
