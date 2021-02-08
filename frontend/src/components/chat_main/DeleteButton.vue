<template>
 <div class="header-right">
  <router-link :to="{ name: 'BeforeDestroy', params: { id: group.id } }" id="edit_button" @click.native="openModal">チャットグループを削除する</router-link>
  <modal-window v-show="showContent" v-on:from-child="closeModal" :form-title="formTitle" :event-type="destroy" :chat-group="group" :errors="errors" @submit="destroyGroup"></modal-window>
 </div>
</template>

<script>
import ModalWindow from '../ModalWindow.vue' // コンポーネントの読み込み
import axios from 'axios'; //ajaxを行うためにimport
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
      // モーダルを開く。これを入れるとstyleにディスプレイプロパティが付与される
      this.showContent = true
    },closeModal: function(){
      // モーダルを閉じる。
      this.showContent = false
      this.errors = "" //エラーメッセージをリセットする
    }, destroyGroup: function () {
      axios
        .delete(`/api/v1/chat_groups/${this.group.id}`, this.group) //api/v1/groups#updateへのルーティング
        .then(response => {
          let group = response.data.group; //返却されたjsonからgroupの情報を取得
          this.$router.push({ name: 'home' }); //groupのidをパラメータとして渡す。このとっきApp.vueに定義されたwatchが発火する。
          this.group.group_name = "" //モーダルを閉じる前に入力欄をリセットする
          this.$emit('emit-destroy-group', group) //ModalWindowでデータの更新をしたときに作成したグループの情報をChatContainerに渡す
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
  props: ['group']
}
</script>