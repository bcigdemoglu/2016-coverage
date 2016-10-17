# 2016-group-13

Display commits nicely:
```bash
git log --graph --decorate --pretty=oneline --pretty="%h %s"
```

Deploy to Heroku:
```bash
git push heroku `git subtree split --prefix web master`:master --force
```
