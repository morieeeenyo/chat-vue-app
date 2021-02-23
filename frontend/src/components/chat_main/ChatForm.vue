<template>
  <form class="message-form" @submit.prevent="emitPostMessage">
    <input type="text" id="message_input" v-model="message.text" @keyup="disabledWithEmptyText">
    <input type="submit" value="送信" id="message-submit" v-bind:disabled="isActive">
  </form>
</template>

<script>
export default {
  data: function() {
    return {
      message: {
        text: ""
      },
      isActive: true //submitが送信可能かどうか。trueのとき送信できない
    }
  },
  methods: {
    disabledWithEmptyText: function () {
      if ( !this.message.text.match(/\S/g) ) { //スペースも含む空文字列を判定
        this.isActive = true 
      } else {
        this.isActive = false //空ではないときはdisableを外して送信可能にする
      }
    },
    emitPostMessage: function () {
      if (Object.keys(this.group).length === 0) { //groupが空かどうかチェック
        alert('グループが選択されていません。サイドバーより選択いただくか左上の+ボタンより新規作成してください。') 
        this.isActive = true //アラートが出たときもsubmitのdisableが効くように
      } else if ( !this.message.text.match(/\S/g) ) { //スペースも含む空文字列を判定。検証でdisableを突破された場合の例外処理
        alert('空のメッセージは保存できません。') 
        this.isActive = true
      } else {
        this.$emit('message-post', this.message)
      }
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
  #message_input {
    width: calc(100% - 80px);
  }

  /* 送信ボタン */
  #message-submit {
    width: 80px;
    background-color: gray;
    color: #FFF;
    margin: 0 20px;
    border-radius: 2px;
    border-style: none;
    font-size: 18px;
  }

  #message-submit[disabled] {
    opacity: 0.5;
  }
</style>