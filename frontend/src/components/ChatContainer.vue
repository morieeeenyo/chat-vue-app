<template>
 <div class="chat">
   <!-- 各コンポーネントにgroupの情報を渡す -->
   <chat-header :group="currentGroup" @emit-group="groupIsChanged"></chat-header>
   <chat-messages :messages=currentGroup.messages></chat-messages>
   <chat-form :group="currentGroup" @message-post="postMessage"></chat-form>
 </div>
</template>

<script>
  import ChatHeader from './chat_main/ChatHeader.vue'
  import ChatMessages from './chat_main/ChatMessages.vue'
  import ChatForm from './chat_main/ChatForm.vue'
  // 以下はajaxを行うために必要
  import axios from 'axios' 

  // ActionCableを使えるようにするための設定。ChatConatainer内でしか使わないはず
import ActionCable from 'actioncable';
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
      // ChatFormでメッセージが送信されると発火
      postMessage: function (message) {
      //ActionCable MessageChannelにおけるpostメソッドを実行する
      this.messageChannel.perform('post', { 
        message: message.text,
      });
    }
    },
    watch: {
    'currentGroup': {
      handler: function (group) {
        const cable = ActionCable.createConsumer('ws:localhost:3000/cable'); //routes.rbのmount ActionCable.server => '/cable'と対応
        this.messageChannel = cable.subscriptions.create({channel: "MessageChannel", chat_group_id: group.id},{
        received: (data) => {
          group.messages.push(data.message);
       },
       })
      },
      deep: true,
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