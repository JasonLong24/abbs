#!/usr/bin/env bash

path=$(pwd)
files=$(find . -path ./build -prune -o -name '*.md' -type f -printf "%T@ %p\n" | cut -d\  -f2- | nl -w2)
directories=$(find . -type d | tr -d "./" | grep -vwE build | nl -w2)

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

function newDir() {
  if [[ -f .blog ]]; then
    read -p 'Dir name? ' fName
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
      filename=$(ls -p --ignore='*~' $dirname | tr -d '.md' | sed 's/^/\t   | /' )
      echo -e "$n\t$blue$dirname$reset \n$filename" 
    done
  else
    echo -e 'This is not a blog directory.\nUse newBlog to initialize a blog.'
  fi
}

function delete() {
  if [[ -f .blog ]]; then
    if [[ $1 = "-a" ]];then 
      list
      printf "\n"
      read -p 'Pick the directory or the directory of the file you want to delete. ' delHead
      printf "\n" && printf "\n"

      delDir=$(echo */ | tr -d '/' | sed -e 's/build //g' | awk '{print $number}' number=$delHead)
      delFile=$(ls -p --ignore='*~' $delDir | tr -d '.md' | sed 's/^/\t   | /' )

      echo -e "\t$blue$delDir$reset\n$delFile" | nl
      read -p 'Select the file or directory to delete. ' selection

        if [[ $selection = 1  ]]; then
          rm -rf $delDir 
          echo "Deleted $delDir... "
        else
          file=$(ls -lp --ignore='*~' $delDir | awk NR==$selection'{print $9}' sel=$selection) 
          rm $delDir/$file
          echo "Deleted $file... " 
        fi

    elif [[ $1 = "-f" ]]; then
      echo -e "All Entries.\n"
      echo -e "$files"
      printf '\n'
      read -p 'Pick the file you want to delete. ' filePick

      rm $(echo "$files" | awk NR==$filePick'{print $2}')
      echo Deleted $(echo "$files" | awk NR==$filePick'{print $2}')...

    elif [[ $1 = "-d" ]]; then
      echo -e "All Directories."
      echo -e "$directories"
      printf '\n'
      read -p 'Pick the directory you want to delete. ' dirPick

      rm -rf $(echo "$directories" | awk NR==$dirPick+1'{print $2}')
      echo Deleted $(echo "$directories" | awk NR==$dirPick+1'{print $2}')...
    fi
  else
    echo -e 'This is not a blog directory.\nUse newBlog to initialize a blog.'
  fi
}

function edit() {
  if [[ -f .blog ]]; then
    echo -e "All Entries.\n"
    echo -e "$files"
    printf '\n'
    read -p 'Pick the file you want to edit. ' filePick

    /usr/bin/time --format='\nEdit Time: %es' $EDITOR $(echo "$files" | awk NR==$filePick'{print $2}')
  fi
}

function compile() {
  if [[ -f .blog ]]; then
    if [[ -d build ]]; then
      rm -f $path/build/*.html
      rm -f $path/build/*.css
    else
      mkdir $path/build
    fi

    if [[ $1 = "-s" ]]; then
      cp $2 $path/build/style.css 
    fi

    read -p "Do you want to generate an index.html file? (y/n)" -n 1;
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      touch build/index.html
      echo -e "<link rel="stylesheet" href="style.css">" >> build/index.html
      echo -e "<div class=\"toc-container\">" >> build/index.html
      echo -e "<p class=\"toc-title\">Blogs</p>" >> build/index.html
      echo -e "<ul class=\"toc\">" >> build/index.html
    fi

    dirCount=$(echo */ | wc | awk '{print $2}' | tr -d ' ')
    echo $fileCount
    for ((n=1;n<$dirCount;n++))
    do
      filename=$(echo */ | tr -d '/' | sed -e 's/build //g' | awk '{print $number}' number=$n)
      echo Compiling... $filename
      pandoc -f markdown -t html5 -o build/$filename.html $filename/*.md -c style.css

      if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "\t <li><a href="$filename.html">"$filename"</a></li>" >> build/index.html
      fi

      tocCount=$(cat $filename/*.md | grep "#" | grep -v "##" | awk '{$1=""; print $0}' | wc -l)
      sectionCount=""
      count=1
      sed -i '1s@^@</div>\n@' build/$filename.html
      sed -i '1s@^@</ul>\n@' build/$filename.html
      for ((i=1;i<=$tocCount;i++)); do
        tocItems=$(cat $filename/*.md | grep "#" | grep -v "##" | awk '{$1=""; print $0}' | awk FNR==$i | awk '{$1=$1};1')
        if [[ $(echo $tocItems | head -c1) =~ ^[0-9]+$ ]]; then
           output="<li class=\"toc-items\"><a href=\"#section$sectionCount\">$i\t$tocItems</a></li>"
           sed -i "1s@^@$output\n@" build/$filename.html 
           sectionCount="-"$count
           count=$((count+1))
         else
           output="<li class=\"toc-items\"><a href=\"#$(echo $tocItems | tr '[:upper:]' '[:lower:]' | tr ' ' '-')\">$i\t$tocItems</a></li>"
           sed -i "1s@^@$output\n@" build/$filename.html 
         fi
      done
      sed -i '1s@^@<ul id=\"toc\">\n@' build/$filename.html
      sed -i '1s@^@<input type=\"text\" id=\"contentsFilter\" onkeyup=\"filter()\" placeholder=\"Search Posts... \">\n@' build/$filename.html
      sed -i '1s@^@<p class=\"toc-title\">Contents</p>\n@' build/$filename.html
      sed -i '1s@^@<div class=\"toc-container\">\n@' build/$filename.html
      sed -i '1s@^@<script charset=\"utf-8\" src=\"filter.js\"></script>\n@' build/$filename.html
    done

    if [[ -f build/index.html ]]; then
      echo "</ul>" >> build/index.html 
      echo "</div>" >> build/index.html 
    fi

  fi
}

function help() {
  echo -e Usage: abbs [COMMAND] [OPTION]"\n"
  echo -e "newBlog              Creates a new Blog directory and initializes it."
  echo -e "newDir               Creates a new sub-blog direcotry that is compiled into its own html file."
  echo -e "newEntry             Creates a new Blog entry in the directory you are in."
  echo -e "list                 A Tree layout for your current blog setup."
  echo -e "delete [OPTION]      Easy way to delete Entries, Blogs, or Directories."
  echo -e "    -f               Lists only files."
  echo -e "    -d               Lists only directories."
  echo -e "    -a               Lists everything in your blog."
  echo -e "edit                 Easy way to edit files in blog setup."
  echo -e "compile [OPTION]     Compiles your blog into the build directory of the project."
  echo -e "    -s               Path to a style sheet anywhere on your computer."
}

"$@"
