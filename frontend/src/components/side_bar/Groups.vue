<template>
  <div class="groups">
    <ul class="group-list">
      <!-- 以下は実装途中 -->
      <li>
        チャットグループ1
        <!-- チャットの参加人数 -->
        <span class="member-count">3</span>
      </li>
      <li>
        チャットグループ2
        <span class="member-count">2</span>
      </li>
      <li>
        チャットグループ3
        <span class="member-count">1</span>
      </li>
      <!-- ここまで実装途中 -->
    </ul>
  </div>
</template>

<style>
 /* グループのリスト */
 .group-list {
   padding: 0;
 }

 /* グループリストの中の一つ一つのグループ名の表示 */
 .group-list > li {
   color: #fff;
   list-style: none;
   font-size: 18px;
   margin-bottom: 16px;
 }

  /* グループ名にカーソルが乗った時にポインターにする */
 .groups-list > li:hover {
   cursor: pointer; 
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