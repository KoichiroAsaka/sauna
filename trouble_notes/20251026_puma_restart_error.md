# 🧰 開発トラブル対策メモ
## Rails開発中に「Permission denied」エラーが出たとき

---

## 🧩 エラー概要

```
ActionView::Template::Error (Permission denied @ rb_file_s_rename)
```

**意味：**  
Rails が一時ファイル（キャッシュ）を書き換えようとしたが、  
Windows が「アクセス禁止」と返したためエラーになった。

---

## 💡 主な原因

Rails はページを表示する際、  
画像・CSS・JS などの一時データを  
`tmp/cache` フォルダに保存します。

以下のような状態だと、ファイルの権限が壊れたりロックされたりして  
キャッシュ更新に失敗します。

| 原因 | 説明 |
|------|------|
| OneDriveやクラウド上で開発している | 同期の影響でファイルロックがかかる |
| 古いtmpフォルダが残っている | 過去のRails実行時のキャッシュが干渉 |
| 強制終了や異常終了 | キャッシュファイルが壊れて残る |
| 権限設定の問題 | Windowsのアクセス制限で書き込み失敗 |

---

## 🔧 解決方法（お掃除手順）

以下のコマンドを順番に実行👇

```bash
# ① tmpフォルダ削除
Remove-Item -Recurse -Force tmp

# ② 新しく作り直す
mkdir tmp

# ③ tmpフォルダのRailsキャッシュをクリア
bundle exec rails tmp:clear

# ④ assets(CSS/JS)を再生成するために削除
bundle exec rails assets:clobber

# ⑤ Railsサーバー再起動
ruby bin\rails s
```

👉 これで Rails がクリーンな状態から再構築され、  
トップページが正常に表示されるようになります。

---

## 🚫 再発防止のポイント

| よくある原因 | 対策 |
|---------------|------|
| OneDrive上で作業 | ❌ 同期によるロック発生 → **ローカル(C:\Users\ユーザー名\portfolioなど)** に移動 |
| 古いキャッシュが残る | 定期的に `rails tmp:clear` を実行 |
| 強制終了後に再起動エラー | 再起動前に `tmp` を削除 |
| asset関係のエラー | `rails assets:clobber` で再生成 |

---

## 🧠 覚え方メモ

> 「Rails動かないときは、お掃除して再起動」

つまり…

```
tmp削除 → assets削除 → rails s
```

この3ステップで解決するケースが多いです✨

---

## ✅ まとめ

| 項目 | 内容 |
|------|------|
| エラー名 | Permission denied @ rb_file_s_rename |
| 原因 | tmp/cache のアクセス権や古いキャッシュ |
| 対策 | tmp と assets を削除・再生成 |
| 防止策 | OneDrive外で開発・定期キャッシュクリア |

---

💬 **補足**  
今回のようなトラブルは、Rails本体よりも「Windowsのファイルロック」が原因のことが多いです。  
フォルダの場所を整理しておくことで、今後の開発がかなりスムーズになります。
