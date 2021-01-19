// Vueのインポート
import Vue from 'vue'
import App from './App.vue'

// 以下はajaxを行うために必要
import axios from 'axios' 
import VueAxios from 'vue-axios'
Vue.use(VueAxios, axios) 

// App.vueをエントリとしてレンダリング
new Vue({
  el: '#app',
  render: h => h(App)
})