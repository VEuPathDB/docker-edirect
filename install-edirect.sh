#!/bin/bash

# Public domain notice for all NCBI EDirect scripts is located at:
# https://www.ncbi.nlm.nih.gov/books/NBK179288/#chapter6.Public_Domain_Notice

# base="ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect"
base="https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect"

# function to fetch a single file, passed as an argument
FetchFile() {

  fl="$1"

  if [ -x "$(command -v curl)" ]
  then
    curl -s "${base}/${fl}" -o "${fl}"
  elif [ -x "$(command -v wget)" ]
  then
    wget "${base}/${fl}"
  else
    echo "Missing curl and wget commands, unable to download EDirect archive" >&2
    exit 1
  fi
}

# edirect folder to be installed in home directory
cd /usr/local/

# download and extract edirect archive
FetchFile "edirect.tar.gz"
if [ -s "edirect.tar.gz" ]
then
  gunzip -c edirect.tar.gz | tar xf -
  rm edirect.tar.gz
fi
if [ ! -d "edirect" ]
then
  echo "Unable to download EDirect archive" >&2
  exit 1
fi

# remaining executables to be installed within edirect folder
cd edirect

# get path for configuration file assistance commands
DIR=$( pwd )

plt="Linux"

for exc in xtract rchive transmute
  do
    FetchFile "$exc.$plt.gz"
    gunzip -f "$exc.$plt.gz"
    chmod +x "$exc.$plt"
done;

# offer to edit the PATH variable assignment command in configuration files
echo ""
echo "Entrez Direct has been successfully downloaded and installed."
echo ""

