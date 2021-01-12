# git
[✏️](https://github.com/meleu/my-notes/edit/master/git.md)

## copy of the remote repository

You cloned a repo, changed some stuff and then regretted. The only thing you want is an exact copy of the remote repo.

Don't 'rm -rf' and clone the repo again!

here's the command you want:

```sh
git reset --hard origin/master
# git reset --hard <repo>/<branch>
```

## testing a pull request

source: <https://blog.scottlowe.org/2015/09/04/checking-out-github-pull-requests-locally/>
```
git fetch origin pull/1234/head:pr-1234
git checkout pr-1234
```
explanation:

- The `origin` in this case refers to the Git remote for this repository on GitHub. If you are using the fork-and-pull method of collaborating via Git and GitHub, then you will have multiple Git remotes—and the remote you want probably isn’t origin. For example, if you want to fetch a pull request from the original (not forked) repository, you’d want to use the name that corresponds to the Git remote for the original repository (I use `upstream` in these cases).
- The `pull/1234/head` portion refers to the pull request on GitHub.
- The `:pr-1234` portion of the command points to the local branch into which you’d like the specified pull request to be fetched.
