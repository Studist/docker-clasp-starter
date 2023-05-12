#!/usr/bin/env bash
SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)

PROJECT_NAME=$(basename $SCRIPT_DIR)

# 引数の数が1個でなければエラー
# 引数は create, push のいずれか

if [ $# -ne 1 ]; then
    echo 'You can only use either "create" or "push" as a single argument.'
    exit 1
fi

# 引数をコマンドとして変数に格納

COMMAND=$1

# 引数が create であればプロジェクトを作成する
# 但し同じ名前のフォルダがあればエラー

if [ $COMMAND = "create" ]; then

    echo $PROJECT_NAME
    clasp create --type standalone --rootDir ./src --title $PROJECT_NAME
    mv ./src/.clasp.json .
    exit 0
fi

# 引数が push であればプロジェクトを更新する

if [ $COMMAND = "push" ]; then
    clasp push -f
    exit 0
fi
