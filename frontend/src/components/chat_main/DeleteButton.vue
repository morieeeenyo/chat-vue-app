<template>
 <div class="header-right">
  <router-link :to="{ name: 'EditGroup', params: { id: group.id } }" id="edit_button" @click.native="openModal">チャットグループを削除する</router-link>
  <modal-window v-show="showContent" v-on:from-child="closeModal" :form-title="formTitle" :event-type="destroy" :chat-group="group" :errors="errors" ></modal-window>
 </div>
</template>

<script>
import ModalWindow from '../ModalWindow.vue' // コンポーネントの読み込み
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
    }, 
  },
  props: ['group']
}
</script>