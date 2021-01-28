<template>
  <div class="side_bar">
    <NewGroup></NewGroup>
    <Groups></Groups>
  </div>
</template>

<script>
import Groups from './side_bar/Groups.vue'
import NewGroup from './side_bar/NewGroup.vue'
  export default {
    components:{
      Groups,
      NewGroup,
    },
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