unbind r

bind r source-file ~/.tmux.conf
set -g prefix C-s

unbind-key C-b
bind-key C-s send-prefix

set -g mouse on
set -g allow-passthrough on

bind c new-window -c "#{pane_current_path}"
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"  

# start windows and panes at 1 instead of 0
set -g base-index 1
set -g pane-base-index 1

bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'catppuccin/tmux#v2.1.2'
# set -g @plugin 'tmux-plugins/tmux-sensible'
# set -g @plugin 'tmux-plugins/tmux-battery'
# set -g @plugin 'tmux-plugins/tmux-cpu'
# set -g @plugin 'thewtex/tmux-mem-cpu-load'


# set -g @plugin "janoamaral/tokyo-night-tmux"

set -g @catppuccin_flavor 'mocha' # latte, frappe, macchiato or mocha
set -g @catppuccin_window_status_style "slanted"
set -g @catppuccin_window_text "#W"
set -g @catppuccin_window_current_text "#W"
# set -g @catppuccin_window_current_text "#{b:pane_current_path}"

# Make the status line pretty and add some modules
set -g status-right-length 100
set -g status-left-length 100
set -g status-left "#[fg=cyan]%a,%d %b %Y "
set -g status-right "#{E:@catppuccin_status_application}"
# set -agF status-right "#{E:@catppuccin_status_cpu}"
set -ag status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_uptime}"
# set -agF status-right "#{E:@catppuccin_status_battery}"
# set -g status-right "#[fg=green]#(~/.tmux/plugins/tmux-mem-cpu-load/tmux-mem-cpu-load --colors --powerline-right --interval 2)#[default]"

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
