<template>
 <div class="chat">
   <ChatHeader :group="group"></ChatHeader>
   <Messages></Messages>
   <ChatForm></ChatForm>
 </div>
</template>

<script>
  import ChatHeader from './chat_main/ChatHeader.vue'
  import Messages from './chat_main/Messages.vue'
  import ChatForm from './chat_main/ChatForm.vue'
  // 以下はajaxを行うために必要
  import axios from 'axios' 
  export default {
    data: function () {
    return {
      group: {}
    }
  },mounted () {
    axios
      .get(`/api/v1/chat_groups/${this.$route.params.id}.json`)
      .then(response => (this.group = response.data))
  },
    components:{
      ChatHeader,
      Messages,
      ChatForm
    }
  }
</script>

<style scoped>
/* チャット画面(右側白いところ) */
.chat {
  width: calc(100% - 240px);
  background-color: #FFF;
  padding: 10px;
}
</style>