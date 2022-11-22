#!/usr/bin/env bash

main () {

    if [[ -z "$@" || "$@" == "-h" || "$@" == "--help" ]]
    then
        echo "Usage: $0 ['Final' || 'Test']"
        exit 1
    fi

    level="$1"
    declare -a dirs=("/" "/Accounting" "/AP" "/AR" "/Billing" "/Billing/Billed" "/Billing/Bills" "/Billing/WIP" "/Billing/WIP/Reports" "/Practice_Management" "/Practice_Management/Contacts" "/Practice_Management/Matters" "/Practice_Management/Rates" "/Practice_Management/Users")
    for dir in ${dirs[*]}
    do
        mkdir "$level$dir"
    done
}

main "$@"