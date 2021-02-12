<template>
 <div class="chat">
   <!-- 各コンポーネントにgroupの情報を渡す -->
   <chat-header :group="currentGroup" @emit-group="groupIsChanged"></chat-header>
   <chat-messages :messages=messages></chat-messages>
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
    data: function () {
      return {
        messages: [],
      }
    },
    components:{
      ChatHeader,
      ChatMessages,
      ChatForm
    },
    created() {
    const cable = ActionCable.createConsumer('ws:localhost:3000/cable');

    this.messageChannel = cable.subscriptions.create( "MessageChannel",{
      received: (data) => {
        this.messages.push(data.message);
      },
    })
  },
    methods: {
      groupIsChanged: function(emittedGroup, event) {
        this.$emit('emit-group-from-grand-child', emittedGroup, event) //SideBarの情報を更新するために一度Appに情報を渡す
      },
      postMessage: function (message) {
      //ActionCable PostChannelにおけるpostメソッドを実行する
      this.messageChannel.perform('post', { 
        message: message.text,
        group: this.currentGroup
      });
      // console.log(this.$store.state.messages);
      //メッセージ追加後にテキストボックスを空にする
      this.messageText = ""
    }
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