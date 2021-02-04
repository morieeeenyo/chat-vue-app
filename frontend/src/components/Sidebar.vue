<template>
  <div class="side_bar">
    <NewGroup @emit-create-group="AddNewGroup"></NewGroup>
    <!-- グループの新規作成時に子コンポーネントからイベントが渡ることでfetchGroupAllが発火する。 -->
    <Groups :groups="all_group_data"></Groups>
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
        emittedGroup: {} //子コンポーネントから受け取った新規グループのデータ
      }
    }, mounted: function () {
      this.fetchGroupAll()
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
      },
      AddNewGroup: function (emittedGroup) {
        this.all_group_data.push(emittedGroup) //子コンポーネントから受け取った新規グループを一覧表示のための配列に追加
      }
    },
    watch: {
      'updated_group': function(updatedGroup) {
        this.all_group_data.filter(e => e.id == updatedGroup.id)[0].group_name = updatedGroup.group_name //更新されたグループとidが一致する要素を検索し、更新
      }
    },
    props: ['updated_group']
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