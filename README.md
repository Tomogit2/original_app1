# テーブル設計

## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| name               | string | null: false |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false |

### Association

- has_many :room_imagination


## imagination テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| user_id       | references| ユーザーID（外部キー）|
| category_id   | integer   | プルダウンから選択された分野     |
| input_text1   | string    | 入力された言葉1    |
| input_text2   | string    | 入力された言葉2    |
| generated_imagination| TEXT      | 生成されたジョーク |

### Association

- belongs_to :user


## imagination_users テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| user   | references | null: false, foreign_key: true |
| imagination   | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :imagination