#!/bin/bash
#```Bash script to merge git branches
#All variables are sourced interactively or via direct input. SSH key needs to be pre-set test
#$1 - Source Branch to Merge From
#$2 - Destination Branch to Merge To
#$3 - Repo URL

#-Functions
merge() {
        git checkout $2
        git merge --no-ff $1
        git push origin $2
        echo "Merged $1 to $2 sucessfully!"
        echo ""
        echo "......................"
        #Ask if user requires to merge this to Master
        read -p "Dpo you want to merge with master? (y/n) _" -n 1 -r
        echo  #(oprtional move to a new line
          if [[ $REPLY =~ ^[Yy]$ ]]
          then
          # Merge to master
          git checkout master
          git merge --no-ff $2
          git push origin master
          echo "Operation complete!"
          echo ""
          echo ".................."
        fi
        echo "Job Done. Exiting!"
}

check_branch() {
        echo "Input branches are $1 and $2"
        echo "Work dir is `pwd`"
        git checkout $1
        git checkout $2
        if [ `git branch --list $1` ]; then
                echo "Merging $1 with $2 .."
                merge $1 $2
        else
                echo "Branch ($1) doesn't exist. Exiting now.."
                exit 1
        fi
}

#-Execution

#Locate the help argument before continuing
for arg in "$@"

do

        if [ $arg = "-h" ] || [ $arg = "--help" ]; then
           echo "# ----> User Interactive"
           echo "Usage: ./git_merge.sh"  # -->user Interactive
           echo "OR"
           echo "# ---> Direct Input"
           echo "Usage: ./git_merge.sh <Source Branch> <Destination Branch> <Repo URL>" #-->
           exit 0
        fi
done

#Now process the input
if [ "$#" -eq 0 ]; then
        read -p "Enter repo URL (example -git@bitbucker.orge:team/reponame.git) : " repourl
        read -p "Name the sourche branch : "branch
        read -p "Name the destination branch : "destbranch
        echo ""
        echo "Cleaning up working directory.."
        rm -rf workdir
        mkdir workdir
        cd workdir
        git clone $repourl && cd $(basename $_ .git)
        exit_status=$?; if [[ $exit_status != 0 ]]; then echo "Cloning Repo Failed! check URL & sucess. exiting!!" ; exit $exit_status; fi
        echo "Entering repo Dir `pwd` .."
        check_branch $branch $destbranch
else
        rm -rf workdir
        mkdir workdir
        cd workdir
        git clone $3 && cd $(basename $_ .git)
        exit_status=$?; if [[ $exit_status != 0 ]]; then echo "cloning repo failed! check URL & access. Exiting!!" ; exit $exit_status; fi
        echo "Entering Repo Dir `pwd` .."
        check_branch $1 $2
        git checkout master
for branch in "$@"
        do
                check_branch $1 $2
        done
fi

exit0

