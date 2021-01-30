<template>
  <div class="chat-header">
    <div class="header-left">
      <!-- グループの情報は親から受け継ぐ -->
      <p id="group-name">{{ group_name }}</p>
      <a>編集</a> 
    </div>
    <a>チャットグループを削除する</a>
  </div>
</template>

<script>
export default {
  props: ['group_name'] //親から受け継いだグループのデータを表示するための属性。値には現在表示しているグループの情報が入っている。親でgroupというpropを使ったので名前は別にする。
}
</script>

<style>
  /* ヘッダー全体 */
  .chat-header {
    display: flex;
    justify-content: space-between;
    border-bottom: 1px solid black;
    height: 60px;
    width: 90%;
    line-height: 60px;
    margin: 0 auto;
    padding: 0 10px;
  }

   /* グループ名と編集ボタン */
  .header-left {
    display: flex;
    justify-content: space-between;
  }

  /* グループ名 */
  #group-name {
    margin: 0 20px 0 0;
    font-size: 24px;
  }

  /* 編集ボタンと削除ボタン */
  .chat-header a {
    color: gray;
    font-size: 12px;
  }

  編集ボタンと削除ボタンにカーソルが乗ったときにポインターに変更
  .chat-header a:hover {
    cursor: pointer;
  }
</style>