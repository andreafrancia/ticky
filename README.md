# ticky

Ticky is a PROMPT embeddable timer.

# Install

Place the string <code>'$(~/path/to/ticky display)'</code> somewhere in your `PROMPT` or `RPROMPT`, for example:

````
export RPROMPT="$cur_dir "'$(~/ticky/ticky display)'" "'$(git_cwd_info)'
````

# Usage

````
$ ./ticky usage
Usage:
    ./ticky start
    ./ticky display
    ./ticky squash
````
