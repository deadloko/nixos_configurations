#!/usr/bin/env nix-shell 
#! nix-shell -I nixpkgs=/home/death/git/nixpkgs -p openssl -i bash

openssl req -x509 -new -newkey rsa:4096 -sha256 -days 1000 -nodes -out freenode.pem -keyout freenode.pem
openssl x509 -in freenode.pem --outform der | sha1sum -b | cut -d' ' -f1
