<template>
  <form class="message-form" @submit.prevent="emitPostMessage">
    <input type="text" class="message-input" v-model="message.text">
    <input type="submit" value="送信" class="message-submit">
  </form>
</template>

<script>
export default {
  data: function() {
    return {
      message: {
        text: ""
      },
    }
  },
  methods: {
    emitPostMessage: function () {
      this.$emit('message-post', this.message)
      this.message.text = "" //入力値のリセット
    }
  },
  props: ['group']
}
</script>

<style>
  /* form全体 */
  .message-form {
    display: flex;
    width: 90%;
    height: 40px;
    margin: 0 auto;
  }
   
   /* テキスト入力欄 */
  .message-input {
    width: calc(100% - 80px);
  }

  /* 送信ボタン */
  .message-submit {
    width: 80px;
    background-color: gray;
    color: #FFF;
    margin: 0 20px;
    border-radius: 2px;
    border-style: none;
    font-size: 18px;
  }
</style>