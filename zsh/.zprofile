# zsh/.zprofile

# Sourced on login shells only
# For linux, the Display Manager (e.g. GDM or SDDM) will source this so things
# will be available to the desktop env
# Sourced after .zshenv and before .zshrc
# macOS always starts a login shell.

export KZ_SOURCE="${KZ_SOURCE} -> zsh/.zprofile {"
KZ_SOURCE="${KZ_SOURCE} }"
