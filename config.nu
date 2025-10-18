$env.config = {
    show_banner: false,
    buffer_editor: "nvim",
}

$env.PROMPT_INDICATOR = " "

# Zoxide
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu

# Completions
let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}

let zoxide_completer = {|spans|
    # $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
    $spans | skip 1 | zoxide query -l ...$in | lines | each {|line| $line | str replace $env.HOME '~' } | where {|x| $x != $env.PWD}
}

let completers = {|spans|
    match $spans.0 {
    	z | zi => $zoxide_completer
    	__zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config = {
    completions: {
        external: {
            enable: true
            completer: $completers
        }
    }
}

# Snippetos
$env.snippetos = ($nu.default-config-dir + "/filip/snippetos.nu")
use filip/snippetos.nu *

# Plugins
use filip/plugins.nu *

# Local settings
source (if ("local.nu" | path exists) { "local.nu" } else { "empty.nu" })

