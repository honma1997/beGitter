// This file is automatically compiled by Webpack
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// Bootstrap と jQuery をインポート
import 'bootstrap'
import 'jquery'

// スタイルシートをインポート
import '../stylesheets/application.scss'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// 検索フォーム用のJavaScript
import './search_form'