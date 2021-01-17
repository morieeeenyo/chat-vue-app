<template>
 <div class="chat">
   <ChatHeader></ChatHeader>
   <Messages></Messages>
 </div>
</template>

<script>
  import ChatHeader from './chat_main/ChatHeader.vue'
  import Messages from './chat_main/Messages.vue'
  export default {
    components:{
      ChatHeader,
      Messages
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