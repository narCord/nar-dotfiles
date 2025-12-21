# alias nar
alias vi='nvim'
alias h='cd /home/nar'


# Esta es la funcion del prompt basico, funciona perfectamente
#function fish_prompt -d "Caca"
#  # Quite $hostname despues de $USER
#  printf '%s@ %s%s%s > ' $USER (set_color $fish_color_cwd) (prompt_pwd --full-length-dirs 99) (set_color normal)
#  # echo (whoami)@(hostname):(pwd) "\$ "
#end

function __git_info
  # Quite $hostname despues de $USER
  # printf '%s@ %s%s%s > ' $USER (set_color $fish_color_cwd) (prompt_pwd --full-length-dirs 99) (set_color normal)
  # echo (whoami)@(hostname):(pwd) "\$ "
        set -l git_info
        if git rev-parse 2>/dev/null
                set -l git_branch (
                        command git symbolic-ref HEAD 2>/dev/null | string replace 'refs/heads/' ''
                        or command git describe HEAD 2>/dev/null
                        or echo unknown
                    )
                set git_branch (set_color -o blue)"$git_branch"
                set -l git_status
                if git rev-parse --quiet --verify HEAD >/dev/null
                        and not command git diff-index --quiet HEAD --
            
                        for i in (git status --porcelain | string sub -l 2 | sort | uniq)
                                switch $i
                                        case "."
                                                set git_status "$git_status"(set_color green)✚
                                        case " D"
                                                set git_status "$git_status"(set_color red)✖
                                        case "*M*"
                                                set git_status "$git_status"(set_color green)✱
                                        case "*R*"
                                                set git_status "$git_status"(set_color purple)➜
                                        case "*U*"
                                                set git_status "$git_status"(set_color brown)═
                                        case "??"
                                                set git_status "$git_status"(set_color red)≠
                                end
                        end
                else
                        set git_status (set_color green):
                end
                set git_info "(git$git_status$git_branch"(set_color white)")"
        end

        echo $git_info
end

function fish_prompt
    set -l git (__git_info)

    if test -n "$git"
        # Cuando estoy en una carpeta con un repo
        # printf '%s@ %s%s%s ✘%s> ' $USER (set_color $fish_color_cwd) (prompt_pwd --full-length-dirs 99) (set_color normal) $git
        # Probando con este
        printf '%s@ %s%s %s✘%s%s> ' $USER (set_color $fish_color_cwd) (prompt_pwd) (set_color red) (set_color normal) $git

        # innecesario
        #echo -n "$git "
    else
        # Cuando no estoy
        printf '%s@ %s%s%s > ' $USER (set_color $fish_color_cwd) (prompt_pwd --full-length-dirs 99) (set_color normal)
        
        # innecesario
        #echo -n (prompt_pwd)" "
    end

    # Creo que esto es innecesario
    # if test $status -eq 0
        #echo -n (set_color green)"x "(set_color normal)
    #else
        #echo -n (set_color red)"y "(set_color normal)
    #end
end

if status is-interactive
    if not set -q TMUX
        tmux attach-session -t default || tmux new-session -s default
    end
end
