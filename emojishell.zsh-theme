# emojishell

# Prompt setup
PROMPT='$(current_dir)$(git_prompt_info)$(_git_time_since_commit) %{$reset_color%}%{$fg[cyan]%}➜ %{$reset_color%' 
# Configure the main prompt, including current directory, Git information, and time since last commit.

RPROMPT='%(?.%{$fg[green]%}✔%f.%{$fg[red]%}✘%f)'
# Configure the right prompt (RPROMPT) to display command success/failure indicators.

# Git suffix and prefix
ZSH_THEME_GIT_PROMPT_PREFIX="$fg[green]👾 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✘%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
# Define Git branch and status indicators, including clean and dirty states.

# Additional functions

function current_dir {
  # Settings up current directory and setting max width for it:
  local _max_pwd_length="65"
  local color="cyan" 
  local folder_icon='📁'  # The folder icon emoji

  if [[ "$SOBOLE_THEME_MODE" == 'dark' ]]; then
    color='white'
  fi

  local current_directory="$(basename "$PWD")"

  if [[ $(echo -n "$current_directory" | wc -c) -gt ${_max_pwd_length} ]]; then
    echo "%{$fg_bold[$color]%}%-2~ ... ${folder_icon} %3~%{$reset_color%} "
  else
    echo "%{$fg_bold[$color]%}$current_directory${folder_icon} %{$reset_color%} "
  fi
}
# Function to display the current directory with color adjustments for dark mode.

function _git_time_since_commit() {
  # Only proceed if there is actually a commit.
  if git log -1 > /dev/null 2>&1; then
    # Get the last commit.
    last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null)
    now=$(date +%s)
    seconds_since_last_commit=$((now-last_commit))

    # Totals
    minutes=$((seconds_since_last_commit / 60))
    hours=$((seconds_since_last_commit/3600))

    # Sub-hours and sub-minutes
    days=$((seconds_since_last_commit / 86400))
    sub_hours=$((hours % 24))
    sub_minutes=$((minutes % 60))

    if [ $hours -ge 24 ]; then
      commit_age="${days}d %{$fg[white]%}ago%{$reset_color%}"
    elif [ $minutes -gt 60 ]; then
      commit_age="${sub_hours}h${sub_minutes}m %{$fg[white]%}ago%{$reset_color%}"
    else
      commit_age="${minutes}m %{$fg[white]%}ago%{$reset_color%}"
    fi
    if [[ -n $(git status -s 2> /dev/null) ]]; then
        if [ "$hours" -gt 4 ]; then
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
        elif [ "$minutes" -gt 30 ]; then
            COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
        fi
    else
        COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
    fi

    echo "$COLOR$commit_age%{$reset_color%}"
    else {
    	echo "✭"
    }
  fi
}
# Function to display the time since the last Git commit with color-coded indicators.

# End of theme
