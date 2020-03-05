#!/bin/bash
git_server_dir="SERVER_ANYDIR"
mirror_server_dir="BACKUP_SERVER_ANYDIR"
mirror_checkout="$mirror_server_dir/anydir"
git_server="GIT_SERVER_IP"

cat file | while read REPO
do
let count++
ping -c1 -W1 -q $git_server &>/dev/null
status=$( echo $? )
    if [[ $status == 0 ]] ; then
        if [ -d "$mirror_server_dir/$REPO.git" ]; then
               ( cd "$mirror_server_dir/$REPO.git" && git remote update --prune && echo "")
               cd $mirror_checkout/$REPO && git checkout master && git fetch -p origin && git pull
        else
                cd $mirror_server_dir && git clone --mirror $git_server:$git_server_dir/$REPO
                cd $mirror_checkout && git clone $mirror_server_dir/$REPO.git
        fi
    else
        echo "git $git_server not REACHABLE"
    fi
done
