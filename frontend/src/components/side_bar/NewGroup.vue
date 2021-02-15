<template>
  <div class="side_bar_header">
    <!-- @clickでボタンをクリックした時にモーダルを開く -->
   <router-link :to="{ name: 'CreateGroup' }" class="btn-circle-flat" @click.native="openModal">+</router-link>
   <modal-window v-show="showContent" v-on:from-child="closeModal" @submit="createGroup" :form-title="formTitle" :event-type="create" :chat-group="group" :errors="errors"></modal-window>
  </div>
</template>

<script>
import ModalWindow from '../ModalWindow.vue' 

// 以下はajaxを行うために必要
import axios from 'axios' 

export default {
    components:{
      ModalWindow
    },
    data: function (){
      return {
        showContent: false,
        group: {
          group_name: ""
        },
        formTitle: '新規グループ作成',
        create: '作成',
        errors: ''
      }
    },
    methods:{
    createGroup: function(e) {
      axios
        .post('/api/v1/chat_groups', this.group) //createアクション
        .then(response => {
          let group = response.data.group; 
          this.$router.push({ name: 'ChatGroup', params: { id: group.id } }); //作成したグループのページに遷移する
          this.group.group_name = "" //再度モーダルを開いても入力値が空になっているようにする
          this.$emit('emit-create-group', group) //ModalWindowで新規作成したときに作成したグループの情報をSideBarに追加するためのイベント
          this.closeModal() //モーダルを閉じる
        })
        .catch(error => {
          console.error(error); 
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors; 
          }
        });
    },
    openModal: function(){
      this.group = {}
      this.showContent = true
    },closeModal: function(){
      this.showContent = false
      this.errors = "" //モーダルを再度開いたときにエラーメッセージが消えているようにする
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