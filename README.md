# GoToDo!!!

## OVERVIEW
* 場所も登録できるタスク管理アプリ
* 近くを通りがかったらやる系のタスクを管理できる  
  e.g. 雑誌で見かけたカフェに行く  
  e.g. 期間限定イベントに行く


## REQUIREMENT
* Docker


## ENVIRONMENT
* Ruby
```
# ruby -v
ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-linux]
```

* Ruby on Rails
```
# rails -v
Rails 6.1.0
```

* MySQL
```
# mysql --version
mysql  Ver 8.0.22 for Linux on x86_64 (MySQL Community Server - GPL)
```


## INSTALL
```
$ cd training/gotodo/
$ docker-compose build
$ docker-compose up -d
```
http://localhost:3001/ にアクセス


## TABLE SCHEMA

### タスクテーブル
| カラム名(論理) | カラム名(物理) | 型 | 制約 | Rails |
| --- | --- | --- | --- | --- |
| ID | id | SERIAL | PK | 自動追加 |
| タスク名 | title | VARCHAR(50) | NN | t.string |
| 説明 | detail | VARCHAR(200) | | t.string |
| ステータス | status | INT |  | t.integer (enum) |
| ユーザID | user_id | INT | FK(ユーザテーブル.ID) | t.references :user, foreign_key: true |
| 終了期限 | end_date | DATETIME | | t.datetime |
| 作成日 | created_at | TIMESTAMP | | t.timestamps |
| 更新日 | created_at | TIMESTAMP | | t.timestamps |

### ユーザテーブル
| カラム名(論理) | カラム名(物理) | 型 | 制約 | Rails |
| --- | --- | --- | --- | --- |
| ID | id | SERIAL | PK | 自動追加 |
| ユーザ名 | name | VARCHAR(10) | NN | t.string |
| メールアドレス | email | VARCHAR(30) | NN | t.string |
| パスワード | password_digest | VARCHAR(255) | NN | t.string |
| ※ロールID | role_id | INT | FK(ロールテーブル.ロールID) | t.references :role, foreign_key: true |
| 作成日 | created_at | TIMESTAMP | | t.timestamps |
| 更新日 | created_at | TIMESTAMP | | t.timestamps |

### ロールテーブル
| カラム名(論理) | カラム名(物理) | 型 | 制約 | Rails |
| --- | --- | --- | --- | --- |
| ID | id | SERIAL | PK | 自動追加 |
| ロール番号 | role_no | INT | NN | t.integer |
| ロール名 | role_name | VARCHAR(255) | NN | t.string |
| 作成日 | created_at | TIMESTAMP | | t.timestamps |
| 更新日 | created_at | TIMESTAMP | | t.timestamps |


## MEMO

### 略記法
今回はRails初学習のため、できるだけ基本記法で書きます。
ここでは勉強中に見つけた略記法をメモします。

* render
```erb
<%= render partial: 'task', collection: @tasks %>
<%= render @tasks %>
```

```erb
<%= render partial: 'form', locals: {task: @task} %>
<%= render 'form', task: @task %>
```

* i18n
```erb
I18n.t('.h1')
t('.h1')
```

* FactoryBot
```rb
FactoryBot.create(:task, title: '買い物に行く', detail: '卵、牛乳')
create(:task, title: '買い物に行く', detail: '卵、牛乳')
```

（注）`spec/rails_helper.rb`に下記の追記が必要
```spec/rails_helper.rb
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```


