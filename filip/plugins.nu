const plugins = [
    nu_plugin_polars
    nu_plugin_gstat
    nu_plugin_query
    nu_plugin_regex
    nu_plugin_clipboard
    nu_plugin_compress
];

export def setup_my_plugins [] {
    $plugins | each {
        let plugin = $in
        cargo install $plugin --locked
        if $nu.os-info.name == "windows" {
            plugin add ~/.cargo/bin/($plugin + ".exe")
        } else {
            plugin add ~/.cargo/bin/($plugin)
        }
    } | ignore

    go install github.com/oderwat/nu_plugin_logfmt@latest
    plugin add ~/go/bin/nu_plugin_logfmt
}
