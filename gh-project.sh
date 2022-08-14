#!/bin/bash

### Automation of creating a repository on GitHub and cloning the new repository to our machine. ###

# Addig some colors to our bash script
green='\033[0;32m'
magenta='\033[0;35m'
yellow='\033[0;33m'
red='\033[0;31m'
end='\033[0m'
italic='\x1b[3m'

# Check for the token environment variables
function token_check() {
    if [[ -z "${TOKEN}" ]]; then
    echo -e "$magenta Token environment variable is not set $end"
    read -p "Do you need instruction how to create token on GitHub (Y/n):" answer

        if [[ $answer == Y ]]; then 
            open "https://github.com/settings/tokens"
            if [[ $? != 0 ]]; then
                echo -e "Use this link to generate new token: https://github.com/settings/tokens"
            fi
        else
            echo -e "$green Great then! $end"
        fi
    read -p "Please type in your token:  " TOKEN
    else
    TOKEN="$TOKEN"
    fi 
}
token_check

# Installation of jq
function prerequisites() {
    echo -e "Installing a prerequisite program 'jq'"
        brew install jq
        echo -e "$green Great! jq has been installed! $end"

        if [[ $? != 0 ]]; then
            echo -e "$red Please install jq with your default package manager$end"
        fi
    
}
prerequisites

# Create a new folder for your project
echo -e "$magenta First, create a new folder to initialize your repository$end"
    read -p "Please type in your folder name:  " PROJECT_NAME
        mkdir $PROJECT_NAME
        cd $PROJECT_NAME
echo "$yellow Now you are in your new project folder!$end"

# Name the new repository
echo -e "$magenta Name for your new repository:$end"
echo -e "$italic (Use single word or hyphen(-) between words)"
    read REPO_NAME

echo -e "$magenta Enter a repo description: $end"
    read DESCRIPTION

echo -e "$magenta What is your GitHub username? $end"
    read USERNAME

# Initialise the repo locally, create ablank README, and .gitignore file add and commit
echo -e "$green Initializing your repo locally...$end"
    git init
    touch README.md
    touch .gitignore
    git add .
echo -e "$magenta what is your commit message?$end" 
    read COMMIT_MESSAGE
    git commit -m "$COMMIT_MESSAGE"

# Use github API to create the repository
echo -e "$green Creating your new repository!$end"
    clone_url=$(curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: token $TOKEN" https://api.github.com/user/repos -d '{"name":"'$REPO_NAME'","description":"'$DESCRIPTION'","homepage":"https://github.com","private":true}' | jq -r .clone_url)
        echo -e "$green This is your CLONE URL $end: $clone_url"

# Add the remote GitHub repo to local repo and push
echo -e "$green adding remote GitHub repo to local and push. $end"
    git remote add origin $clone_url
    git branch -m master main
    git push -u origin main