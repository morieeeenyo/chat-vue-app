# ミニチャットアプリ

## アプリ詳細
ユーザーごとにグループを分けてリアルタイムチャットを行うことができるアプリ

## 使用している言語・フレームワーク
Rails6(Rspec, ActionCable含む)・Vue.js・Webpack

##  実装済みの機能
- グループ新規作成
- グループ情報編集
- グループ情報削除
※上記はいずれもモーダルウィンドウ内よりフォーム送信し、axiosを用いて非同期通信で実装
- ライブチャット機能
※ActionCableで実装

## こだわりポイント
- リロードやブラウザバックした際の処理設計
リロードしたときに表示されている内容に応じてURLが変わるようにすること、
またブラウザバックした際にURLに応じたデータの表示ができていることの2つが非常に難しかったです。

- ActioneCableを用いたライブチャット機能
ActionCableは参考になる日本語の情報が公式レファレンスくらいしかなく、英語の文献がほとんどでした。
そのため英語の文献も読み解きながら実装しました。
特にグループごとにメッセージの配信先を分けることと、メッセージが重複しないようにすることにこだわりました。
また、チャネルのテストコードも数少ない情報を頼りに実装しました。

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

## 今後の実装予定
- ユーザー管理機能
- メッセージに画像を添付する機能
- メッセージへのリプライ機能
- メッセージのお気に入り機能