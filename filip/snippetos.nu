export def exec:it [container: string, command: string] {
  docker exec -it $container $command
}

export def git:current [] {
  git rev-parse --abbrev-ref HEAD
}

export def git:reset:file [filename: string] {
  git checkout HEAD -- $filename
}

export def git:pick [commit: string] {
  git cherry-pick $commit
}

export def git:uncommit [] {
  git reset HEAD~
}

export def git:unfuck [branch: string] {
  git fetch origin $branch
  git reset --hard $"origin/($branch)"
}

export def git:refi [base_branch, file_path] {
  let common_commit_hash = git merge-base HEAD $base_branch
  git checkout $common_commit_hash -- $file_path
}

export def exec:sh [container: string] {
  docker exec -it $container sh
}

export def exec:bash [container: string] {
  docker exec -it $container bash
}

export def --wrapped d:up [...args] {
  docker compose up ...$args
}

export def --wrapped d:build [...args] {
  docker compose build ...$args
}

export def --wrapped d:rb [...args] {
  docker compose build ...$args; docker compose up ...$args
}

export def --wrapped d:stop [...args] {
  docker stop ...$args
}

export def no_modules [] {
    ls **/node_modules --directory | each { |item| rm -rf $item.name }                                                                                                
}

export def chmod:get [filename: string] {
  stat -f "%OLp" $filename
}

export def git:untrack [...files] {
  git rm -r --cached $files
}

export def k [...args] {
  minikube kubectl -- $args
}

export def git:rename [branch: string] {
  git branch -m $branch
}

export def "git+" [...args] {
  git checkout -b ...$args
}

export def boxbox [...args] {
  ssh ...$args
}

export def htmxd [] {
    if (ls | where name == "index.html" | length) == 0 {
        let doc = '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    Hello World!
</body>
</html>'

        $doc | save index.html
    }

    bunx live-server index.html
}

export def git:logp [] {
  git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD -n 25 | lines | split column "»¦«" commit subject name email date | upsert date {|d| $d.date | into datetime} | sort-by date | reverse
}

export def fcode [] {
  let output = fzf --height 60% --layout reverse --border | str trim
  if (not ($output | is-empty)) {
    code - $output
  }
}

export def fnvim [] {
  let output = fzf --height 60% --layout reverse --border | str trim
  if (not ($output | is-empty)) {
    nvim $output
  }
}

export def fz [] {
  let output = fzf --height 60% --layout reverse --border | str trim
  $output
}

export def fzo [command: string] {
  let output = fzf --height 60% --layout reverse --border | str trim
  if (not ($output | is-empty)) {
    ^$command $output
  }
}

export def --wrapped gitp [...args] {
  git --no-pager ...$args
}

export alias za = zoxide add
export alias zr = zoxide remove

export alias test:server = docker exec server yarn workspace @algomo/server test 

export def to_iso [date: datetime] {
  $date | format date "%Y-%m-%dT%H:%M:%S.%f" | str substring 0..22 | $in + "Z"
}

export def push-config [msg?: string] {
  cd $nu.default-config-dir
  git add -A
  if ($msg | is-not-empty) {
    git commit -m $msg
  } else {
    git commit -m $"(date now | to_iso $in) sync"
  }
  git push
}

export def pull-config [] {
  cd $nu.default-config-dir
  git pull
}

export def proxy [port: string] {
  tmux kill-session -t proxy o+e>| ignore | tmux new-session -s proxy $"ssh proxy -R 8080:localhost:($port) 'sudo tail -n 100 -f /var/log/nginx/access.log'"
}

export def cap [] {
  if ($in | is-not-empty) {
    $in | to msgpack | save -f ($nu.default-config-dir + "/stash.msgpack")
    $in
  }
}

export def rel [] {
  if (($nu.default-config-dir + "/stash.msgpack") | path exists) {
    open ($nu.default-config-dir + "/stash.msgpack") | from msgpack
  }
}

alias core-cd = cd

export def --env cd [dir?] {
  core-cd $dir
  ls
}

export def dotenv:mongo [] {
  open .env | lines | where ($it | is-not-empty) | parse "{key}={value}" | where key == "MONGO_CONNECTION_STRING" | last | get value
}

export alias j = just

export def create-polars [name: string] {
  print $"Setting up in \"($name)\"..."
  mkdir $name; cd $name
  mkdir input output
  touch input/.gitkeep output/.gitkeep
  cp $"($nu.default-config-dir)/filip/polars_base.ipynb" notebook.ipynb
  ".venv" | save .gitignore

  print "Creating virtual environment..."
  python3 -m venv .venv;
  
  print "Installing dependencies..."
  if ($nu.os-info.name == "windows") {
    .venv/Scripts/pip install ipykernel polars
  } else {
    .venv/bin/pip install ipykernel polars
  }

  print "Done"
}

export def "from env" []: string -> record {
  lines
    | split column '#' # remove comments
    | get column1
    | parse "{key}={value}"
    | update value {
        str trim                        # Trim whitespace between value and inline comments
          | str trim -c '"'             # unquote double-quoted values
          | str trim -c "'"             # unquote single-quoted values
          | str replace -a "\\n" "\n"   # replace `\n` with newline char
          | str replace -a "\\r" "\r"   # replace `\r` with carriage return
          | str replace -a "\\t" "\t"   # replace `\t` with tab
    }
    | transpose -r -d
}

export def venv:create [name?: string] {
  let venv_name = if ($name | is-empty) {
    ".venv"
  } else {
    $name
  }
  
  if ($venv_name | path exists) {
    let activate_path = $"($venv_name)/bin/activate.nu"

    print $"Virtual environment \"($venv_name)\" already exists.\nRun `overlay use ($activate_path)` to activate it.\nRun `venv:delete` to delete it."
    return
  }
  
  virtualenv $venv_name

  let activate_path = $"($venv_name)/bin/activate.nu"
  
  print $"\nVirtual environment \"($venv_name)\" created.\nRun `overlay use ($activate_path)` to activate it."
}

export def venv:delete [name?: string] {
  let venv_name = if ($name | is-empty) {
    ".venv"
  } else {
    $name
  }

  if ($venv_name | path exists) {
    rm -rf $venv_name
    print $"Virtual environment \"($venv_name)\" deleted."
  } else {
    print $"Virtual environment ($venv_name) does not exist. Skipping deletion."
  }
}

# Git
export alias lg = lazygit

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
