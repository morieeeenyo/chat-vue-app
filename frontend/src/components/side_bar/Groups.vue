<template>
  <div class="groups">
    <ul class="group-list" v-for="group in groups" :key="group.id">
      <li class="group-list-item">
        <p><router-link :to="{ name: 'ChatGroup', params: { id: group.id } }">{{ group.group_name }}</router-link></p>
        <!-- チャットの参加人数 -->
        <span class="member-count">3</span>
      </li>
      <!-- ここまで実装途中 -->
    </ul>
  </div>
</template>

<script>
// Vueのインポート
import Vue from 'vue'

// 以下はajaxを行うために必要
import axios from 'axios' 
import VueAxios from 'vue-axios'
Vue.use(VueAxios, axios) 

export default {
  data: function () {
    return {
      groups: [] //group一覧機能実装時に使う。もし必要なさそうならグループ作成時はコメントアウトする。
    }
  },mounted() {
     axios
    .get('/api/v1/chat_groups.json')
    .then(response => (this.groups = response.data.groups))
  }
}
</script>

<style>
 /* グループのリスト */
 .group-list {
   padding: 0;
 }

 /* グループリストの中の一つ一つのグループ名の表示 */
 .group-list-item {
   color: #fff;
   list-style: none;
   font-size: 18px;
   margin-bottom: 16px;
   display: flex;
   justify-content: space-between;
 }

  /* グループ名にカーソルが乗った時にポインターにする */
 .group-list-item:hover {
   cursor: pointer; 
 }

 .group-list-item  > p {
   width: 70%;
   margin: 0;
   /* グループ名が長いときに途中から…で省略 */
   overflow: hidden;
   text-overflow: ellipsis;
   white-space: nowrap;
 }

 .group-list-item a {
   text-decoration: none;
   color: #FFF;
   font-size: 18px;
 }

  /* メンバー数の表示 */
  .member-count {
    background-color: #f36767;
    color: #fff;
    display: inline-block;
    border-radius: 16px;
    padding: 0 12px;
    margin-left: 20px; 
  }
</style>