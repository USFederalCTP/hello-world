#!/bin/bash
# Project 3.1 - Scripting a simple decision scenario
# Submitted by Jim Lee
#
# Scenario  Working Title: Rolling Thunder in Florida
# Scenario: If it is after 3:00 pm and it is raining, or if it is before 3:00 pm
#           and there is thunder, do not go out holding an 11 foot aluminum pole 
#           and kite with cooper key attached.  Otherwise, by all means do, 
#           but I'm not responsible for any strange looks you get.
#
# Design:   The design of this script is simple.  Basically, I collect the necessary 
#           information from the user via a 'read' command inside the getBinaryUserInput function
#           and then apply a series of if-then-elif logic at the end of the script to formulate a 
#           recommendation per the scenario above.
#
# Constraits and Assumptions:
#   - Need at least three variables
#   - Need at least two ANDs and one OR, or two ORs and one AND
#   - Keep it simple and think Agile
#
# Variables: 
#   string  timeRelativeTo3pm    - User input of time relative to 3:00 pm.  <"before", "after">
#   string  isThunder            - User input if they hear thunder. <y,n>
#   string  isRaining            - User input if they observe any rain. <y,n>
#   string  havePole             - User input if they own an 11 foot Aluminum pole <y,n>
#   string  haveKite             - User input if they own a kite with a copper key attached <y,n>
#
clear
echo -e "\nCourse: COP 2341C - Linux Shell Scripting)\nProject 3.1 - Scripting a simple decision scenario\n"

#
# getBinaryUserInput() is a function for prompting the user for information.
# Just add more actions to the case statement to process more than two user inputs.
#
function getBinaryUserInput() {
    local default="$1"
    local prompt="$2"
    local action_1="$3"
    local action_2="$4"
    local user_input

    read -p "$prompt" user_input
    [ -z "$user_input" ] && user_input="$default"

    case "$user_input" in
        [1] ) eval "$action_1"
            # error check
            ;;
        [2] ) eval "$action_2"
            # error check
            ;;
        *   ) printf "%b" "Invalid input '$user_input'!\n" >&2
            exit 1 ;;
    esac
} # End Function getBinaryUserInput()

#
# Ask user about time relative to 3:00 pm <default, prompt, action_1, action_2>
#
myDefault=1; 
myPrompt="Is it currently before or after 3:00 pm <1=before, 2=after, default:'$myDefault'>? "
action_01="\
    echo '   $(tput smso)Before 3 PM...$(tput rmso)'; \
    timeRelativeTo3pm="before"; \
    "
action_02="\
    echo '   $(tput smso)After 3 PM...$(tput rmso)'; \
    timeRelativeTo3pm="after"; \
    "

getBinaryUserInput "$myDefault" "$myPrompt" "$action_01" "$action_02"

#
# Prompt user for info about the rain or thunder conditions depending on 'timeRelativeTo3pm'
#
if [[ $timeRelativeTo3pm = "before" ]]; then
    # Since it's before 3pm, ask user if they hear thunder <default, prompt, action_03, action_04>
    myDefault=2;
    myPrompt="Do you hear thunder <1=yes, 2=no | default:'$myDefault'>? "
    action_03="\
        echo '   $(tput smso)Thunder...$(tput rmso)'; \
        isThunder='yes'; \
        "
    action_04="\
        echo '   $(tput smso)No thunder...$(tput rmso)'; \
        isThunder='no'; \
        "

    getBinaryUserInput "$myDefault" "$myPrompt" "$action_03" "$action_04"

elif [[ $timeRelativeTo3pm = "after" ]]; then
    # Since it's after 3pm,ask user if it's raining <default, prompt, action_05, action_06>
    myDefault=2;
    myPrompt="Is it raining <1=yes, 2=no | default:'$myDefault'>? "
    action_05="\
        echo -e '   $(tput smso)Raining...$(tput rmso)'; \
        isRaining='yes'; \
        "
    action_06="\
        echo '   $(tput smso)No rain...$(tput rmso)'; \
        isRaining='no'; \
        "
    getBinaryUserInput "$myDefault" "$myPrompt" "$action_05" "$action_06"

fi

#
# Find out if user owns an 11-foot pole or kite
#
myDefault=1;
myPrompt="Do you own an 11-foot aluminum pole <1=yes, 2=no | default:'$myDefault'>? "
action_07="\
    echo '   Great! You own a long pole...'; \
    havePole='yes'; \
    "
action_08="\
    echo '   No pole!  Hmmm, somebody has to get their priorities straight...'; \
    havePole='no'; \
    "
getBinaryUserInput "$myDefault" "$myPrompt" "$action_07" "$action_08"

myDefault=1;
myPrompt="Do you own a kite with a cooper key attached <1=yes, 2=no | default:'$myDefault'>? "
action_09="\
    echo '   Great! You own a kite...'; \
    haveKite='yes'; \
    "
action_10="\
    echo '   No key!  Come on, you gotta work with me here...'; \
    haveKite='no'; \
    "
getBinaryUserInput "$myDefault" "$myPrompt" "$action_09" "$action_10"

#
# Apply pseudo-AI ;-)
#
# If (before 3pm and thunder) OR (after 3pm and raining) then DON'T go outside; otherwise, it's safe to go outside. 
#
echo -e "\nHere's my recommendation...\n"
if [[ ( $timeRelativeTo3pm == "before" && $isThunder == "yes" ) || \
      ( $timeRelativeTo3pm == "after"  && $isRaining == "yes" ) ]]; then
    echo -e "   $(tput setaf 1)\"Do NOT go outside!  You live in the Lightning Capital of the US.  Better safe than sorry.\"$(tput sgr0)\n"
else
    echo -e "   $(tput setaf 2)\"Looks good to me. Get out there and have fun!\"$(tput sgr0)"
    # Remind user to take their pole or kite if they own such things
    if [[ $havePole == "yes" && $haveKite == "yes" ]]; then
        echo -e "   \"...Don't forget your 11-foot pole and kite!\"\n"
    elif [[ $havePole == "yes" && $haveKite == "no" ]]; then
        echo -e "   \"...Don't forget to take your 11-foot pole with you.\"\n"
    elif [[ $havePole == "no" && $haveKite == "yes" ]]; then
        echo -e "   \"...Don't forget to take your kite with you.\"\n"
    else
        echo -e "   \"...But, I'm sorry you don't have a pole or kite to take with you.\"\n"
    fi
fi

# Future feature: Derive weather from WTTR ASCI report
#curl -4 wttr.in/~Orlando?1QT

exit 0
