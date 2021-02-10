<template>
  <div class="container">
    <!-- グループの更新情報をサイドバーに渡す -->
    <side-bar :changed-group="changedData" :event-type=eventType></side-bar>
    <!-- 現在のグループの情報を子孫へ受け継ぐ -->
    <chat-container :current-group="groupData" @emit-group-from-grand-child="passChangedGroupData"></chat-container>
  </div>
</template>

<script>
// Vueのインポート
import Vue from 'vue'

// コンポーネントの読み込み
import SideBar from './components/SideBar.vue'
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
      component: SideBar
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

    { path: '/chat_groups/:id(\\d+)/destroy',  // :id は数値のみに制限する
    name: 'BeforeDestroy',
    component: ModalWindow  },
  ]
})

Vue.use(VueRouter)

  export default {
    data: function() {
      return {
        groupData: {}, //現在のグループ
        changedData: {}, 
        eventType: ''
      }
    },
    components:{
      SideBar,
      ChatContainer,
    },
    methods: {
      fetchGroup: function() {
      if (this.$route.path === '/' || this.$route.path === '/chat_groups/new') {
        return this.groupData = {} // ルートパスにおよび新規投稿画面同期したときはヘッダーにあるgroupのデータを空にする
       }
        axios
        // chat_groups#showアクションへのルーティング。変更後のルーティングから現在のグループを取得してビューに返す
      .get(`/api/v1/chat_groups/${this.$route.params.id}.json`)
      .then(response => {
        this.groupData = response.data 
       }
      ).catch(error => {
          console.error(error); //コンソールにエラーを表示。
          alert('不正なidです')
          this.$router.push( { name: 'home' } ) //不正なidが送信された際にルートパスに戻す
        });
      }, 
      changePathOnReload: function (e) {
      e.preventDefault()
      if ( this.$route.path === `/chat_groups/${this.groupData.id}/edit` || this.$route.path === `/chat_groups/${this.groupData.id}/destroy`) {
         this.$router.push({name: 'ChatGroup', params: { id: this.groupData.id }}) //edit,destroyの場合はparams.idが存在するので詳細へ
      } else if (this.$route.path === `/chat_groups/new`) {
        this.$router.push({name: 'home'}) //新規登録ページにいる場合はルートに戻す
      } else {
        return null
      }
    }, 
    passChangedGroupData: function (emiitedGroup, event) {
      this.changedData = emiitedGroup //子に渡すために一旦dataに代入
      this.eventType = event
      console.log(event)
    }
  },
    mounted() {
    console.log('created')
     window.addEventListener("load", this.changePathOnReload); //コンポーネント読み込み時にイベント予約
    },
    // destroyed () {
    // console.log('destroyed')
    //  window.removeEventListener("load", this.changePathOnReload); //予約されたイベントを消去
    // },
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
