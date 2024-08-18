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


## ER図

以下のER図は、当アプリケーションのデータベース構造を表しています。
![ER図](docs/er_diagram.png)

- **usersテーブル**: アプリケーションのユーザー情報を管理します。ユーザーのニックネーム、メールアドレス、暗号化されたパスワードが含まれます。各ユーザーは複数のジョークとAIジョークを持つことができます。ユーザーは必ずしもジョークを投稿する必要はなく、閲覧のみを行うユーザーも存在します。このため、ユーザーとジョークのリレーションシップは「1対0多」となります。

- **jokesテーブル**: ユーザーが入力したジョークのデータを格納します。ジョークは、ユーザーIDを外部キーとしてユーザーと関連付けられており、カテゴリIDと二つの入力テキストフィールドを持っています。各ジョークは一つのAIジョークを持つことができます。

- **ai_jokesテーブル**: AIによって生成されたジョークを保存します。このテーブルは、ジョークがユーザーに関連付けられた状態で、生成されたAIジョークの内容を保持します。`user_id`および`joke_id`は、それぞれ`users`テーブルおよび`jokes`テーブルへの外部キーです。

各テーブルは、外部キーを介して他のテーブルと連携し、アプリケーション内のデータの整合性と一貫性を確保しています。