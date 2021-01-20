<template>
  <div class="container">
    <sidebar></sidebar>
    <chat-container></chat-container>
  </div>
</template>

<script>
// Vueのインポート
import Vue from 'vue'

// コンポーネントの読み込み
import Sidebar from './components/Sidebar.vue'
import ChatContainer from './components/ChatContainer.vue'
import ModalWindow from './components/side_bar/ModalWindow.vue'

// 以下はajaxを行うために必要
import axios from 'axios' 
import VueAxios from 'vue-axios'
Vue.use(VueAxios, axios) 

// 以下は非同期通信後の遷移先の指定
import VueRouter from 'vue-router'
const router = new VueRouter({
  routes: [
    { path: '/chat_group/new',  // :id は数値のみに制限する
    name: 'GroupCreateForm',
    component: ModalWindow  },
    { path: '/chat_group/:id(\\d+)',  // :id は数値のみに制限する
    name: 'ChatView',
    component: ChatContainer  }
  ]
})

Vue.use(VueRouter)

  export default {
    components:{
      Sidebar,
      ChatContainer,
    },
      router
  }
</script>

<style>
.container {
  display: flex;
  margin: auto;
  width: 80%;
  height: 100vh;
}
</style>
