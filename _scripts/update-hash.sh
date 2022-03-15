#!/bin/sh

# Updates the hash in the main JavaScript file. Should be called manually after changes in that file.

oldhash=$(sed -n "s/\s*window.wordle.hash = '\(.*\)';$/\1/p" index.html | sed "s/^ *//g")
newhash=$(openssl rand -hex 4)

# Replace hash in index.html
mv index.html index.html.old
sed "s/$oldhash/$newhash/g" index.html.old > index.html
rm index.html.old

# Rename .js file
mv "main.$oldhash.js" "main.$newhash.js"
