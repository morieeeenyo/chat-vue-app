# ミニチャットアプリ

## アプリ詳細
ユーザーごとにグループを分けてリアルタイムチャットを行うことができるアプリ

## 使用している言語・フレームワーク
Rails6(Rspec, ActionCable含む)・Vue.js・Webpack

##  実装済みの機能
- グループ新規作成
<br>![chat-vue-app-readme-1](https://user-images.githubusercontent.com/64336740/109234622-61778f00-780f-11eb-929b-1a9abb4c1f48.gif)
- グループ情報編集
<br>![chat-vue-app-readme-2](https://user-images.githubusercontent.com/64336740/109234640-69cfca00-780f-11eb-9f03-d37bc9253891.gif)
- グループ情報削除
<br>![chat-vue-app-readme-3](https://user-images.githubusercontent.com/64336740/109234650-6e947e00-780f-11eb-92fb-c5c3ba080e92.gif)
<br>※上記はいずれもモーダルウィンドウ内よりフォーム送信し、axiosを用いて非同期通信で実装
- ライブチャット機能
<br>※ActionCableで実装

## こだわりポイント
- リロードやブラウザバックした際の処理設計
<br> **①リロードしたときに表示されている内容に応じてURLが変わるようにすること**
![chat-vue-app-10-5](https://user-images.githubusercontent.com/64336740/109231117-515cb100-7809-11eb-8fda-683604d67998.gif)
<br> **②ブラウザバックした際にURLに応じたデータの表示ができていること**
![chat-vue-app-10-2-2](https://user-images.githubusercontent.com/64336740/109230428-3b9abc00-7808-11eb-86e5-c8ef8d3db3f0.gif)
<br>の2つが非常に難しかったです。

- ActioneCableを用いたライブチャット機能
<br> **①グループごとにメッセージの配信先を分けること**
<br> **②メッセージの配信が重複しないようにすること**
<br>の2つにこだわりました。
<br>ActionCableは参考になる日本語の情報が公式レファレンスくらいしかなく、英語の文献がほとんどでした。
そのため英語の文献も読み解きながら実装しました。
<br>特にチャネルのテストコードは全く参考になる記事等がなく数少ない情報を頼りに**片っ端から記述を試して**なんとか成功しました。

# DB設計

## chat_groupsテーブル
  |column_name|type|options|
  |-----------|----|-------|
  |group_name|string|null: false, default: ""|

### Associtations 
- has_many :messages

## messagesテーブル

  |column_name|type|options|
  |-----------|----|-------|
  |text|text|null: false|
  |chat_group|reference|null: false, foreing_key: true|

### Associtations 
- belongs_to :chat_group

### 補足
ユーザーを管理する機能は今回の研修では不要とあったためusersテーブルおよび
<br>各テーブルのuser_idカラムは作成しない。
<br>それに伴い、フロントで実装したチャットの参加人数はDBのデータを参照っせず固定された数字を扱うこととする。

## 今後の実装予定
- ユーザー管理機能
- メッセージに画像を添付する機能
- メッセージへのリプライ機能
- メッセージのお気に入り機能
