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

  .header-left {
    display: flex;
    justify-content: space-between;
  }

  .group-name {
    margin: 0 20px 0 0;
    font-size: 24px;
  }

  .chat-header a {
    color: gray;
    font-size: 12px;
  }
</style>