# Version Control with Git

## What is Version Control?

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
 

 ## Basic Concepts of Git

- The most popular version control tool

Parts of git:

- Remote Git Repository: where the code lives
    - UI: to interact with
- Local Git Repository: local copy of the code (in developer's machine)
- History: of code changes (`git log`)
- Staging: changes to commit
- Git clients: to execute git commands


## Setup Git Repository Remote and Local

