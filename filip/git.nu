export alias s = git status -sb
export alias g = git
export alias ga = git add
export alias gaa = git add --all
export alias gapa = git add --patch
export alias gau = git add --update
export alias gb = git branch
export alias gba = git branch -a
export alias gbd = git branch -d
export alias gbl = git blame -b -w
export alias gbnm = git branch --no-merged
export alias gbr = git branch --remote
export alias gbs = git bisect
export alias gbsb = git bisect bad
export alias gbsg = git bisect good
export alias gbsr = git bisect reset
export alias gbss = git bisect start
export alias gc = git commit -v
export alias gc! = git commit -v --amend
export alias gca = git commit -v -a
export alias gca! = git commit -v -a --amend
export alias gcam = git commit -a -m
export alias gcan! = git commit -v -a --no-edit --amend
export alias gcans! = git commit -v -a -s --no-edit --amend
export alias gcb = git checkout -b
export alias gcd = git checkout develop
export alias gcf = git config --list
export alias gcl = git clone --recursive
export alias gclean = git clean -fd
export alias gsm = git switch main
export alias gcmsg = git commit -m
export alias gcn! = git commit -v --no-edit --amend
export alias gco = git checkout
export alias gcount = git shortlog -sn
export alias gcp = git cherry-pick
export alias gcpa = git cherry-pick --abort
export alias gcpc = git cherry-pick --continue
export alias gcs = git commit -S
export alias gcsm = git commit -s -m
export alias gd = git diff
export alias gdca = git diff --cached
export alias gdt = git diff-tree --no-commit-id --name-only -r
export alias gdw = git diff --word-diff
export alias gf = git fetch
export alias gfa = git fetch --all --prune
export alias gfo = git fetch origin
export alias gg = git gui citool
export alias gga = git gui citool --amend
export alias ggpull = git pull origin (git_current_branch)
export alias ggpur = ggu
export alias ggpush = git push origin (git_current_branch)
export alias ggsup = git branch --set-upstream-to=origin/(git_current_branch)
export alias ghh = git help
export alias gignore = git update-index --assume-unchanged
export alias gk = gitk --all --branches
export alias gke = gitk --all (git log -g --pretty=%h)
export alias gl = git pull
export alias glg = git log --stat
export alias glgg = git log --graph
export alias glgga = git log --graph --decorate --all
export alias glgm = git log --graph --max-count=10
export alias glgp = git log --stat -p
export alias glo = git log --oneline --decorate
export alias globurl = noglob urlglobber
export alias glog = git log --oneline --decorate --graph
export alias gloga = git log --oneline --decorate --graph --all
export alias glol = git log --graph --pretty=\%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\ --abbrev-commit
export alias glola = git log --graph --pretty=\%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\ --abbrev-commit --all
export alias glp = _git_log_prettily
export alias glum = git pull upstream main
export alias gm = git merge
export alias gmom = git merge origin/main
export alias gmt = git mergetool --no-prompt
export alias gmtvim = git mergetool --no-prompt --tool=vimdiff
export alias gmum = git merge upstream/main
export alias gp = git push
export alias gpd = git push --dry-run
export def gpoat [...tags] {
	git push origin --all
	git push origin --tags ...$tags
}
export def gpristine [] {
	git reset --hard
	git clean -dfx
}
export alias gpsup = git push --set-upstream origin (git_current_branch)
export alias gpu = git push upstream
export alias gpv = git push -v
export alias gr = git remote
export alias gra = git remote add
export alias grb = git rebase
export alias grba = git rebase --abort
export alias grbc = git rebase --continue
export alias grbi = git rebase -i
export alias grbm = git rebase main
export alias grbs = git rebase --skip
export alias grep = grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}
export alias grh = git reset HEAD
export alias grhh = git reset HEAD --hard
export alias grmv = git remote rename
export alias grrm = git remote remove
export alias grset = git remote set-url
export alias grt = cd (git rev-parse --show-toplevel or echo ".")
export alias gru = git reset --
export alias grup = git remote update
export alias grv = git remote -v
export alias gsb = git status -sb
export alias gsd = git svn dcommit
export alias gsi = git submodule init
export alias gsps = git show --pretty=short --show-signature
export alias gsr = git svn rebase
export alias gss = git status -s
export alias gst = git status
export alias gsta = git stash save
export alias gstaa = git stash apply
export alias gstc = git stash clear
export alias gstd = git stash drop
export alias gstl = git stash list
export alias gstp = git stash pop
export alias gsts = git stash show --text
export alias gsu = git submodule update
export alias gts = git tag -s
export def gtv [] {
	git tag | sort
}
export alias gunignore = git update-index --no-assume-unchanged
export alias gup = git pull --rebase
export alias gupv = git pull --rebase -v
export alias gwch = git whatchanged -p --abbrev-commit --pretty=medium
