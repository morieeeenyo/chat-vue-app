<template>
  <div class="messages">
   <div v-for="message in messages" :key="message.text">
    <p class="message">{{ message }}</p>
   </div>
  </div>
</template>

<script>
export default {
  props: ['messages']
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