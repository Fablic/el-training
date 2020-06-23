# Rails研修課題アプリ:neko

* Ruby version: 2.7.1
* Rails version: 6.0.2.2
* Mysql version: 5.6

## アプリを起動する方法
1. Ruby 2.7.1のインストール
```shell
# homebrew, rbenvのインストールをした前提

rbenv install 2.7.1
```

2. Docker上でのMySQLのビルド
```shell
docker-compose up -d
```

3. ライブラリ(gem)のインストール
```shell
gem install bundler
bundle install --path 'vendor/bundle'
```
4. データベースの作成とマイグレーション
```shell
rails db:setup
```

5. nekoの起動
```shell
rails s
```
6. [localhost:3000](http://localhost:3000/)に接続してタスク一覧が表示されたら成功です。


### エラーについて
```shell
$ rails s

=> Booting Puma
=> Rails 6.0.2.2 application starting in development
=> Run `rails server --help` for more startup options
RAILS_ENV=development environment is not defined in config/webpacker.yml, falling back to production environment
Exiting
```
このエラーによるとwebpackerがインストールされていないということなので、以下のコマンドを実行してください。

```shell
# yarnのインストール
brew install yarn

# webpackerをrailsにインストール
rails webpacker:install
```

```shell
Webpacker successfully installed 🎉 🍰
```
と表示されたら、

```shell
rails s
```
で起動してみてください。

---
## メンテナンスモード
メンテナンスモードは下記のコマンドで操作できます。
```shell
# メンテナンスモード開始
rails maintenance:start

# メンテナンスモード終了
rails maintenance:finish
```

---
## 画面遷移図
以下画像は[Adobe_XDで作成したプロトタイプ](https://xd.adobe.com/view/21c0eada-c16b-4efc-477f-39e5affc1df6-57f1/)から
![prototype1](./docs/prototype-1.png)
![prototype2](./docs/prototype-2.png)

## データベース
![database](./docs/database.png)
