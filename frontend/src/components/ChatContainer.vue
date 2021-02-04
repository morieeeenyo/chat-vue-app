<template>
 <div class="chat">
   <!-- 各コンポーネントにgroupの情報を渡す -->
   <ChatHeader :group="current_group" @emit-update-group="changeUpdatedGroup"></ChatHeader>
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
    components:{
      ChatHeader,
      Messages,
      ChatForm
    },
    methods: {
      changeUpdatedGroup: function(emittedGroup) {
        this.$emit('emit-update-group-from-grand-child', emittedGroup) //Sidebarの情報を更新するために一度Appに情報を渡す
      },
    },
    props: ['current_group'] //親から受け継いだ現在いるグループの情報
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