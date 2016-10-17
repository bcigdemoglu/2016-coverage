# 2016-group-13
## Guidelines
<!-- TOC START min:2 max:5 link:true update:true -->
  - [Guidelines](#guidelines)
      - [Git Guidelines](#git-guidelines)
        - [Git Setup:](#git-setup--)
        - [Getting Started on Feature Branch:](#getting-started-on-feature-branch--)
        - [Continuing work on Feature Branch:](#continuing-work-on-feature-branch)
        - [Deploying Feature Branch to Master Branch:](#deploying-feature-branch-to-master-branch)
        - [Resolve Feature Conflicts on Master Branch:](#resolve-feature-conflicts-on-master-branch)
      - [Heroku Guidelines](#heroku-guidelines)
        - [Heroku Setup:](#heroku-setup)
        - [Remote Heroku Deploy:](#remote-heroku-deploy)
        - [Run Heroku Locally:](#run-heroku-locally)

<!-- TOC END -->

Display commits compact:
```bash
git log --graph --decorate --pretty=oneline --pretty="%h %s"
```
####Git Guidelines

#####Git Setup:  
```bash
git clone https://github.com/jhu-oose/2016-group-13.git
git config --global user.name <UserName>
git config --global user.email <UserEmail>
git config --global push.default simple
git config --global branch.master.rebase true
git config --global branch.autosetuprebase remote
git config --global merge.conflictstyle diff3
git config --global rerere.enabled 1
```

#####Getting Started on Feature Branch:  
```bash
# Create the feature branch for the first time off of the master  
git checkout master  
git checkout -b <FeatureBranchName>  
# Finish coding the feature and make sure tests pass  
git merge origin/master  
# Resolve conflicts and make sure all tests pass   
git commit -am '<MessageAboutChangesMade>  '
# Only for the first time '-u origin <FeatureBranchName>' is required  
git push -u origin <FeatureBranchName>  
```

#####Continuing work on Feature Branch:
```bash
git checkout <FeatureBranch>  
git pull  
git merge origin/master     
# Resolve conflicts and make sure all tests pass  
# Make new changes  
git merge origin/master  
# Resolve conflicts and make sure all tests pass  
git commit -am '<MessageAboutNewChangesMade>'  
git push
```

#####Deploying Feature Branch to Master Branch:
```bash  
git checkout master
git pull origin/master
# Make sure the feature branch passes all tests and is pushed  
git merge origin/<FeatureBranchName>  
# This must not raise any conflicts  
# If conflicts arise, run "Resolve Feature Conflicts on Master Branch"  
# Re-run 'git merge origin/<FeatureBranchName>'  
```

#####Resolve Feature Conflicts on Master Branch:
```bash
git reset --hard origin/master  
git checkout <FeatureBranchName>  
git merge origin/master   
# Resolve conflicts and run all tests  
git push  
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
