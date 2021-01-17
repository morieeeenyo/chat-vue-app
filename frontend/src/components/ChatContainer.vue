<template>
 <div class="chat">
   <ChatHeader></ChatHeader>
   <Messages></Messages>
   <ChatForm></ChatForm>
 </div>
</template>

<script>
  import ChatHeader from './chat_main/ChatHeader.vue'
  import Messages from './chat_main/Messages.vue'
  import ChatForm from './chat_main/ChatForm.vue'
  export default {
    components:{
      ChatHeader,
      Messages,
      ChatForm
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