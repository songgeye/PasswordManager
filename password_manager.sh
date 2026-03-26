#!/bin/zsh

# 現在の場所とファイル名を取得
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 保存するファイル
FILE="$CURRENT_DIR/data.txt"

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
# exit 0