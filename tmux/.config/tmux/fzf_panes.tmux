#!/usr/bin/env bash

new_window() {
    [[ -x $(command -v fzf 2>/dev/null) ]] || return
    pane_id=$(tmux show -gqv '@fzf_pane_id')
    [[ -n $pane_id ]] && tmux kill-pane -t $pane_id >/dev/null 2>&1
    tmux new-window "bash $0 do_action" >/dev/null 2>&1
}

# invoked by pane-focus-in event
update_mru_pane_ids() {
    o_data=($(tmux show -gqv '@mru_pane_ids'))
    current_pane_id=$(tmux display-message -p '#D')
    n_data=($current_pane_id)
    for i in ${!o_data[@]}; do
        [[ $current_pane_id != ${o_data[i]} ]] && n_data+=(${o_data[i]})
    done
    tmux set -g '@mru_pane_ids' "${n_data[*]}"
}

do_action() {
    trap 'tmux set -gu @fzf_pane_id' EXIT SIGINT SIGTERM
    current_pane_id=$(tmux display-message -p '#D')
    tmux set -g @fzf_pane_id $current_pane_id

    cmd="bash $0 panes_src"
    set -- 'tmux capture-pane -pe -S' \
        '$(start=$(( $(tmux display-message -t {1} -p "#{pane_height}")' \
        '- $FZF_PREVIEW_LINES ));' \
        '(( start>0 )) && echo $start || echo 0) -t {1}'
    preview_cmd=$*
    last_pane_cmd='$(tmux show -gqv "@mru_pane_ids" | cut -d\  -f1)'
    selected=$(FZF_DEFAULT_COMMAND=$cmd fzf -m --preview="$preview_cmd" \
        --preview-window='down:80%' --reverse --info=inline --header-lines=1 \
        --delimiter='\s{2,}' --with-nth=2..-1 --nth=1,2,9 \
        --bind="alt-p:toggle-preview" \
        --bind="ctrl-r:reload($cmd)" \
        --bind="ctrl-x:execute-silent(tmux kill-pane -t {1})+reload($cmd)" \
        --bind="ctrl-v:execute(tmux move-pane -h -t $last_pane_cmd -s {1})+accept" \
        --bind="ctrl-s:execute(tmux move-pane -v -t $last_pane_cmd -s {1})+accept" \
        --bind="ctrl-t:execute-silent(tmux swap-pane -t $last_pane_cmd -s {1})+reload($cmd)")
    (($?)) && return

    ids_o=($(tmux show -gqv '@mru_pane_ids'))
    ids=()
    for id in ${ids_o[@]}; do
        while read pane_line; do
            pane_info=($pane_line)
            pane_id=${pane_info[0]}
            [[ $id == $pane_id ]] && ids+=($id)
        done <<<$selected
    done

    id_n=${#ids[@]}
    id1=${ids[0]}
    if ((id_n == 1)); then
        tmux switch-client -t$id1
    elif ((id_n > 1)); then
        tmux break-pane -s$id1
        i=1
        tmux_cmd="tmux "
        while ((i < id_n)); do
            tmux_cmd+="move-pane -t${ids[i-1]} -s${ids[i]} \; select-layout -t$id1 'tiled' \; "
            ((i++))
        done

        # my personally configuration
        if (( id_n == 2 )); then
            w_size=($(tmux display-message -p '#{window_width} #{window_height}'))
            w_wid=${w_size[0]}
            w_hei=${w_size[1]}
            if (( 9*w_wid > 16*w_hei )); then
                layout='even-horizontal'
            else
                layout='even-vertical'
            fi
        else
            layout='titled'
        fi

        tmux_cmd+="switch-client -t$id1 \; select-layout -t$id1 $layout \; "
        eval $tmux_cmd
    fi
}

panes_src() {
    printf "%-6s  %-7s  %5s  %8s  %4s  %4s  %5s  %-8s  %-7s  %s\n" \
        'PANEID' 'SESSION' 'PANE' 'PID' '%CPU' '%MEM' 'THCNT' 'TIME' 'TTY' 'CMD' # 这里的表头可以保持不变，只是下面的数据可能没有THCNT

    panes_info=$(tmux list-panes -aF \
        '#D #{=|6|…:session_name} #I.#P #{pane_tty} #T' |
        sed -E "/^$TMUX_PANE /d")

    ttys=$(awk '{printf("%s,", $4)}' <<<$panes_info | sed 's/,$//')

    # macOS 兼容的 ps 命令
    # 替换 thcount 为 stats，tname 为 tty，cmd 为 command 或 args
    # 注意：macOS 的 ps -o 选项可能不支持某些组合，需要测试
    # thcount 在 macOS 上没有直接对应，这里暂时用 stat 占位，或者直接移除
    # ps_info=$(ps -t$ttys -o stat,pid,pcpu,pmem,thcount,time,tname,cmd |
    #     awk '$1~/\+/ {$1="";print $0}')
    
    # 尝试使用 macOS 可用的关键字。
    # stat 是状态，pid 是进程ID，%cpu 是CPU使用，%mem 是内存使用，time 是运行时间，tty 是终端名，command 是命令
    # 对于线程数 (THCNT)，macOS ps 没有直接的关键字。您可以选择移除该列或将其替换为另一个可用字段。
    # 这里为了保持列数，我们暂时用 `state` 替代 `thcount`，或者您可以选择移除该列。
    # 另一个选项是使用 `lwp` (lightweight process) 如果您想获取进程内线程的信息，但这可能需要 `ps -M`。
    
    # 我们将尝试一个更兼容 macOS 的 ps 命令：
    ps_info=$(ps -t$ttys -o stat,pid,%cpu,%mem,etime,tty,command | \
        awk '$1~/\+/ {$1=""; print $0}')
    # 注意：etime 是 "elapsed time"，它可能比 "time" 更适合作为运行时间
    # macOS 的 `ps` 默认输出中包含 `TIME` 关键字，但通常是累积的 CPU 时间，而不是实际运行时间（`etime`）。
    # 这里我们移除了 `thcount` 对应的位置。
    # 如果需要 `thcount`，可能需要单独的 `ps -M` 命令和计数。

    ids=()
    hostname=$(hostname)
    for id in $(tmux show -gqv '@mru_pane_ids'); do
        while read pane_line; do
            pane_info=($pane_line)
            pane_id=${pane_info[0]}
            if [[ $id == $pane_id ]]; then
                ids+=($id)
                session=${pane_info[1]}
                pane=${pane_info[2]}
                tty=${pane_info[3]#/dev/} # 移除 /dev/ 前缀
                title=${pane_info[@]:4}
                while read ps_line; do
                    p_info=($ps_line)
                    # p_info 数组索引会因为移除了 `thcount` 而变化
                    # 现在的顺序是：stat, pid, %cpu, %mem, etime, tty, command
                    ps_stat=${p_info[0]} # 状态 (ps -o stat)
                    ps_pid=${p_info[1]} # PID
                    ps_pcpu=${p_info[2]} # %CPU
                    ps_pmem=${p_info[3]} # %MEM
                    ps_time=${p_info[4]} # TIME (etime)
                    ps_tty=${p_info[5]} # TTY
                    ps_cmd_start_index=6 # command 从第6个索引开始

                    if [[ "$tty" == "$ps_tty" ]]; then # 确保是同一个 TTY
                        # 打印输出，调整参数以匹配新的 ps_info 结构
                        # 我们将 THCNT 列替换为 ps_stat 的值，但它不再是线程数。
                        # 或者您可以直接打印一个占位符，或完全移除该列。
                        # 这里我们暂时将其留空或使用其他可用的固定值
                        printf "%-6s  %-7s  %5s  %8s  %4s  %4s  %5s  %-8s  %-7s  " \
                            "$pane_id" "$session" "$pane" "$ps_pid" "$ps_pcpu" "$ps_pmem" "" "$ps_time" "$ps_tty"
                            # 将 THCNT 位置留空 "" 或根据需要填充

                        cmd=${p_info[@]:$ps_cmd_start_index} # 从正确的位置提取命令

                        # vim path of current buffer if it setted the title
                        if [[ "$cmd" =~ ^n?vim && "$title" != "$hostname" ]]; then
                            cmd_arr=($cmd)
                            cmd="${cmd_arr[0]} $title"
                        fi
                        echo "$cmd"
                        break
                    fi
                done <<<$ps_info
            fi
        done <<<$panes_info
    done
    tmux set -g '@mru_pane_ids' "${ids[*]}"
}

$@
