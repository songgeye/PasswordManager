#!/bin/zsh

# 最初はプロンプトを表示する(フラグのリセット)
show_prompt=true

# 現在の場所とファイル名を取得
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 保存するファイル
FILE="$CURRENT_DIR/data.txt"

echo "パスワードマネージャーへようこそ！"

# 無限ループ
while :
do

 # ユーザー入力を受け取る

 # フラグによって分岐
  if [ "$show_prompt" = "true" ]; then
    read "key?次の選択肢から入力してください(Add Password/Get Password/Exit): "
  else
    read key
  fi

  show_prompt=true

 # 入力に応じて分岐
 case "$key" in
   "Add Password")
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

     echo "パスワードの追加は成功しました。"

     ;;
   "Get Password")
     read "search?サービス名を入力してください: "
     result=$(grep -A 2 "サービス名: $search" $FILE)
     
     if [ -z "$result" ]; then  # resultが空かどうかの判定
        echo "そのサービスは登録されていません。"
    else
        echo "$result"
    fi
     ;;
   "Exit")
     echo "Thank you!"
     # ループを抜ける
     break
     ;;
   *)
   echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。: $key"
   show_prompt=false
     ;;
 esac
done