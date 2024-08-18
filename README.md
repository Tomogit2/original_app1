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