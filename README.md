# Automatic Blog Building System
abbs is a blazing fast and simple blogging system.

## Installation
#### Dependencies
- [Pandoc](https://github.com/jgm/pandoc)

Symlink abbs.sh to `/usr/bin`
```
ln -s abbs.sh /usr/bin
```

## Usage

See example

```
  Usage: abbs [COMMAND] [OPTION]

  newBlog              Creates a new Blog directory and initializes it.
  newDir               Creates a new sub-blog direcotry that is compiled into its own html file.
  newEntry             Creates a new Blog entry in the directory you are in.
  list                 A Tree layout for your current blog setup.
  delete [OPTION]      Easy way to delete Entries, Blogs, or Directories.
      -f               Lists only files.
      -d               Lists only directories.
      -a               Lists everything in your blog.
  edit                 Easy way to edit files in blog setup.
  compile [OPTION]     Compiles your blog into the build directory of the project.
      -s               Path to a style sheet anywhere on your computer.
      -d               Path to directory of theme.
```

## Update

Just pull from the master branch of this project. The symlink should update.
```
git pull origin master
```
