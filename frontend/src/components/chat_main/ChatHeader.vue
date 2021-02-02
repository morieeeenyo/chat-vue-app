<template>
  <div class="chat-header">
    <div class="header-left">
      <!-- グループの情報は親から受け継ぐ -->
      <p id="group-name">{{ group.group_name }}</p>
      <router-link :to="{ name: 'EditGroup', params: { id: group.id } }" id="edit_button" @click.native="openModal">編集</router-link> 
      <!-- 子要素から受け取ったsubmitイベントを使ってupdateを動かす -->
      <ModalWindow v-show="showContent" v-on:from-child="closeModal" :formTitle="form_title" :createOrEdit="edit" :chat_group="group" :errors="errors" @submit="updateGroup"></ModalWindow>
    </div>
    <a>チャットグループを削除する</a>
  </div>
</template>

<script>
import ModalWindow from '../ModalWindow.vue' // コンポーネントの読み込み
import axios from 'axios'; //ajaxを行うためにimport

export default {
  components:{
      ModalWindow
    },
    data: function (){
      return {
        // コンポーネントのデータ管理は関数なので
        showContent: false,
        form_title: 'チャットグループ名変更',
        edit: '変更',
        errors: ''
      }
    },

    methods:{
    openModal: function(){
      if (this.group.id === undefined) {
        return alert('グループが選択されていません。サイドバーより選択いただくか左上の+ボタンより新規作成してください。') 
      }
      // モーダルを開く。これを入れるとstyleにディスプレイプロパティが付与される
      this.showContent = true
    },closeModal: function(){
      // モーダルを閉じる。
      this.showContent = false
      this.errors = "" //エラーメッセージをリセットする
    }, updateGroup: function () {
      axios
        .patch(`/api/v1/chat_groups/${this.group.id}`, this.group ) //api/v1/groups#updateへのルーティング
        .then(response => {
          let group = response.data.group; //返却されたjsonからgroupの情報を取得
          this.$router.push({ name: 'ChatGroup', params: { id: group.id } }); //groupのidをパラメータとして渡す。このとっきApp.vueに定義されたwatchが発火する。
          this.group.group_name = "" //モーダルを閉じる前に入力欄をリセットする
          this.closeModal() //モーダルを閉じる
        })
        .catch(error => {
          console.error(error); //コンソールにエラーを表示。
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors; //ビューにエラーメッセージを表示
          }
        });
    }
  },
  props: ['group'] //親から受け継いだグループのデータを表示するための属性。値には現在表示しているグループの情報が入っている。親でgroupというpropを使ったので名前は別にする。
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
  #group-name {
    margin: 0 20px 0 0;
    font-size: 24px;
  }

  /* 編集ボタンと削除ボタン */
  .chat-header a {
    color: gray;
    font-size: 12px;
    text-decoration: none;
  }

  /* 編集ボタンと削除ボタンにカーソルが乗ったときにポインターに変更 */
  .chat-header a:hover {
    cursor: pointer;
  }
</style>