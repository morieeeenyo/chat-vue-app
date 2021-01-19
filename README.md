# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# DB設計

## chat_groupsテーブル
|column_name|type|options|
|group_name|string|null: false, default: ""|

# chat_messagesテーブル
|column_name|type|options|
|message_text|text|null: false|
|group|reference|null: false, foreing_key: true|

### ユーザーを管理する機能は今回の研修では不要とあったためusersテーブルおよび
各テーブルのuser_idカラムは作成しない。それに伴い、フロントで実装したチャットの参加人数
はDBのデータを参照っせず固定された数字を扱うこととする。