#!/bin/bash

# 获取当前系统的名称
os=$(uname -s)

# mac系统的同步目录
mac_sync_dir='/Users/charlie/data/rime-sync'
# win系统的同步目录
win_sync_dir='C:\Users\charlie\rime-sync'

mac_rime_app='/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel'
win_rime_app='C:\Program Files (x86)\Rime\weasel-0.15.0'

function upload {
    cd "$1"
    echo "正在上传到git"
    git add .
    datetime=$(date "+%Y-%m-%d %H:%M:%S")
    git commit -m "sync_${datetime}"
    git fetch origin main
    git rebase origin/main
    git push origin main 
}

dir=""
# 根据系统名称执行不同的命令
if [ "$os" == "Darwin" ]; then
    echo "这是 Mac 系统，执行同步文件中..."
    "${mac_rime_app}" --sync
    dir=$mac_sync_dir
elif [ "$os" == "Linux" ]; then
    echo "这是 Linux 系统，暂时不支持"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo "这是 Windows 系统，执行同步文件中..."
    ${win_sync_dir}/sync-rime-win.bat "${win_rime_app}"
    sleep 15s
    dir=$win_sync_dir
else
    echo "无法确定当前系统"
fi
echo "同步完毕"
if [ -z "$dir" ]; then
    echo "同步失败, 同步文件夹未设置"
else 
    upload "$dir"
    echo "上传完毕"
fi


