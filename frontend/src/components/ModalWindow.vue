<template>
  <div id="overlay" @click="emitCloseEvent">
    <div id="content" @click="stopEvent">
      <!-- emitして親コンポーネントで処理を動かすことでeditとupdateで処理を分ける -->
      <form @submit.prevent="$emit('submit')" id="group_form">
        <div v-if="errors.length != 0">
          <!-- エラーメッセージの表示 -->
          <ul v-for="e in errors" :key="e">
           <li class="error-messages"><font color="red">{{ e }}</font></li>
          </ul>
        </div>
         <h2 class="form-title">{{ formTitle }}</h2>
          <!-- 削除のときはgroup_nameの入力は不要なので表示しない -->
          <input type="text" placeholder="チャットグループの名前" name="group_name" id="group_name_input" v-model="chatGroup.group_name" v-if="eventType != '削除'">
          <button type="submit" id="group_form_submit">{{ eventType }}</button>
      </form>
     <p><button @click="emitCloseEvent" id="close_button">close</button></p>
    </div>
  </div>
</template>

<script>
import axios from 'axios'; //ajaxを行うためにimport
export default {
  methods :{
    emitCloseEvent: function(){
      // 親要素にイベントを渡す
      this.$emit('from-child')
      // モーダルを閉じたときにグループのページに遷移。新規作成の場合はidがないのでトップページに
      this.$router.push({ name: 'ChatGroup', params: { id: this.chatGroup.id } }); 
     },stopEvent: function(){
      //  contentsをクリックした時にモーダルが消えないように
      event.stopPropagation()
    },
  },
  props: ['eventType', 'chatGroup', 'errors', 'formTitle']
}
</script>

<style>
/* モーダルの背景(透明) */
#overlay{
  /*　要素を重ねた時の順番　*/
  z-index:1;

  /*　画面全体を覆う設定　*/
  position:fixed;
  top:0;
  left:0;
  width:100%;
  height:100%;
  background-color:rgba(0,0,0,0.5);

  /*　画面の中央に要素を表示させる設定　*/
  display: flex;
  align-items: center;
  justify-content: center;

}

/* モーダルウィンドウ内の背景(白色部分) */
#content{
  z-index:2;
  width:50%;
  padding: 1em;
  background:#fff;
  display: flex;
  justify-content: space-between;
  border-radius: 2px;
}

#group_form {
  /* formが狭く感じたので余白をつけた */
  padding: 0 3%;
}

#content button {
  /* グループ作成ボタンと閉じるボタン共通のスタイル */
  width: 80px;
  color: #FFF;
  margin: 0 20px;
  border-radius: 2px;
  border-style: none;
  font-size: 18px;
}

#group_form_submit {
  /* グループ作成ボタン。メッセージ送信ボタンとスタイルは同じ */
  background-color: gray;
}

#group_name_input {
  /* グループ名の入力欄 */
  width: 200px;
  border-radius: 2px;
  font-size: 18px;
  border: 1px solid black;
  padding: 3px;
}

#close_button {
  /* 閉じるボタン */
  background-color: red;
}

.error-messages {
  /* エラーメッセージの先頭の・をなくす */
  list-style: none;
}

#content button:hover {
  /* ボタンにホバーした時のスタイル */
  cursor: pointer;
  opacity: 0.8;
}
</style>