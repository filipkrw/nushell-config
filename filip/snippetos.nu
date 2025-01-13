$env.snippetos = ($nu.default-config-dir + "/filip/snippetos.nu")

# Snippetos
def exec:it [container: string, command: string] {
  docker exec -it $container $command
}

def git:current [] {
  git rev-parse --abbrev-ref HEAD
}

def git:reset:file [filename: string] {
  git checkout HEAD -- $filename
}

def git:pick [commit: string] {
  git cherry-pick $commit
}

def git:uncommit [] {
  git reset HEAD~
}

def git:unfuck [branch: string] {
  git fetch origin $branch
  git reset --hard "origin/$branch"
}

def exec:sh [container: string] {
  docker exec -it $container sh
}

def exec:bash [container: string] {
  docker exec -it $container bash
}

def --wrapped d:up [...args] {
  docker compose up ...$args
}

def --wrapped d:build [...args] {
  docker compose build ...$args
}

def --wrapped d:stop [...args] {
  docker stop ...$args
}

def no_modules [] {
    ls **/node_modules --directory | each { |item| rm -rf $item.name }                                                                                                
}

def chmod:get [filename: string] {
  stat -f "%OLp" $filename
}

def git:untrack [...files] {
  git rm -r --cached $files
}

def k [...args] {
  minikube kubectl -- $args
}

def git:rename [branch: string] {
  git branch -m $branch
}

def "git+" [...args] {
  git checkout -b $args
}

def boxbox [...args] {
  ssh ...$args
}

def create-html [] {
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

def git:logp [] {
  git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD -n 25 | lines | split column "»¦«" commit subject name email date | upsert date {|d| $d.date | into datetime} | sort-by date | reverse
}

def fcode [] {
  let output = fzf --height 60% --layout reverse --border | str trim
  if (not ($output | is-empty)) {
    code - $output
  }
}

def fnvim [] {
  let output = fzf --height 60% --layout reverse --border | str trim
  if (not ($output | is-empty)) {
    nvim $output
  }
}

def fz [] {
  let output = fzf --height 60% --layout reverse --border | str trim
  $output
}

def fzo [command: string] {
  let output = fzf --height 60% --layout reverse --border | str trim
  if (not ($output | is-empty)) {
    ^$command $output
  }
}

def --wrapped gitp [...args] {
  git --no-pager ...$args
}

def re:server [] {
  docker exec server yarn workspace @algomo/server gen:all
  docker restart server
}