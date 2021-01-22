# gitlab CI/CD
[✏️](https://github.com/meleu/my-notes/edit/master/gitlab.md)

## Udemy Course

- link: <https://www.udemy.com/course/gitlab-ci-pipelines-ci-cd-and-devops-for-beginners>

### Introduction

Create a repo and then add a `.gitlab-ci.yml` file like this:
```yml
# stages: define the order of execution
stages:
  - build
  - test

# list of jobs
build the car:
  # defining which stage this job belongs to
  stage: build
  script:
    - mkdir build
    - cd build
    - touch car.txt
    - echo "chassis" > car.txt
    - echo "engine" >> car.txt
    - echo "wheels" >> car.txt
  artifacts: # artifacts are kept for the next job
    paths:
      - build/

test the car:
  # defining which stage this job belongs to
  stage: test
  script:
    - ls
    - test -f build/car.txt
    - cd build
    - cat car.txt
    - grep "chassis" car.txt
    - grep "engine" car.txt
    - grep "wheels" car.txt
```

**Notes**:
- the filename **must** be `.gitlab-ci.yml`.
- the file **must** be in the root dir of the project.
- the Auto DevOps is NOT enabled (not sure what it means).


#### gitlab architecture

![gitlab architecture](gitlab-architecture.png)

Configuring Runners:
- settings > CI/CD > Runners > Expand


