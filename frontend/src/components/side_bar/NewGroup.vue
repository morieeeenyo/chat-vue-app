<template>
  <div class="side_bar_header">
    <!-- @clickでボタンをクリックした時にモーダルを開く -->
   <router-link :to="{ name: 'CreateGroup' }" class="btn-circle-flat" @click.native="openModal">+</router-link>
   <!-- from-Childは子要素ModalWindowから受け取る -->
   <ModalWindow v-show="showContent" v-on:from-child="closeModal" @submit="createGroup" :formTitle="form_title" :createOrEdit="create" :chat_group="group" :errors="errors"></ModalWindow>
  </div>
</template>

<script>
// Vueのインポート
import Vue from 'vue'

import ModalWindow from '../ModalWindow.vue' // コンポーネントの読み込み

// 以下はajaxを行うために必要
import axios from 'axios' 
import VueAxios from 'vue-axios'
Vue.use(VueAxios, axios) 

export default {
    components:{
      ModalWindow
    },
    data: function (){
      return {
        // コンポーネントのデータ管理は関数なので
        showContent: false,
        group: {
          group_name: ""
        },
        form_title: '新規グループ作成',
        create: '作成',
        errors: ''
      }
    },
    methods:{
    createGroup: function(e) {
      axios
        .post('/api/v1/chat_groups', this.group) //api/v1/groups#createへのルーティング
        .then(response => {
          let group = response.data.group; //返却されたjsonからgroupの情報を取得
          this.$router.push({ name: 'ChatGroup', params: { id: group.id } }); //groupのidをパラメータとして渡す。このとっきApp.vueに定義されたwatchが発火する。
          this.group.group_name = "" //モーダルを閉じる前に入力欄をリセットする
          this.$emit('emit-create-group', group) //ModalWindowで新規作成したときに作成したグループの情報をSidebarに渡す
          this.closeModal() //モーダルを閉じる
        })
        .catch(error => {
          console.error(error); //コンソールにエラーを表示。
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors; //ビューにエラーメッセージを表示
          }
        });
    },
    openModal: function(){
      this.group = {}
      // モーダルを開く。これを入れるとstyleにディスプレイプロパティが付与される
      this.showContent = true
    },closeModal: function(){
      // モーダルを閉じる。
      this.showContent = false
      this.errors = "" //エラーメッセージをリセットする
    }
   }
  }
</script>

<style scoped>
  /* +ボタン */
  .btn-circle-flat {
  display: inline-block;
  text-decoration: none;
  width: 40px;
  height: 40px;
  /* +を中央に配置するためにline-heightとtext-alignを入れる */
  line-height: 40px; 
  text-align: center;
  border: 1px solid #ffffff;
  /* ボタンは親要素の背景色を継承しないので別途設定 */
  background-color: gray; 
  color: #ffffff;
  font-weight: bold;
  font-size: 24px;
  border-radius: 50%;
}

  /* ボタンにカーソルが乗ったときにカーソルを変えて押しやすくする */
.btn-circle-flat:hover {
  cursor: pointer;
}

  /* ボタンをクリックした時に青い枠が出ないようにする */
.btn-circle-flat:focus {
  outline: none;
}

</style>