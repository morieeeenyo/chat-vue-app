<template>
  <div class="container">
    <sidebar></sidebar>
    <chat-container></chat-container>
  </div>
</template>

<script>
import Sidebar from './components/Sidebar.vue'
import ChatContainer from './components/ChatContainer.vue'

  export default {
    components:{
      Sidebar,
      ChatContainer
    }
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
