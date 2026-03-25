#!/bin/zsh

# 1. 現在の場所とファイル名を取得
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_NAME=$(basename "$0")
# 現在のフォルダ名だけを取得（例: _PasswordManager）
CURRENT_FOLDER=$(basename "$CURRENT_DIR")

# 2. フォルダ構成の判定と保存先の決定
if [ "$CURRENT_FOLDER" = "_PasswordManager" ]; then
    # すでにフォルダ内にいる場合：自分の隣に保存
    FILE="$CURRENT_DIR/data.txt"
else
    # フォルダ外（Downloadsなど）にいる場合：フォルダを作って移動
    TARGET_DIR="$CURRENT_DIR/_PasswordManager"
    FILE="$TARGET_DIR/data.txt"
    
    mkdir -p "$TARGET_DIR"
    mv "$0" "$TARGET_DIR/$SCRIPT_NAME"
    echo "スクリプトを $TARGET_DIR に移動しました。"
    echo "移動した先のスクリプトを実行してください。"
    exit 0 # 移動直後はここで終了させる（二重実行防止）
fi

# --- これ以降はフォルダ内でのみ実行される ---

echo "パスワードマネージャーへようこそ！"
read "service_name?サービス名を入力してください: "
read "user_Name?ユーザー名を入力してください: "
read "password?パスワードを入力してください: " 

if [ -s "$FILE" ]; then
    echo "---" >> "$FILE"
fi

{
    echo "サービス名: $service_name"
    echo "ユーザー名: $user_Name"
    echo "パスワード: $password"
} >> "$FILE"

echo "Thank you!"
