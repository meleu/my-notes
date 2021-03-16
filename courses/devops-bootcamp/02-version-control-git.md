# Version Control with Git

## 1. What is Version Control?

- Developers working on the same code
- Code is hosted centrally on the internet (code repository)
- Every developer has an entire copy of the code locally
- Code is fetched from/pushed to code repo
- Git knows how to merge changes automatically

When contributors take too much time to push code to the remote repository, there's a high chance to happen Merge Conflicts.

A merge conflict happen when same line of code was changed and git can't fix it alone. So it must be solve manually.

The **best practice** to avoid it is to push and pull often to/from remote repository.

**Continuous Integration**: integrate your code changes frequently.

- Breaking changes doesn't affect you until you pulled the new code
- Version control keeps a history of changes
- You can revert commits!
- Each change is labelled with commit message.
 

 ## 2. Basic Concepts of Git

- The most popular version control tool

Parts of git:

- Remote Git Repository: where the code lives
    - UI: to interact with
- Local Git Repository: local copy of the code (in developer's machine)
- History: of code changes (`git log`)
- Staging: changes to commit
- Git clients: to execute git commands


## 3. Setup Git Repository Remote and Local

Main players:
- github
- gitlab

- Platforms where you host your repository
- Most companies have their own git servers (ex.: bitbucket, self-hosted gitlab)
- private vs. public repositories
- public repositories for open source projects
- you can do a lot via the platforms UI

### Local Repository

- Install a git client
  - GUI: <https://git-scm.com/downloads/guis>
  - CLI: <https://git-scm.com/downloads>


- git client needs to be connected with remote platform
- you need authenticate to the server
- your public SSH key must be added to the remote platform
    - this allows us to push/pull to/from the remote repository with no need to provide login/password everytime.

```sh
# cloning a repo
git clone <repository-URL>
```

Inside the repository directory there's a subdir named `.git/`. It has information about the repository and **is used only locally**.


## 4. Working with Git

Working Directory --`git add`--> Staging Area --`git commit`--> Local repository

```sh
# status of local git repo
git status

# add a file to the staging area
git add FILENAME

# commit the files in the staging area to the local repository
git commit

# see the history of changes (commits) in the local repository
git log

# pushing the local repository content to the remote one
git push
```

## 5. Initialize a Git project locally

Project locally is NOT a git repository yet:

```sh
# existing_directory is not yet a git repository
# (meaning: doesn't have a '.git' directory)
cd existing_directory

# say that this is going to be a git repo
git init

# set a remote repository for it
git remote add origin <git-repository-URL>

# adding files to staging area
git add .

# commit to local repo
git commit -m 'Initial commit'

# push to remote setting an upstream branch named 'master'
git push --set-upstream origin master
```