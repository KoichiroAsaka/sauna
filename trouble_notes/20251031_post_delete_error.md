# 🧭 投稿削除機能でエラーが出た原因と対応まとめ

## 🔍 不具合の内容
投稿ページや編集ページで「削除」ボタンを押しても、投稿が削除されませんでした。  
クリックしてもページがリロードされるだけで、データベースから削除されない状態でした。

---

## ⚠️ 原因

原因は、**Turbo（ターボ）と Stimulus（スティミュラス）という JavaScript の仕組みが正しく読み込まれていなかった**ことです。

Rails 7 では、削除ボタンの動作（`DELETE` リクエストに変える処理）は JavaScript（Turbo）によって行われます。

ところが、ブラウザのコンソールには次のようなエラーが出ていました👇

```
Failed to resolve module specifier "@hotwired/stimulus".
Relative references must start with either "/", "./", or "../".
```

このエラーは「Stimulusというモジュールが見つかりません」という意味です。  
つまり、**JavaScriptの読み込み設定が壊れていたため、削除ボタンがただのリンク（GETリクエスト）として扱われていた**ということです。

---

## 🛠 対応方法

### ① Stimulus・Turbo のモジュールを登録する

ターミナルで以下を実行しました（Windows の場合は `ruby` をつける）：

```bash
ruby bin/importmap pin @hotwired/stimulus
ruby bin/importmap pin @hotwired/stimulus-loading
ruby bin/importmap pin @hotwired/turbo-rails
```

➡ これで Rails の設定ファイル `config/importmap.rb` に必要なモジュール情報が追加されます。

---

### ② サーバーを再起動する

設定を反映させるために、一度サーバーを止めて再起動しました：

```bash
Ctrl + C   # サーバー停止
rails s    # サーバー再起動
```

---

### ③ 削除リンクの記述を修正する

Rails 7 の Turbo では、`data-turbo-method` のように **ハイフン付き** で指定する必要があります。

以下のように修正しました👇

```erb
<%= link_to "削除", post_path(@post),
    data: { "turbo-method": :delete, "turbo-confirm": "本当に削除しますか？" },
    class: "btn btn-outline-danger" %>
```

---

### ④ Turbo が読み込まれているか確認する

一時的に以下のコードを入れて確認しました👇

```js
document.addEventListener("turbo:load", () => {
  console.log("Turbo is loaded")
})
```

ブラウザの開発者ツール（F12）で「Turbo is loaded」と表示されればOKです。

---

### ⑤ 動作確認

1. ブラウザをリロード  
2. 投稿一覧または編集ページを開く  
3. 「削除」ボタンを押す  
4. Network タブで `DELETE /posts/:id` が送られているか確認  

✅ 成功すると、対象の投稿が削除され、一覧ページに戻ります。

---

## 📋 今後のチェックポイント

| チェック項目 | 内容 |
|---------------|------|
| `config/importmap.rb` | Stimulus と Turbo が `pin` されているか |
| `app/javascript/application.js` | `import "@hotwired/turbo-rails"` があるか |
| `app/views/layouts/application.html.erb` | `<%= javascript_importmap_tags %>` があるか |
| リンク記述 | `data: { "turbo-method": :delete }` になっているか |

---

## ✅ 結果
修正後は、ブラウザコンソールに  
`Turbo is loaded` と表示され、削除ボタンを押すと  
投稿が正常に削除できるようになりました🎉

---

### 💡 まとめ
| 項目 | 内容 |
|------|------|
| 不具合の原因 | Turbo・Stimulus が読み込まれていなかった |
| 対応方法 | importmap に登録してサーバー再起動 |
| 主な修正ファイル | `config/importmap.rb`, `application.js`, `application.html.erb` |
| 検証方法 | コンソールで `Turbo is loaded` を確認 |
| 結果 | 削除ボタンが正常に機能 |
