<template>
  <div class="side_bar">
    <NewGroup></NewGroup>
  </div>
</template>

<script>
import Groups from './side_bar/Groups.vue'
import NewGroup from './side_bar/NewGroup.vue'
  export default {
    components:{
      Groups,
      NewGroup,
    }
  }
</script>

<style>
 .side_bar {
  width: 300px;
  background-color: gray;
  padding: 20px;
}
</style>