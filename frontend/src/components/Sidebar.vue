<template>
  <div class="side_bar">
    <NewGroup @emit-create-group="AddNewGroup"></NewGroup>
    <!-- グループの新規作成時に子コンポーネントからイベントが渡ることでfetchGroupAllが発火する。 -->
    <Groups :groups="allGroupData"></Groups>
  </div>
</template>

<script>
import Groups from './side_bar/Groups.vue'
import NewGroup from './side_bar/NewGroup.vue'

// 以下はajaxを行うために必要
import axios from 'axios' 

  export default {
    data: function () {
      return {
        allGroupData: [], //全てのグループ
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
        .then(response => (this.allGroupData = response.data.groups))
      },
      AddNewGroup: function (emittedGroup) {
        this.allGroupData.unshift(emittedGroup) //子コンポーネントから受け取った新規グループを一覧表示のための配列に追加
      }
    },
    watch: {
      'changedGroup': function(changedGroup) {
        if(this.eventType === 'destroyed') {
          //削除時は削除されたグループ以外の要素だけ残して配列を作り直す
          return this.allGroupData = this.allGroupData.filter(e => e.id !== changedGroup.id) 
        }
        //更新時は更新されたグループとidが一致する要素を検索し、更新
        this.allGroupData.filter(e => e.id == changedGroup.id)[0].group_name = changedGroup.group_name 
      }
    },
    props: ['changedGroup', 'eventType']
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