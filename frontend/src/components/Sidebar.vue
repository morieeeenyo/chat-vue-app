<template>
  <div class="side_bar">
    <NewGroup></NewGroup>
    <!-- グループの新規作成時に子コンポーネントからイベントが渡ることでfetchGroupAllが発火する。 -->
    <Groups :groups="all_group_data" @emit-new-group-data="fetchGroupAll"></Groups>
  </div>
</template>

<script>
// Vueのインポート
import Vue from 'vue'

// コンポーネントの読み込み
import Groups from './side_bar/Groups.vue'
import NewGroup from './side_bar/NewGroup.vue'

// 以下はajaxを行うために必要
import axios from 'axios' 
import VueAxios from 'vue-axios'
Vue.use(VueAxios, axios) 

  export default {
    data: function () {
      return {
        all_group_data: [], //全てのグループ
      }
    },
    components:{
      Groups,
      NewGroup,
    },
    methods: {
      fetchGroupAll: function () {
        axios
        .get('/api/v1/chat_groups.json')
        .then(response => (this.all_group_data = response.data.groups))
      }
    },
    watch: {
      all_group_data: {
       handler: function () {
         this.fetchGroupAll()
       },
       immediate: true //同期したときの処理
     }
    } 
  }
</script>

<style>
/* サイドバー(左側のグレー) */
 .side_bar {
  width: 240px;
  background-color: gray;
  padding: 20px;
  overflow: scroll;
}
</style>