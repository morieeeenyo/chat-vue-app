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
        messages: [], //リアクティブに反映するための箱、必要？
      }
    }
  },
  props: ['group', 'newMessage'],
  watch: {
    'newMessage': {
      handler: function (newMessage) {
        if (this.currentGroup.messages.find(message => message.id == newMessage.id)) {
          return null; //メッセージが重複するのを防ぐ
        }
        this.currentGroup.messages.push(newMessage) //メッセージをリアクティブに反映
      }
    },
    'group': {
      handler: function (group) {
        this.currentGroup.messages = group.messages //リアクティブに反映するにはpropではなくdataに入れなおす必要がある？
      },
      immediate: true
    }
  }
}
</script>

<style>
  /* メッセージ全体 */
  .messages {
    width: 90%;
    padding: 24px 0;
    height: calc(100% - 160px);
    margin: 0 auto;
    overflow: scroll;
  }
  
  /* 一つ一つのメッセージ */
  .message {
    margin-top: 0;
    font-size: 20px;
  }
</style>