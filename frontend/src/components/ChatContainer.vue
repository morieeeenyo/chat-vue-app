<template>
 <div class="chat">
   <!-- 各コンポーネントにgroupの情報を渡す -->
   <chat-header :group="currentGroup" @emit-group="groupIsChanged"></chat-header>
   <chat-messages></chat-messages>
   <chat-form></chat-form>
 </div>
</template>

<script>
  import ChatHeader from './chat_main/ChatHeader.vue'
  import ChatMessages from './chat_main/ChatMessages.vue'
  import ChatForm from './chat_main/ChatForm.vue'
  // 以下はajaxを行うために必要
  import axios from 'axios' 
  export default {
    components:{
      ChatHeader,
      ChatMessages,
      ChatForm
    },
    methods: {
      groupIsChanged: function(emittedGroup, event) {
        this.$emit('emit-group-from-grand-child', emittedGroup, event) //SideBarの情報を更新するために一度Appに情報を渡す
      },
    },
    props: ['currentGroup'] //親から受け継いだ現在いるグループの情報
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