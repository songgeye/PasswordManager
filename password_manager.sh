#!/bin/zsh

# 最初はプロンプトを表示する(フラグのリセット)
show_prompt=true

# 現在の場所とファイル名を取得
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 一時的な平文ファイル(暗号化後に削除)
FILE="$CURRENT_DIR/data.txt"

# 暗号化されたファイル
FILE_GPG="$CURRENT_DIR/data.txt.gpg"

# Ctrl+C（SIGINT）を受け取ったら平文ファイルを削除して終了
trap "rm -f '$FILE'; echo '中断しました。'; exit 1" SIGINT

# 起動時に1度だけパスフレーズを入力
read -s "passphrase?パスフレーズを入力してください。: "
echo
# パスフレーズの空チェック
if [ -z "$(echo "$passphrase" | tr -d '[:space:]')" ]; then
  echo "エラー: パスフレーズが空か、空白のみです。"
  exit 1
fi

# 既存ファイルがある場合だけ検証
if [ -f "$FILE_GPG" ]; then
  if ! gpg --batch --yes --pinentry-mode loopback \
           --passphrase "$passphrase" \
           --decrypt "$FILE_GPG" > /dev/null 2>&1; then
    echo "エラー: パスフレーズが正しくありません。"
    exit 1
  fi
fi

echo "パスワードマネージャーへようこそ!"

# 無限ループ
while :
do

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
  if [ -f "$FILE_GPG" ]; then
    # data.txtを復元（復号）
    if ! gpg --batch --yes --pinentry-mode loopback \
             --passphrase "$passphrase" \
             --decrypt "$FILE_GPG" > "$FILE"; then
      echo "エラー: 復号に失敗しました。"
      continue
    fi
  else
    # data.txtを作成
    : > "$FILE"
  fi

  if [ -s "$FILE" ]; then
    echo "---" >> "$FILE"
  fi

  while true; do
    read "service_name?サービス名を入力してください: "
    if [ -z "$service_name" ]; then
        echo "空入力です。もう一度入力してください。"
    else
        echo "サービス名: $service_name" >> "$FILE"
        break
    fi
  done

  while true; do
    read "user_Name?ユーザー名を入力してください: "
    if [ -z "$user_Name" ]; then
        echo "空入力です。もう一度入力してください。"
    else
        echo "ユーザー名: $user_Name" >> "$FILE"
        break
    fi
  done

  while true; do
    read -s "password?パスワードを入力してください: "
    if [ -z "$password" ]; then
        echo "空入力です。もう一度入力してください。"
    else
        echo "パスワード: $password" >> "$FILE"
        break
    fi
  done

  echo

  # 暗号化（成功したら平文削除）
  if gpg --batch --yes --pinentry-mode loopback \
       --passphrase "$passphrase" \
       --symmetric "$FILE"; then
    rm "$FILE"
    echo "パスワードの追加は成功しました。"
  else
    echo "エラー: 暗号化に失敗しました。"
  fi
  ;;
    "Get Password")
      read "search?サービス名を入力してください: "

      # 暗号化されたファイルが存在するかどうかを確認
      if [ ! -f "$FILE_GPG" ]; then
        echo "登録されていません"
        continue
      fi

      # 復号化してパイプでgrepに渡す
      result=$(gpg --batch --yes --pinentry-mode loopback --passphrase "$passphrase" --decrypt "$FILE_GPG" 2>/dev/null | grep -A 2 "サービス名: $search$")

      if [ -z "$result" ]; then
        echo "サービスが見つかりません"
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