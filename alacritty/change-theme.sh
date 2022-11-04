#! /bin/sh

echo "Changing theme: $1"
rm -rf .activetheme.yml
ln -s ./themes/"$1".yml .activetheme.yml
