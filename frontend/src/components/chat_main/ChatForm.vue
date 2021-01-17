<template>
  <form class="message-form">
    <input type="text" class="message-input">
    <input type="submit" value="送信" class="message-submit">
  </form>
</template>

<script>
export default {
  
}
</script>

<style>
  .message-form {
    display: flex;
    width: 90%;
    height: 40px;
    margin: 0 auto;
  }

  .message-input {
    width: calc(100% - 80px);
  }

  .message-submit {
    width: 80px;
    background-color: gray;
    color: #FFF;
    margin: 0 20px;
    border-radius: 2px;
    border-style: none;
    font-size: 18px;
  }
</style>