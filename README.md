# Automatic Blog Building System
abbs is a blazing fast and simple blogging system.

## Installation
#### Dependencies

- [Pandoc](https://github.com/jgm/pandoc)

Run the `install.sh` script.
```
./install.sh
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

Config file `.blog`

```
# Generate index.html
index = true
# Last updated footer
footer = true
```

## Update

Run the `install.sh` script with the -u argument.
```
./install.sh -u
```
