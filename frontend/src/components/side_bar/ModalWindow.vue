<template>
  <div id="overlay" @click="clickEvent">
    <div id="content" @click="stopEvent">
      <p>これがモーダルウィンドウです。</p>
      <p><button @click="clickEvent">close</button></p>
    </div>
  </div>
</template>

<script>
export default {
  methods :{
    clickEvent: function(){
      // 親要素にイベントを渡す
      this.$emit('from-child')
     },stopEvent: function(){
      //  contentsをクリックした時にモーダルが消えないように
      event.stopPropagation()
    }
  }
}
</script>

<style>
/* モーダルの背景(透明) */
#overlay{
  /*　要素を重ねた時の順番　*/
  z-index:1;

  /*　画面全体を覆う設定　*/
  position:fixed;
  top:0;
  left:0;
  width:100%;
  height:100%;
  background-color:rgba(0,0,0,0.5);

  /*　画面の中央に要素を表示させる設定　*/
  display: flex;
  align-items: center;
  justify-content: center;

}

/* モーダルウィンドウ内の背景(白色部分) */
#content{
  z-index:2;
  width:50%;
  padding: 1em;
  background:#fff;
}
</style>