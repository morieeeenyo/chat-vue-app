<template>
 <div class="header-right">
   <!-- グループの情報は親から受け継ぐ -->
  <router-link :to="{ name: 'BeforeDestroy', params: { id: group.id } }" id="edit_button" @click.native="openModal">チャットグループを削除する</router-link>
  <modal-window v-show="showContent" v-on:from-child="closeModal" :form-title="formTitle" :event-type="destroy" :chat-group="group" :errors="errors" @submit="destroyGroup"></modal-window>
 </div>
</template>

<script>
import ModalWindow from '../ModalWindow.vue' 

//ajaxを行うためにimport
import axios from 'axios'; 

export default {
  components:{
      ModalWindow,
    },
    data: function (){
      return {
        // コンポーネントのデータ管理は関数なので
        showContent: false,
        formTitle: 'チャットグループ削除',
        destroy: '削除',
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
    }, destroyGroup: function () {
      axios
        .delete(`/api/v1/chat_groups/${this.group.id}`, this.group) //destroyアクション
        .then(response => {
          let group = response.data.group; 
          this.$router.push({ name: 'home' }); //トップページに戻る
          this.group.group_name = "" //再度モーダルを開いても入力値が空になっているようにする
          this.$emit('emit-destroy-group', group, 'destroyed') //'destroyed'は更新か削除かをSideBarで判別するため
          this.closeModal() 
        })
        .catch(error => {
          console.error(error); //コンソールにエラーを表示。
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors; //ビューにエラーメッセージを表示
          }
        });
    }
  },
  watch: {
    '$route': {
        handler: function () {    
        if (this.$route.path !== `/chat_groups/${this.group.id}/destroy`) { //ブラウザバックしたときにモーダルを閉じる
          this.showContent = false
        } else {  //ブラウザを進んだときにモーダルを開く
          this.showContent = true
        }
      }
    }
  },
  props: ['group']
}
</script>