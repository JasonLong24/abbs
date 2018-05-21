#!/usr/bin/env bash

path=$(pwd)

reset=$(tput sgr0)
red=$(tput setaf 1) 
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6) 
white=$(tput setaf 7)

function newBlog() {
  read -p 'Blog name? ' bName
  echo $bName
  mkdir -p $path/$bName
  touch $path/$bName/.blog
  cd $path/$bName
}

function newFile() {
  if [[ -f .blog ]]; then
    read -p 'File name? ' fName
    mkdir -p $path/$fName 
  else
    echo -e 'This is not a blog directory.\nUse newBlog to initialize a blog.'
  fi
}

function newEntry() {
  if [[ -f ../.blog ]]; then
    read -p 'Entry name? ' eName
    touch $path/$eName.md
    $EDITOR $path/$eName.md
  else
    echo -e 'This is not a blog directory.\nUse newBlog to initialize a blog.'
  fi
}

function list() {
  if [[ -f .blog ]] || [[ -f ../.blog ]]; then
    echo -e 'Layout for current abbs projects \n' 
    dirCount=$(echo */ | wc | awk '{print $2}' | tr -d ' ')
    for ((n=1;n<$dirCount;n++))
    do
      dirname=$(echo */ | tr -d '/' | sed -e 's/build //g' | awk '{print $number}' number=$n)
      filename=$(ls -p --ignore='*~' $dirname | tr -d '.md' | sed 's/^/  | /')
      echo $blue$dirname$reset
      echo -e "$filename"
    done
  else
    echo -e 'This is not a blog directory.\nUse newBlog to initialize a blog.'
  fi
}

function compile() {
  if [[ -f .blog ]]; then
    if [[ -d build ]]; then
      rm -f $path/build/*.html
    else
      mkdir $path/build
    fi
    
    dirCount=$(echo */ | wc | awk '{print $2}' | tr -d ' ')
    echo $fileCount
    for ((n=1;n<$dirCount;n++))
    do
      echo Test $n
      filename=$(echo */ | tr -d '/' | sed -e 's/build //g' | awk '{print $number}' number=$n)
      echo $filename
      pandoc -f markdown -t html5 -o build/$filename.html $filename/*.md -c style.css
    done
    
  fi
}

"$@"
