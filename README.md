# ticky

Ticky is a PROMPT embeddable timer.

# Quick Install

    # download
    git -C clone ~ https://github.com/andreafrancia/ticky.git

    # install
    ln -sf $(pwd)/ticky /usr/local/bin

    # use
    export RPROMPT="$RPROMPT "'$(ticky display)'

# Usage

    $ ./ticky usage
    Usage:
        ./ticky start
        ./ticky display
        ./ticky squash
