# パスワードマネージャー
 
zshで実装したCLIのパスワードマネージャーです。サービス名・ユーザー名・パスワードをGPGで暗号化して安全に管理します。
 
---
 
## プロジェクト概要
 
| 項目 | 内容 |
|---|---|
| 言語 | zsh |
| 暗号化 | GnuPG（共通鍵暗号） |
| 動作環境 | macOS |
 
### 主な機能
- パスワードの追加（Add Password）
- パスワードの検索・表示（Get Password）
- GPGによるファイルの暗号化・復号化
- Ctrl+C 割り込み時の安全な終了処理
- 空入力バリデーション
 
---
 
## セットアップ手順
 
### 1. 必要なツールをインストール
 
```zsh
brew install gnupg pinentry-mac
```
 
### 2. リポジトリをクローン
 
```zsh
git clone <リポジトリURL>
cd PasswordManager
```
 
### 3. スクリプトに実行権限を付与
 
```zsh
chmod +x password_manager.sh
```
 
### 4. 動作確認
 
```zsh
./password_manager.sh
```
 
---
 
## 使い方・操作方法
 
### 起動
 
```zsh
./password_manager.sh
```
 
起動時にパスフレーズの入力を求められます。このパスフレーズはファイルの暗号化・復号化に使用します。
 
```
パスフレーズを入力してください。:
パスワードマネージャーへようこそ!
次の選択肢から入力してください(Add Password/Get Password/Exit):
```
 
> ⚠️ パスフレーズは必ず覚えておいてください。忘れると保存したパスワードを復元できません。
 
---
 
### Add Password（パスワードの追加）
 
`Add Password` と入力すると、サービス名・ユーザー名・パスワードの入力を求められます。
 
```
次の選択肢から入力してください(Add Password/Get Password/Exit): Add Password
サービス名を入力してください: GitHub
ユーザー名を入力してください: son_dev
パスワードを入力してください:
パスワードの追加は成功しました。
```
 
- パスワード入力時は画面に表示されません
- 空入力の場合は再入力を促されます
- 保存後、自動的にファイルが暗号化されます
 
---
 
### Get Password（パスワードの検索）
 
`Get Password` と入力すると、サービス名で検索できます。
 
```
次の選択肢から入力してください(Add Password/Get Password/Exit): Get Password
サービス名を入力してください: GitHub
サービス名: GitHub
ユーザー名: son_dev
パスワード: gH#9kLmP2x
```
 
- サービス名は完全一致で検索します
- 登録されていないサービス名を入力すると `サービスが見つかりません` と表示されます
 
---
 
### Exit（終了）
 
`Exit` と入力するとプログラムが終了します。
 
```
次の選択肢から入力してください(Add Password/Get Password/Exit): Exit
Thank you!
```
 
---
 
### サンプルデータ（テスト用）
 
> ⚠️ 以下はテスト用のサンプルデータです。実際には使用しないでください。
 
| サービス名 | ユーザー名 | パスワード |
|---|---|---|
| GitHub | son_dev | gH#9kLmP2x |
| Gmail | sample@gmail.com | mG$7nQwR4v |
| AWS | son_aws | aW%5jBsT8y |
 
**テスト用パスフレーズ**: `test1234`
 
---
 
## 📁 ファイル構成
 
```
PasswordManager/
├── password_manager.sh  # メインスクリプト
├── data.txt.gpg         # 暗号化されたパスワードファイル（自動生成）
└── README.md            # このファイル
```
 
| ファイル | 説明 |
|---|---|
| `password_manager.sh` | メインのシェルスクリプト |
| `data.txt.gpg` | GPGで暗号化されたパスワード保存ファイル。`Add Password` 実行後に自動生成される |
| `data.txt` | 暗号化前の一時ファイル。処理完了後に自動削除される |
