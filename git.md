# git
[✏️](https://github.com/meleu/my-notes/edit/master/git.md)

## links

- <https://github.com/eficode-academy/git-katas> - deliberate git practice

### egghead.io

- <https://egghead.io/q/git>

### gitflow

- Interesting video (portuguese): <https://www.youtube.com/watch?v=wzxBR4pOTTs>
- Good doc: <https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow>
- cheatsheet: <https://danielkummer.github.io/git-flow-cheatsheet/index.html>


## getting the latest commit hash

```sh
git log origin/master --max-count=1 --no-merges --format='format:%h'

# git log <repo>/<branch> --max-count=1 --no-merges --format='format:%h'
```

For more info about formatting see `man git log`.

## copy of the remote repository

You cloned a repo, changed some stuff and then regretted. The only thing you want is an exact copy of the remote repo.

Don't 'rm -rf' and clone the repo again!

here's the command you want:

```sh
git reset --hard origin/master
# git reset --hard <repo>/<branch>
```


### edit Pull Requests

Tip obtained from: <https://ardupilot.org/dev/docs/editing-prs.html>

**Assumptions**:
- you have the main repository cloned locally
- you have permission to modify the PR

```sh
# 1. Setup a remote to the requester's repository.
# In this example we're using `tempremote`
$ git remote add tempremote https://github.com/username/repository.git
# using the SSH address also works: git@github.com:username/repository.git

# 2. Pull down the code from the branch used in the PR.
# example: `xyz`
$ git fetch tempremote xyz

# 3. Create a local branch with a copy of the PR
# example: username-xyz
$ git checkout -b username-xyz tempremote/xyz

# 4. Make you changes and commit them.

# 5. Push your changes to the branch used in the PR.
$ git push tempremote HEAD:xyz

# 6. Once it's all done, you can delete your `username-xyz` local branch
#    and remove `tempremote` from the list of remote repositories.
$ git branch -d username-xyz
$ git remote remove tempremote
```


## testing a pull request

```sh
git fetch origin pull/1234/head:pr-1234
git checkout pr-1234

# git fetch <repo> pull/<pr-id>/head:<local-branchname>
# git checkout <local-branchname>
```


## have multiple gitconfigs for different directories/clients (`includeIf`)

If you work for multiple clients - or if you work for a company and contribute to open source projects - you probably already faced the situation where you made a git commit with the wrong account. Now the github commit history has your real name and your work email... :/

A good solution for this is to:

1. have a specific dir for a specific customer's source code and
2. have a specific gitconfig to be applied to all git repositories inside that directory.

Let's just do that:

```bash
# creating specific dirs
mkdir -p ~/src/client1
mkdir -p ~/src/client2

# gitconfig for client1
echo "
[user]
  email = meleu.dev@client1.com
  name = meleu" > ~/src/client1/gitconfig

# gitconfig for client2
echo "
[user]
  email = meleu.dev@client2.com
  name = meleu" > ~/src/client2/gitconfig
```

Once each directory has its own gitconfig, now we must setup the global `.gitconfig` to apply them at specific situations using `includeIf`:

```
# add this to your ~/.gitconfig

[includeIf "gitdir:~/src/client1/**"]
  path = ~/src/client1/gitconfig

[includeIf "gitdir:~/src/client2/**"]
  path = ~/src/client2/gitconfig
```

Once it's done, your configuration in `~/src/client1/gitconfig` will be applied to all cloned repositories inside that directory (same for `client2`).



