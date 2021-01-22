<template>
  <div id="overlay" @click="clickEvent">
    <div id="content" @click="stopEvent">
      <!-- submit.preventでevent.preventDefaultと同様の動きになる -->
      <form @submit.prevent="createGroup">
      <h3>チャットグループ新規作成</h3>
      <input type="text" placeholder="チャットグループの名前" name="group_name" v-model="chat_group.group_name" >
      <button type="submit">作成</button>
      </form>
      <p><button>close</button></p>
    </div>
  </div>
</template>

<script>
import axios from 'axios'; //ajaxを行うためにimport
export default {
  data: function () { 
    return {
        chat_group: {
          group_name: ""
        },             //v-model="form.group_name"と連動。初期値を空文字列で設定
     }       
      },
  methods :{
    createGroup: function(e) {
      axios
        .post('/api/v1/chat_groups', this.chat_group) //api/v1/groups#createへのルーティング
        .then(response => {
          let group = response.data.group; //返却されたjsonからgroupの情報を取得
          this.$router.push({ name: 'ChatGroup', params: { id: group.id } }); //groupのidをパラメータとして渡す。このとっきApp.vueに定義されたwatchが発火する。
          this.$emit('from-child') //作成後モーダルを閉じる
        })
    },
    clickEvent: function(){
      // 親要素にイベントを渡す
      this.$emit('from-child')
     },stopEvent: function(){
      //  contentsをクリックした時にモーダルが消えないように
      event.stopPropagation()
    }
  }
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
}
</style>