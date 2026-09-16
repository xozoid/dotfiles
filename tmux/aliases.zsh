# A persistent tmux session can be reattached from different clients (e.g.
# home over plain SSH with no DISPLAY, work with X11 forwarding), and can
# even have several clients attached at once (e.g. a local terminal plus a
# separate SSH login). tmux's session/global environment is a single value
# shared by the whole session, so it can't tell two simultaneously attached
# clients apart. `#{client_pid}` does: it resolves to the tmux client
# process actually driving *this* pane, and that process's own /proc environ
# holds the real DISPLAY/XAUTHORITY it was started with (or lacks, if it's a
# plain SSH login with no X11 forwarding). Re-read it before every prompt
# since existing panes otherwise keep whatever DISPLAY they had when the
# shell started.
if [[ -n "$TMUX" ]]; then
  _tmux_client_env() {
    local var=$1 pid environ_file
    pid=$(tmux display-message -p '#{client_pid}' 2>/dev/null) || return 1
    environ_file=/proc/$pid/environ
    [[ -r "$environ_file" ]] || return 1
    tr '\0' '\n' < "$environ_file" 2>/dev/null | sed -n "s/^${var}=//p" | head -n1
  }

  _tmux_sync_display() {
    local display xauth
    display=$(_tmux_client_env DISPLAY)
    if [[ -n "$display" ]]; then
      xauth=$(_tmux_client_env XAUTHORITY)
      if [[ -n "$xauth" ]]; then
        DISPLAY="$display" XAUTHORITY="$xauth" timeout 1 xset q >/dev/null 2>&1
      else
        DISPLAY="$display" timeout 1 xset q >/dev/null 2>&1
      fi
      if (( $? == 0 )); then
        export DISPLAY="$display"
        if [[ -n "$xauth" ]]; then
          export XAUTHORITY="$xauth"
        else
          unset XAUTHORITY
        fi
        return
      fi
    fi
    unset DISPLAY XAUTHORITY
  }
  autoload -U add-zsh-hook
  add-zsh-hook precmd _tmux_sync_display
fi
