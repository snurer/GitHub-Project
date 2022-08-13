#!/bin/bash
# Automation of creating a repository on GitHub and cloning the new repository to our machine.
green="\033[1;3;32m"
plain="\033[1;3m"
red="\033[1;3;31;47m"
end="\033[0m"
# Check for the token environment variables
function token_check() {
    if [[ -z "${TOKEN}" ]]; then
    echo -e "Token environment variable is not set"
    read -p "Do you need instruction how to create token on GitHub (Y/n):" answer

        if [[ $answer == Y ]]; then 
            open "https://github.com/settings/tokens"
            if [[ $? != 0 ]]; then
                echo -e "Use this link to generate new token: https://github.com/settings/tokens"
            fi
        else
            echo -e "Great then!"
        fi
    read -p "please type in your token:  " TOKEN
    else
    TOKEN="$TOKEN"
    fi 
}
token_check

# Installation of jq
function prerequisites() {
    echo -e "Installing a prerequisite program 'jq'"
        if [[ $? != 0 ]]; then
            brew install jq
        else
            echo "install jq with your default package manager"
        fi
}
prerequisites

# Create a new folder for your project
echo "First, create a new folder to initialize your repository"
read -p "Please type in your folder name:  " PROJECT_NAME
mkdir $PROJECT_NAME
cd $PROJECT_NAME
echo "Now you are in your new project folder!"

# Name the new repository
echo "Name for your new repository:"
echo "Use single word or hyphen(-) between words."
read REPO_NAME

echo "Enter a repo description: "
read DESCRIPTION

echo "What is your GitHub username?"
read USERNAME

# Initialise the repo locally, create ablank README, and .gitignore file add and commit
echo "Initializing your repo locally"
    git init
    touch README.md
    touch .gitignore
    git add .
echo "what is your commit message?" 
read COMMIT_MESSAGE
git commit -m "$COMMIT_MESSAGE"

# Use github API to create the repository
echo "Creating your new repository!"
clone_url=$(curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: token $TOKEN" https://api.github.com/user/repos -d '{"name":"'$REPO_NAME'","description":"'$DESCRIPTION'","homepage":"https://github.com","private":true}' | jq -r .clone_url)
echo "This is your CLONE URL: $clone_url"

# Add the remote GitHub repo to local repo and push
echo "adding remote GitHub repo to local and push."
git remote add origin $clone_url
git branch -m master main
git push -u origin main









