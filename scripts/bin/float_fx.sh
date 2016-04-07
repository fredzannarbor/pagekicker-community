#!/bin/bash
#
# Floating point number functions.

#####################################################################
# Default scale used by float functions.

float_scale=2


#####################################################################
# Evaluate a floating point number expression.

function float_eval()
{
    local stat=0
    local result=0.0
    if [[ $# -gt 0 ]]; then
        result=$(echo "scale=$float_scale; $*" | bc -q 2>/dev/null)
        stat=$?
        if [[ $stat -eq 0  &&  -z "$result" ]]; then stat=1; fi
    fi
    echo $result
    return $stat
}


#####################################################################
# Evaluate a floating point number conditional expression.

function float_cond()
{
    local cond=0
    if [[ $# -gt 0 ]]; then
        cond=$(echo "$*" | bc -q 2>/dev/null)
        if [[ -z "$cond" ]]; then cond=0; fi
        if [[ "$cond" != 0  &&  "$cond" != 1 ]]; then cond=0; fi
    fi
    local stat=$((cond == 0))
    return $stat
}


# Test code if invoked directly.
if [[ $(basename $0 .sh) == 'float' ]]; then
    # Use command line arguments if there are any.
    if [[ $# -gt 0 ]]; then
        echo $(float_eval $*)
    else
        # Turn off pathname expansion so * doesn't get expanded
        set -f
        e="12.5 / 3.2"
        echo $e is $(float_eval "$e")
        e="100.4 / 4.2 + 3.2 * 6.5"
        echo $e is $(float_eval "$e")
        if float_cond '10.0 > 9.3'; then
            echo "10.0 is greater than 9.3"
        fi
        if float_cond '10.0 < 9.3'; then
            echo "Oops"
        else
            echo "10.0 is not less than 9.3"
        fi
        a=12.0
        b=3.0
        c=$(float_eval "$a / $b")
        echo "$a / $b" is $c
        set +f
    fi
fi

# vim: tabstop=4: shiftwidth=4: noexpandtab:
# kate: tab-width 4; indent-width 4; replace-tabs false;

