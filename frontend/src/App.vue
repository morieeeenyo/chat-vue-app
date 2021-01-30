<template>
  <div class="container">
    <sidebar></sidebar>
    <!-- 現在のグループの情報を子孫へ受け継ぐ -->
    <chat-container :current_group="group_data"></chat-container>
  </div>
</template>

<script>
// Vueのインポート
import Vue from 'vue'

// コンポーネントの読み込み
import Sidebar from './components/Sidebar.vue'
import ChatContainer from './components/ChatContainer.vue'
import Groups from './components/side_bar/Groups.vue'

// 以下はajaxを行うために必要
import axios from 'axios' 
import VueAxios from 'vue-axios'
Vue.use(VueAxios, axios) 

// 以下は非同期通信後の遷移先の指定
import VueRouter from 'vue-router'
const router = new VueRouter({
  routes: [
    // グループの情報の取得
    { path: '/chat_groups/:id(\\d+)',  // :id は数値のみに制限する
    name: 'ChatGroup',
    component: ChatContainer  }
  ]
})

Vue.use(VueRouter)

  export default {
    data: function() {
      return {
        group_data: {}, //現在のグループ
      }
    },
    components:{
      Sidebar,
      ChatContainer,
    },
    methods: {
      fetchGroup: function() {
        if (this.$route.path === '/') {
        return null; // ルートパスに同期したときは何もしない。
       }
        axios
        // chat_groups#showアクションへのルーティング。変更後のルーティングから現在のグループを取得してビューに返す
      .get(`/api/v1/chat_groups/${this.$route.params.id}.json`)
      .then(response => {
        this.group_data = response.data 
       }
      ).catch(error => {
          console.error(error); //コンソールにエラーを表示。
          alert('不正なidです')
        });
      },
    },
     // ルーティングに変更があった際のイベント。これで非同期で処理を反映する
    watch: {
    '$route': {
      handler: function () {
        this.fetchGroup()
      },
      immediate: true //同期したときの処理
     },
    },
    router //routerはcomponentではないのでここにexportする
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
