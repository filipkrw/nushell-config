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

export def re:server [] {
  docker exec server yarn workspace @algomo/server gen:all
  docker restart server
}

export def typecheck:server [] {
  docker exec server yarn workspace @algomo/server exec tsc --noEmit
}

export def typecheck:app [] {
  docker exec platform yarn workspace app exec tsc --noEmit
}

export def typecheck:widget [] {
  docker exec platform yarn workspace widget exec tsc --noEmit
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

export def --env lsd [dir?] {
  cd $dir
  ls
}

export def dotenv:mongo [] {
  open .env | lines | where ($it | is-not-empty) | parse "{key}={value}" | where key == "MONGO_CONNECTION_STRING" | last | get value
}
