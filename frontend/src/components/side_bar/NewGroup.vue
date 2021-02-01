<template>
  <div class="side_bar_header">
    <!-- @clickでボタンをクリックした時にモーダルを開く -->
   <router-link :to="{ name: 'CreateGroup' }" class="btn-circle-flat" @click.native="openModal">+</router-link>
   <!-- from-Childは子要素ModalWindowから受け取る -->
   <ModalWindow v-show="showContent" v-on:from-child="closeModal" @created-group="emitGroupDataToParent" :createOrEdit="create" :chat_group="group" :errors="errors"></ModalWindow>
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
        group: {},
        create: '新規グループ作成',
        errors: ''
      }
    },
    methods:{
    openModal: function(){
      this.grouo = {}
      // モーダルを開く。これを入れるとstyleにディスプレイプロパティが付与される
      this.showContent = true
    },closeModal: function(){
      // モーダルを閉じる。
      this.showContent = false
    }, emitGroupDataToParent: function (emittedGroup) {
      this.group = emittedGroup //引数として新規作成したグループを受け取り一度オブジェクトに代入する
      this.$emit('emit-group-from-grand-child', this.group) //ModalWindowで新規作成したときにemitしてきたイベントと作成したグループの情報さらに親に渡す
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