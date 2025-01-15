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
  git reset --hard "origin/$branch"
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

export def create-html [] {
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

export def tsc:server [] {
  docker exec server yarn workspace @algomo/server exec tsc --noEmit
}

export def tsc:app [] {
  docker exec platform yarn workspace app exec tsc --noEmit
}

export alias za = zoxide add
export alias zr = zoxide remove

export def pull-config [] {
  git -C $nu.default-config-dir pull
}