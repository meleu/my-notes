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

## 6. Concept of Branches

- Master branch = main branch
    - created by default, when initializing a git repo

The concept of branches exist in order to cleanly divide the work of different developers.

**Best practices** is to create branches for each feature and each bugfix.

Examples:

- `feature/user-auth` - for the user authentication feature
- `bugfix/user-auth-error` - for fixing the error in the user authentication

- big feature branches long open, increase the chance of merge conflicts
- with branches you achieve a stable main branch (which is ready for deployment)

```sh
# show the current branch you're working
git branch

# pulling updates from the remote repository (which may include new branches)
git pull

# switching to another branch
git checkout <branchname>

# creating a new local branch and switch to it right away
git checkout -b <new-branchname>

# pushing the newly created local branch to the remote repo
git push -u origin <new-branchname>
```

**NOTE** before creating a new branch and start working on it, it's import to switch back to `master`, in order to base your branch on master.

Common practice: having the `master` and the `develop` branches

- develop branch: intermediary master
- during sprint: features and bugfixes into dev
- end of sprint: merge into master

### master vs. master+develop

- master only:
    - only master branch for continuous integration/delivery
    - pipeline is triggered whenever feature/bugfix code is merged into master
    - deploying every single feature/bugfix
- master+develop
    - features/bugfixes are collected in dev branch
    - dev branch often becomes "work in progress" branch [not a good practice]

## 7. Merge Requests

- best practice: other developer reviews code changes before merging
- use cases: big feature, junior developer or expertise in different area
- great chance to learn and grow from each other!


## 8. Deleting Branches

Keep only branches that are being actively being worked.

- best practice:
    - delete branch after merging
    - create a new branch when needed

```sh
# delete a branch locally
git branch -d <branchname>

# delete a remote branch
git push <repo> --delete <branchname>
```

## 9. Rebase

When you try to push changes to a repo and the remote repo has a commit (from another dev) you don't have locally, you need to `git pull` and it'll automatically merge the changes into your repo by creating a new commit. This is useful but add some "pollution" to your commit history.

In order to avoid such pollution, use the command `git pull -r`, and it'll just insert the commit you don't have before your commit.

```sh
# avoid "Merge branch..." pollution in commit history
git pull -r
```


## 10. Resolving Merge Conflicts

Happens when more than one developer change code in the same line of a file. Even if you try to `git pull -r` you'll receive a `CONFLICT` message.

When such situation happens YOU must tell git which change to take. Open the file where the conflict happens in your editor and fix the conflicts. And then `git rebase --continue`.

```sh
# pulling remote changes and rebase
git pull -r

# a conflict happens, fix it in your editor

# continue with the rebase
git rebase --continue

# push changes to remote
git push
```
