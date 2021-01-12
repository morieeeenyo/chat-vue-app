<template>
  <div class="side_bar_header">
   <button href="#" class="btn-circle-flat" @click="openModal">+</button>
   <ModalWindow></ModalWindow>
  </div>
</template>

<script>
import ModalWindow from './ModalWindow.vue'
export default {
    components:{
      ModalWindow
    },
    data: function (){
      return {
        showContent: false
      }
    },
    methods:{
    openModal: function(){
      this.showContent = true
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
  line-height: 40px;
  border: 1px solid #ffffff;
  border-radius: 50%;
  text-align: center;
  overflow: hidden;
  transition: .4s;
}

.btn-circle-flat:hover {
  cursor: pointer;
}

</style>