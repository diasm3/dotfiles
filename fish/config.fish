if status is-interactive
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    
    set -gx PATH $HOME/.local/bin $PATH
    set -gx PATH $HOME/.opencode/bin $PATH
    set -gx PATH $HOME/.bun/bin $PATH
    
    if test -d /opt/homebrew/bin
        set -gx PATH /opt/homebrew/bin $PATH
    end
    
    abbr -a g git
    abbr -a v nvim
    abbr -a ll 'ls -la'
    abbr -a la 'ls -A'
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    
    abbr -a gs 'git status'
    abbr -a gd 'git diff'
    abbr -a ga 'git add'
    abbr -a gc 'git commit'
    abbr -a gp 'git push'
    abbr -a gl 'git pull'
    abbr -a gco 'git checkout'
    abbr -a gb 'git branch'
    abbr -a glog 'git log --oneline --graph'
end
