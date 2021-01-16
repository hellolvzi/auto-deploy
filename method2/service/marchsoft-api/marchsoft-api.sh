#!/bin/bash
# 错误中断
set -e

# 公共子脚本环境变量 start------------------------------------------------
# 第几个容器, 从 1 开始
ID=$1
# 当前路径
CURRENT_DIR=$2
# 生成文件路径（含有项目名称）
PROJECT_DIR=$3
# 这是全局部署路径，通常 GLOBAL_PATH=/root
GLOBAL_PATH=`awk -F "=" '/GLOBAL_PATH/{print $2}' $PROJECT_DIR/compose.env`

if [ $# -eq 0 ]; then
CURRENT_DIR=$PWD
PROJECT_DIR="$PWD/../../target/tem"
    if [ -e $PROJECT_DIR ]; then
        rm -rf $PROJECT_DIR  
    else
        mkdir -p $PROJECT_DIR
    fi
fi

# service文件夹路径
SERVICE_DIR="$CURRENT_DIR/../../service"
# common文件夹路径
COMMON_DIR="$CURRENT_DIR/../../common"
# 公共子脚本环境变量 end------------------------------------------------

# 第一个容器进行的操作（一般要拷贝 config、data...）
if [ $ID -eq 1 ]; then
    cp -rf $CURRENT_DIR/Dockerfile-api $PROJECT_DIR
fi

# 以下是每个api都会进行的操作
read -p "请输入api容器名($ID): " name

sed -e "s/REPLACE_NAME/${name}/g" $CURRENT_DIR/marchsoft-api.yml >> $PROJECT_DIR/docker-compose.yml

echo "$name service 配置文件已生成 OK"