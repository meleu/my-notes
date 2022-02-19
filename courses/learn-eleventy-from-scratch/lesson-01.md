# Lesson 1 - Intro

- <https://piccalil.li/course/learn-eleventy-from-scratch/lesson/1/>
- website to be created: <https://issue33.com/>

## TL;DR

```sh
# 1. install node

# 2. create a working dir
mkdir eleventy-from-scratch
cd eleventy-from-scratch

# 3. download starter files
wget https://piccalilli.s3.eu-west-2.amazonaws.com/eleventy-from-scratch/eleventy-from-scratch-starter-files.zip
unzip *.zip
rm -rf *.zip __MACOSX

# 4. git init and create a .gitignore
git init
curl -L https://gitignore.io/api/node,visualstudiocode,vim,linux,macos,sass,dotenv,windows > .gitignore
```


## Install Node.js

I like to use nvm: <https://github.com/nvm-sh/nvm#installing-and-updating>


## Working dir

```sh
mkdir eleventy-from-scratch
cd eleventy-from-scratch
```

## Starter files

- <https://piccalilli.s3.eu-west-2.amazonaws.com/eleventy-from-scratch/eleventy-from-scratch-starter-files.zip>

Unzip it in the `eleventy-from-scratch` folder. It should look like this:

```
src
├── images
├── people
├── posts
└── work
```

## Dotfiles

Create a `.gitignore` for your `eleventy-from-scratch` folder. Minimum version:

```
# Misc
*.log
npm-debug.*
*.scssc
*.swp
.DS_Store
Thumbs.db
.sass-cache
.env
.cache

# Node modules and output
node_modules
dist
src/_includes/css
```

See also: <https://www.toptal.com/developers/gitignore/api/node,visualstudiocode,vim,linux,macos,sass,dotenv,windows>

