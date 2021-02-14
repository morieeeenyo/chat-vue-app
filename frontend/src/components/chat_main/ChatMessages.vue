<template>
  <div class="messages">
   <div v-for="message in currentGroup.messages" :key="message.id">
    <p class="message">{{ message.text }}</p>
   </div>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      currentGroup: {
        messages: [],
      }
    }
  },
  props: ['group', 'newMessage'],
  watch: {
    'newMessage': {
      handler: function (newMessage) {
        this.currentGroup.messages.push(newMessage)
      }
    },
    'group': {
      handler: function (group) {
        this.currentGroup.messages = group.messages 
      },
      deep: true,
      immediate: true
    }
  }
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