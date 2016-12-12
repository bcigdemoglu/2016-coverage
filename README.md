[![Build Status](https://travis-ci.com/jhu-oose/2016-group-13.svg?token=fuXm9fRdis1gWqh7sYen&branch=master)](https://travis-ci.com/jhu-oose/2016-group-13)
[![codecov](https://codecov.io/gh/mbugrahanc/oose-2016-coverage/branch/master/graph/badge.svg?token=Tika9gx4FK)](https://codecov.io/gh/mbugrahanc/oose-2016-coverage)
# 2016-group-13

## Quickstart
### Run local tests & View coverage
Run from root '/'
```bash
# Install mongodb https://docs.mongodb.com/v3.2/installation/
[sudo] pip install virtualenv
web/local
```

## Guidelines
<!-- TOC START min:2 max:5 link:true update:true -->
  - [Quickstart](#quickstart)
    - [Run local tests & View coverage](#run-local-tests--view-coverage)
  - [Guidelines](#guidelines)
      - [Heroku Guidelines](#heroku-guidelines)
        - [Heroku Setup:](#heroku-setup)
        - [Remote Heroku Deploy:](#remote-heroku-deploy)
        - [Run Heroku Locally:](#run-heroku-locally)

<!-- TOC END -->

Display commits compact:
```bash
git log --graph --decorate --pretty=oneline --pretty="%h %s"
```

####Heroku Guidelines

#####Heroku Setup:
```bash
heroku login  
heroku git:remote -a oose-2016-group-13
```

#####Remote Heroku Deploy:
```bash
# Call from the root
git push heroku `git subtree split --prefix web master`:master --force
heroku deploy
heroku ps:scale web=1
```

#####Run Heroku Locally:
```bash
heroku local
```
