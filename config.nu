$env.config.show_banner = false
$env.config.buffer_editor = "nvim"

# Completions
use nu_scripts/custom-completions/git/git-completions.nu *
use nu_scripts/custom-completions/docker/docker-completions.nu *
use nu_scripts/custom-completions/npm/npm-completions.nu *
use nu_scripts/custom-completions/ssh/ssh-completions.nu *
use nu_scripts/custom-completions/pnpm/pnpm-completions.nu *
use nu_scripts/custom-completions/yarn/yarn-v4-completions.nu *
use nu_scripts/custom-completions/man/man-completions.nu *
use nu_scripts/custom-completions/just/just-completions.nu *
use nu_scripts/custom-completions/curl/curl-completions.nu *
use nu_scripts/custom-completions/cargo/cargo-completions.nu *
use nu_scripts/custom-completions/vscode/vscode-completions.nu *
use nu_scripts/custom-completions/make/make-completions.nu *

# Snippetos
source filip/snippetos.nu