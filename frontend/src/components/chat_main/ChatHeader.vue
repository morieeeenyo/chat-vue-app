<template>
  <div class="chat-header">
    <div class="header-left">
      <!-- グループの情報は親から受け継ぐ -->
      <p id="group-name">{{ group.group_name }}</p>
      <router-link :to="{ name: 'EditGroup', params: { id: group.id } }" id="edit_button" @click.native="openModal">編集</router-link> 
      <modal-window v-show="showContent" v-on:from-child="closeModal" :form-title="formTitle" :event-type="update" :chat-group="group" :errors="errors" @submit="updateGroup"></modal-window>
    </div>
    <delete-button :group="group" @emit-destroy-group="emitGroup"></delete-button>
  </div>
</template>

<script>
import ModalWindow from '../ModalWindow.vue' 
import DeleteButton from './DeleteButton.vue' 

//ajaxを行うためにimport
import axios from 'axios'; 

export default {
  components:{
      ModalWindow,
      DeleteButton
    },
    data: function (){
      return {
        showContent: false,
        formTitle: 'チャットグループ名変更',
        update: '変更',
        errors: ''
      }
    },
    methods:{
    openModal: function(){
      if (this.group.id === undefined) {
        return alert('グループが選択されていません。サイドバーより選択いただくか左上の+ボタンより新規作成してください。') 
      }
      // モーダルを開く。
      this.showContent = true
    },closeModal: function(){
      // モーダルを閉じる。
      this.showContent = false
      this.errors = "" //モーダルを再度開いたときにエラーメッセージが消えているようにする
    }, updateGroup: function () {
      axios
        .patch(`/api/v1/chat_groups/${this.group.id}`, this.group ) //updateアクション
        .then(response => {
          let group = response.data.group; //返却されたjsonからgroupの情報を取得
          this.$router.push({ name: 'ChatGroup', params: { id: group.id } }); //編集したグループのページに遷移
          this.group.group_name = "" //再度モーダルを開いても入力値が空になっているようにする
          this.emitGroup(group, 'updated') //'updated'は更新か削除かをSidebarで判別するため
          this.closeModal() //モーダルを閉じる
        })
        .catch(error => {
          console.error(error); 
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors; //ビューにエラーメッセージを表示
          }
        });
    }, emitGroup: function(group, event) {
      this.$emit('emit-group', group, event) //削除と更新両方で使えるようにしてる
    }
  },
  watch: {
    '$route': {
       handler: function () {    
        if (this.$route.path !== `/chat_groups/${this.group.id}/edit`) {
          this.showContent = false
        } else {
          this.showContent = true
        }
      }
    }
  },
  props: ['group'] 
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