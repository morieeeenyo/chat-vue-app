<template>
 <div class="chat">
   <ChatHeader></ChatHeader>
 </div>
</template>

<script>
  import ChatHeader from './chat_main/ChatHeader.vue'
  export default {
    components:{
      ChatHeader
    }
  }
</script>

<style scoped>
.chat {
  width: calc(100% - 300px);
  background-color: #FFF;
  padding: 10px;
}
</style>