<template>
  <div class="groups">
    <ul class="group-list" v-for="group in groups" :key="group.id">
      <li class="group-list-item">
        <p><router-link :to="{ name: 'ChatGroup', params: { id: group.id } }">{{ group.group_name }}</router-link></p>
        <span class="member-count">3</span>
      </li>
    </ul>
  </div>
</template>

<script>
// 以下はajaxを行うために必要
import axios from 'axios' 

export default {
  props: ['groups']
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