<template>
  <div class="side_bar_header">
    <!-- @clickでボタンをクリックした時にモーダルを開く -->
   <button class="btn-circle-flat" @click="openModal">+</button>
   <!-- from-Childは子要素ModalWindowから受け取る -->
   <ModalWindow v-show="showContent" v-on:from-child="closeModal"></ModalWindow>
  </div>
</template>

<script>
import ModalWindow from './ModalWindow.vue' // コンポーネントの読み込み
export default {
    components:{
      ModalWindow
    },
    data: function (){
      return {
        // コンポーネントのデータ管理は関数なので
        showContent: false
      }
    },
    methods:{
    openModal: function(){
      // モーダルを開く。これを入れるとstyleにディスプレイプロパティが付与される
      this.showContent = true
    },closeModal: function(){
      // モーダルを閉じる。
      this.showContent = false
    }
   }
  }
</script>

<style scoped>
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
  overflow: hidden;
  transition: .4s;
}

.btn-circle-flat:hover {
  /* ボタンにカーソルが乗ったときにカーソルを変えて押しやすくする */
  cursor: pointer;
}

</style>