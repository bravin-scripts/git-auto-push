#!/bin/bash

# Author: Bravin Shumwe
# Licence: MIT

username=$(whoami)
echo "Hello, ${username}"

add_commit () {
    echo "Adding changed files..."
    git add . # TODO: change to be dynamic
    echo "Please input your commit message and press enter."
    read -p "Commit Message: " commit_message
    git commit -m "$commit_message"
}

branch_switch () {
    while true
        do
            read -p "Switch code branch? (yY/nN): " switch
            case $switch in
                [yY][eE][sS]|[yY]) 
                    read -p "Branch name (default: main): " branch_name
                    if [ -z "$branch_name" ]; then
                        echo "left empty for main default ####"
                        branch_name=main
                        git branch -M main
                    else
                        echo "Changing branch to set name"
                        git branch -M "$branch_name"
                    fi
                    break
                    ;;
                [nN][oO]|[nN])
                    echo "Branch was not changed"
                    break
                    ;;
                *)
                    echo "invalid response"
                    ;;
            esac
        done
}

add_origin () {
    while true
        do
            read -p "Add remote origin url? (yY/nN): " origin
            case $origin in
                [yY][eE][sS]|[yY]) 
                    read -p "Input origin url: " origin_url
                    git remote add origin $origin_url
                    break
                    ;;
                [nN][oO]|[nN])
                    echo "Leaving origin url unchanged"
                    break
                    ;;
                *)
                    echo "invalid response"
                    ;;
            esac
        done
}

push () {
    echo "Now pushing your code to github"
    git push -u origin $branch_name
}

select opt in "First Time Push" "Subsequent Push" Quit; do
    case $opt in
        "First Time Push")
            echo "Pushing for the first time."
            while true
            do
                read -p "Do you wan't to initialize git? (yY/nN): " yn_input
                case $yn_input in
                    [yY][eE][sS]|[yY]) 
                        echo "ok, initializing git"
                        git init
                        break
                        ;;
                    [nN][oO]|[nN])
                        echo "ignoring git initialization..."
                        break
                        ;;
                    *)
                        echo "invalid response"
                        ;;
                esac
            done
            # add and commit
            add_commit
            # switching branch 
            branch_switch
            # adding remote origin url
            add_origin
            # push
            push
            break
            ;;
        
        "Subsequent Push")
            echo "Pushing for the subsequent time."
            # add and commit
            add_commit
            # switching branch 
            branch_switch
            # adding remote origin url
            add_origin
            # push
            push
            break
            ;;
        # TODO: add purge .git | unset git
        Quit)
            break
            ;;
        *)
            echo "$REPLY is an invalid option. Try again!"
    esac
done