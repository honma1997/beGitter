// This file is automatically compiled by Webpack
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// Rails UJSを明示的に開始
Rails.start()
Turbolinks.start()
ActiveStorage.start()

// スタイルシートをインポート
import '../stylesheets/application.scss'

// jQuery を window オブジェクトに割り当て（オプション）
import $ from 'jquery';
window.$ = window.jQuery = $;

// 非同期処理のためのカスタムコード
document.addEventListener('turbolinks:load', function() {
  // いいねボタンのための処理
  $(document).on('ajax:success', '.like-button form', function(event) {
    console.log('いいね処理成功');
  });
  
  // コメントフォームのための処理
  $(document).on('ajax:success', '.comment-form form', function(event) {
    console.log('コメント処理成功');
  });
});