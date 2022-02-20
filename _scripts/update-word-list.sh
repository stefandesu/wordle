#!/bin/sh

# Downloads the NYT version of Wordle, extracts the word lists (answers + allowed words), and updates our main JS file with this list
# Note that this is a very rudimentary script and probably will break at some point...

url_base=https://www.nytimes.com/games/wordle
url_index=$url_base/index.html

folder=./nyt_wordle

mkdir -p $folder

# Download NYT Wordle index.html
curl $url_index --output $folder/index.html
# Figure out name of JS file
hash=$(sed -n "s/^.*main\.\(.*\)\.js.*$/\1/p" $folder/index.html)
# Download JS file
url_js=$url_base/main.$hash.js
curl $url_js --output $folder/main.js

# Extract answer list
answers=$(cat $folder/main.js | grep -Eo '\["cigar",[^]]*\]')
allowed=$(cat $folder/main.js | grep -Eo '\["aahed",[^]]*\]')

# ...
hash=$(sed -n "s/^.*main\.\(.*\)\.js.*$/\1/p" ./index.html)
mv ./main.$hash.js ./main.$hash.js.old
sed "s/\[\"cigar\",[^]]*\]/$answers/g" ./main.$hash.js.old > ./main.$hash.js.1
sed "s/\[\"aahed\",[^]]*\]/$allowed/g" ./main.$hash.js.1 > ./main.$hash.js
rm ./main.$hash.js.old
rm ./main.$hash.js.1

rm -r $folder
