#!/usr/bin/env zsh

function theme() {
    # this array is defined as (shell_theme vim_theme shell_theme vim_theme [...])
    # The concept is the same as Greg Hurrel's colors function, but since base16-vim is messed up on
    # my setup, I'm temporarily using this hardcoded list
    typeset -A theme_list
    theme_list=("gruvbox-dark-soft" "gruvbox" "gruvbox-dark-medium" "gruvbox" "dracula" "dracula")
    if [[ $# -eq 0 ]]; then
        e_info "Current theme: ${ZSH_BASE16_THEME}"
        e_line
        e_info "Available themes:"
        echo "  - ${(j:\n  - :)theme_list}"
        return 0
    fi
    local selected_theme="$1"
    local previous_theme=$ZSH_BASE16_THEME
    if [[ ${selected_theme} == "-" ]]; then
        selected_theme=${ZSH_BASE16_PREVIOUS_THEME}
        previous_theme=${ZSH_BASE16_THEME}
    fi
    if [[ ${selected_theme} == ${previous_theme} ]]; then
        exit 0
    fi
    vim_theme_name=${theme_list[${selected_theme}]}
    local theme_location="${BASE16_SHELL}/scripts/base16-${selected_theme}.sh"
    if [[ ! -f "${theme_location}" ]]; then
        e_error "The theme ${YELLOW}${selected_theme}${RED} doens't exists"
        return 1
    fi
    echo "export ZSH_BASE16_THEME='${selected_theme}'" | tee ~/.zsh_base16_theme > /dev/null
    echo "export ZSH_BASE16_PREVIOUS_THEME='${previous_theme}'" | tee -a ~/.zsh_base16_theme > /dev/null
    if [[ -n "$vim_theme_name" ]]; then
        echo "if !exists('g:colors_name') || g:colors_name != '${vim_theme_name}'" | tee ~/.vimrc_bg > /dev/null
        echo "  colorscheme ${vim_theme_name}" | tee -a ~/.vimrc_bg > /dev/null
        echo "endif" | tee -a ~/.vimrc_bg > /dev/null
    fi
    source ${theme_location}
    source ~/.zsh_base16_theme
}
