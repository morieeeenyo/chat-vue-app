<template>
  <div class="chat-header">
    <div class="header-left">
      <!-- グループの情報は親から受け継ぐ -->
      <p id="group-name">{{ group.group_name }}</p>
      <router-link :to="{ name: 'EditGroup', params: { id: group.id } }" id="edit_button" @click.native="openModal">編集</router-link> 
      <ModalWindow v-show="showContent" v-on:from-child="closeModal" :formTitle="form_title" :createOrEdit="edit" :chat_group="group" :errors="errors"></ModalWindow>
    </div>
    <a>チャットグループを削除する</a>
  </div>
</template>

<script>
import ModalWindow from '../ModalWindow.vue' // コンポーネントの読み込み

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
      // モーダルを開く。これを入れるとstyleにディスプレイプロパティが付与される
      this.showContent = true
    },closeModal: function(){
      // モーダルを閉じる。
      this.showContent = false
    }, 
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