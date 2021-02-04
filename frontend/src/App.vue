<template>
  <div class="container">
    <!-- グループの更新情報をサイドバーに渡す -->
    <sidebar :updated_group="changedData"></sidebar>
    <!-- 現在のグループの情報を子孫へ受け継ぐ -->
    <chat-container :current_group="group_data" @emit-update-group-from-grand-child="passChangedGroupData"></chat-container>
  </div>
</template>

<script>
// Vueのインポート
import Vue from 'vue'

// コンポーネントの読み込み
import Sidebar from './components/Sidebar.vue'
import ChatContainer from './components/ChatContainer.vue'
import Groups from './components/side_bar/Groups.vue'
import ModalWindow from './components//ModalWindow.vue' 

// 以下はajaxを行うために必要
import axios from 'axios' 
import VueAxios from 'vue-axios'
Vue.use(VueAxios, axios) 

// 以下は非同期通信後の遷移先の指定
import VueRouter from 'vue-router'
const router = new VueRouter({
  routes: [
    // ルートパス。現状はshowアクションで不正なidが送信された際に使用
    {
      path: '/',
      name: 'home',
      component: Sidebar
    },
    {
      path: '/chat_groups/new',
      name: 'CreateGroup',
      component: ModalWindow
    },
    // グループの情報の取得
    { path: '/chat_groups/:id(\\d+)',  // :id は数値のみに制限する
    name: 'ChatGroup',
    component: ChatContainer  },

    { path: '/chat_groups/:id(\\d+)/edit',  // :id は数値のみに制限する
    name: 'EditGroup',
    component: ModalWindow  },
  ]
})

Vue.use(VueRouter)

  export default {
    data: function() {
      return {
        group_data: {}, //現在のグループ
        changedData: {}
      }
    },
    components:{
      Sidebar,
      ChatContainer,
    },
    methods: {
      fetchGroup: function() {
      if (this.$route.path === '/' || this.$route.path === '/chat_groups/new') {
        return this.group_data = {} // ルートパスにおよび新規投稿画面同期したときはヘッダーにあるgroupのデータを空にする
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
          this.$router.push( { name: 'home' } ) //不正なidが送信された際にルートパスに戻す
        });
      }, 
      changePathOnReload: function (e) {
      if ( this.$route.path === `/chat_groups/${this.group_data.id}` ) {
         return null; //既に'chatGroupのページにいる場合はNavigationDuplicatedエラーが出るのでreturn nullする
      }
       this.$router.push({name: 'ChatGroup', params: { id: this.group_data.id }}) //editの場合はparams.idが存在するので詳細へ、それ以外はparams.idがないのでrootへ戻す
    }, 
    passChangedGroupData: function (emiitedGroup) {
      this.changedData = emiitedGroup //子に渡すために一旦dataに代入
    }
  },
    mounted() {
    console.log('created')
     window.addEventListener("load", this.changePathOnReload); //コンポーネント読み込み時にイベント予約
    },
    destroyed () {
    console.log('destroyed')
     window.removeEventListener("load", this.changePathOnReload); //予約されたイベントを消去
    },
    watch: {
     // ルーティングに変更があった際にURLからアクセスしているグループの情報を取得。これで非同期で処理を反映する
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
