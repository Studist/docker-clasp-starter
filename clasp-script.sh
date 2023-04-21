#!/usr/bin/env bash
SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)

# 引数の数が2個でなければエラー
# 1つ目の引数は create, push のいずれか
# 2つ目の引数はプロジェクト名

if [ $# -ne 2 ]; then
    echo "Usage: $0 [create|push] [project name]"
    exit 1
fi

# 引数の1つ目をコマンドとして変数に格納

COMMAND=$1

# 引数の2つ目をプロジェクト名として変数に格納

PROJECT_NAME=$2

# 引数の1つ目が create であればプロジェクトを作成する
# 但し同じ名前のフォルダがあればエラー

if [ $COMMAND = "create" ]; then
    if [ -d $PROJECT_NAME ]; then
        echo "Error: $PROJECT_NAME already exists."
        exit 1
    fi
    mkdir -p $PROJECT_NAME/src
    clasp create --type standalone --rootDir $SCRIPT_DIR/$PROJECT_NAME --title $PROJECT_NAME
    # 作成した$PROJECT_NAME/appsscript.jsonを編集しTimezoneを日本にする("America/New_York" => "Asia/Tokyo")
    sed -i -e "s/America\/New_York/Asia\/Tokyo/g" $SCRIPT_DIR/$PROJECT_NAME/appsscript.json
    # 作成した$PROJECT_NAME/appsscript.jsonを$PROJECT_NAME/src/appsscript.jsonに移動する
    mv $SCRIPT_DIR/$PROJECT_NAME/appsscript.json $SCRIPT_DIR/$PROJECT_NAME/src/appsscript.json
    # .clasp.jsonのrootDirを`./src`に変更する($SCRIPT_DIR/$PROJECT_NAME => ./src)
    sed -i -e "s|$SCRIPT_DIR\/$PROJECT_NAME|\.\/src|g" $SCRIPT_DIR/$PROJECT_NAME/.clasp.json
    # tsconfig.json.sampleを$PROJECT_NAME/tsconfig.jsonにコピーする
    cp $SCRIPT_DIR/tsconfig.json.sample $SCRIPT_DIR/$PROJECT_NAME/tsconfig.json
    exit 0
fi

# 引数の1つ目が push であればプロジェクトを更新する

if [ $COMMAND = "push" ]; then
    cd $PROJECT_NAME
    # tsconfig.jsonが無ければ../tsconfig.json.sampleをコピーしてくる
    if [ ! -e tsconfig.json ]; then
        cp ../tsconfig.json.sample tsconfig.json
    fi
    # clasp push のエラー回避の為に、空のpackage.jsonを作成する
    touch package.json
    echo "{}" >package.json
    ## timezoneが日本以外の場合は日本にする
    sed -i -e "s/America\/New_York/Asia\/Tokyo/g" $SCRIPT_DIR/$PROJECT_NAME/src/appsscript.json
    clasp push -f
    # package.jsonを削除する
    rm package.json
    cd $SCRIPT_DIR
    exit 0
fi
