# アプリケーション名
すきなもの、まぜて・・・？なつやすみのじゆうけんきゅうアイデアマシーン

# アプリケーションの概要
このアプリは、小学校低学年の児童向けに、夏休みの自由研究アイデアを提供するWebアプリケーションです。  
ユーザーが選んだジャンルと任意のキーワードを入力すると、AIが自由研究のアイデアを生成します。他のユーザーが生成した自由研究のアイデアも見ることができ、自分が思いつかなかったようなことにも興味が派生していくようにしています。  
子どもの自然な好奇心を刺激し、子どもたちが自発的に自由研究や日々の学習に取り組むきっかけを作ることを目指しています。

# URL

アプリケーションはAWS上にデプロイされています。以下のURLからアクセスできます。  
[すきなもの、まぜて・・・？なつやすみのじゆうけんきゅうアイデアマシーンのURL](http://18.177.91.86:3000/)

# テスト用アカウント
- Basic認証パスワード：
- Basic認証ID：
- メールアドレス：
- パスワード：tttttt1

# 利用方法
1. トップページ（一覧ページ）のヘッダーから新規登録を行う
2. プルダウンから1つ強化を選び、2箇所に任意の言葉を入力して「じゆうけんきゅうのアイデアをつくる」ボタンをクリックする


# 使用技術

- **フロントエンド**: HTML, CSS
- **バックエンド**: Ruby on Rails 7
- **データベース**: MySQL (RDS: MariaDB)
- **インフラ**: AWS (EC2, RDS)
- **その他**: GitHub, openAI API連携, Visual Studio Code (VSCode)

## 開発環境
- **OS**: Windows 11
- **WSL**: Windows Subsystem for Linux
- **ターミナル**: PowerShell 7, コマンドプロンプト, AWS CloudShell
- **テキストエディタ**: Vim, VSCode
- **データベース管理**: DBeaver
- **AWS CLI**: Amazon Web Services Command Line Interface
- **Linux**: Ubuntu

# インストール方法

1. リポジトリをクローンします。
```bash
git clone https://github.com/Tomogit2/original_app1
```
2. 必要なGemをインストールします。
```bash
bundle install
```
3. データベースを作成します。
```bash
rails db:create db:migrate
```
4. 環境変数を設定します。
```bash
export OPENAI_API_KEY=your_api_key
```
5. サーバーを起動します。
```bash
rails server
```
6. ブラウザで`http://localhost:3000`にアクセスし、アプリケーションが動作していることを確認します。


# テーブル設計

## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| nickname           | string | null: false |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false |

### Association

- has_many :jokes
- has_many :ai_jokes


## jokes テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| user       | references| null: false, foreign_key: true |
| category_id   | integer   | null: false |
| input_text1   | string    | null: false |
| input_text2   | string    | null: false |


### Association

- belongs_to :user
- belongs_to_active_hash :category
- has_one :ai_joke


## ai_jokes テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| user   | references | null: false, foreign_key: true |
| joke   | references | null: false, foreign_key: true |
| ai_joke| text      | null: false |

### Association

- belongs_to :user
- belongs_to :joke


# ER図

以下のER図は、当アプリケーションのデータベース構造を表しています。
![ER図](docs/er_diagram.png)

- **usersテーブル**: アプリケーションのユーザー情報を管理します。ユーザーのニックネーム、メールアドレス、暗号化されたパスワードが含まれます。各ユーザーは複数のジョークとAIジョークを持つことができます。ユーザーは必ずしもジョークを投稿する必要はなく、閲覧のみを行うユーザーも存在します。このため、ユーザーとジョークのリレーションシップは「1対0多」となります。

- **jokesテーブル**: ユーザーが入力したジョークのデータを格納します。ジョークは、ユーザーIDを外部キーとしてユーザーと関連付けられており、カテゴリIDと二つの入力テキストフィールドを持っています。各ジョークは一つのAIジョークを持つことができます。

- **ai_jokesテーブル**: AIによって生成されたジョークを保存します。このテーブルは、ジョークがユーザーに関連付けられた状態で、生成されたAIジョークの内容を保持します。`user_id`および`joke_id`は、それぞれ`users`テーブルおよび`jokes`テーブルへの外部キーです。

各テーブルは、外部キーを介して他のテーブルと連携し、アプリケーション内のデータの整合性と一貫性を確保しています。


# アプリを作った動機などの詳細

- [アプリを作った動機](docs/motivation.md)