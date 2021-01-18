<template>
  <div class="chat-header">
    <div class="header-left">
      <p class="group-name">チャットグループ1</p>
      <a>編集</a> 
    </div>
    <a>チャットグループを削除する</a>
  </div>
</template>

<script>
export default {
  
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
  .group-name {
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