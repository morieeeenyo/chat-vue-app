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

# Associtations 
- has_many :messages

# messagesテーブル
|column_name|type|options|
|text|text|null: false|
|chat_group|reference|null: false, foreing_key: true|

# Associtations 
- belongs_to :chat_group

### ユーザーを管理する機能は今回の研修では不要とあったためusersテーブルおよび
各テーブルのuser_idカラムは作成しない。それに伴い、フロントで実装したチャットの参加人数
はDBのデータを参照っせず固定された数字を扱うこととする。