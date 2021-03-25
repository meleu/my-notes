# gitflow
[✏️](https://github.com/meleu/my-notes/edit/master/gitflow.md)

## installing

```sh
sudo apt install git-flow
```

## basic usage

Init the repo for gitflow usage:

```sh
#######################################
# INIT
#######################################
# init the repo for gitflow usage:
git flow init
# It'll ask some questions, you can leave everything as default.
# In the end you'll be on the develop branch by defaul

#######################################
# NEW FEATURE
#######################################
# starting a new branch (named 'sum') for a new feature:
git flow feature start sum
# It'll automatically put you in the branch 'feature/sum'

# create/edit your files for the sum feature
touch sum # this is just for this example
# commit your changes
git add sum
git commit -m 'add sum'

# once you're done with your new feature, use gitflow to finish it:
git flow feature finish sum
# This will automatically merge 'feature/sum' into 'develop',
# delete the 'feature/sum', and put you in the branch 'develop'.

#######################################
# NEW RELEASE
#######################################
# starting a new branch for release
git flow release start 0.1.0
# Summary of actions:
# - A new branch 'release/0.1.0' was created, based on 'develop'
# - You are now on branch 'release/0.1.0'

# follow-up actions:
# - bump the hard-coded version, when applied
# - start commiting last-minute fixes, if needed

# when you're done with your changes on the release branch, run:
git flow release finish 0.1.0
# Summary of actions:
# - Latest objects have been fetched from 'origin'
# - Release branch has been merged into 'master'
# - The release was tagged '0.1.0'
# - Release branch has been back-merged into 'develop'
# - Release branch 'release/0.1.0' has been deleted
```

