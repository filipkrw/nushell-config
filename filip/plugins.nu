const plugins = [
    nu_plugin_polars
    nu_plugin_gstat
    nu_plugin_query
    nu_plugin_regex
    nu_plugin_clipboard
    nu_plugin_compress
];

export def install_my_plugins [] {
    $plugins | each { cargo install $in --locked } | ignore
}

export def register_my_plugins [] {
    $plugins | each { 
        if $nu.os-info.name == "windows" {
            plugin add ~/.cargo/bin/($in + ".exe")
        } else {
            plugin add ~/.cargo/bin/($in)
        }
    } | ignore
}