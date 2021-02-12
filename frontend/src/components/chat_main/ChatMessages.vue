<template>
  <div class="messages">
   <p class="message">メッセージ</p>
   <p class="message">メッセージ</p>
   <p class="message">メッセージ</p>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      messages: [],
    }
  },
}
</script>

<style>
  /* メッセージ全体 */
  .messages {
    width: 90%;
    height: calc(100% - 120px);
    margin: 0 auto;
  }
  
  /* 一つ一つのメッセージ */
  .message {
    margin-top: 24px;
    font-size: 20px;
  }
</style>