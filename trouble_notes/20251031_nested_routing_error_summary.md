# 🧩 ネスト構造におけるエラー原因と対策まとめ

## 🔍 発生したエラー概要
サウナ詳細画面から投稿詳細ページへ遷移しようとした際に、  
次のようなルーティングエラーが発生した。

```
ActionController::RoutingError (No route matches [GET] "/posts/9")
```

---

## ⚙️ 原因
**ルーティングとビューの整合性が取れていなかった**ことが原因。

### 1. ルーティング設定（ネスト構造）
`config/routes.rb`
```ruby
resources :saunas, only: [:index, :show] do
  resources :posts, only: [:index, :show, :new, :create]
end
```

この定義では、投稿はサウナ（親リソース）に**ネスト**しているため、
URLは以下のようになる。

```
/saunas/:sauna_id/posts/:id
```

---

### 2. ビュー（誤りのあったコード）
一部のビューで非ネスト構造のヘルパーを使用していた。

```erb
<%= link_to image_tag(post.image), post_path(post) %>
```

このコードでは、URLが `/posts/:id` 形式になり、
`sauna_id` がコントローラに渡らないため、以下のような問題が発生した。

- `params[:sauna_id]` が `nil` になる  
- `@sauna = Sauna.find(params[:sauna_id])` でエラー  
- 結果としてルート `/posts/:id` にマッチせず Routing Error 発生

---

## ✅ 対策：ネスト構造を統一
ルーティングがネスト構造の場合は、ビューでも**ネスト構造のヘルパーメソッド**を使う。

### 修正版コード（正しい例）
```erb
<%= link_to image_tag(post.image), sauna_post_path(post.sauna, post) %>
```

### 補足：ヘルパーメソッドの意味
| メソッド | 生成されるURL | 意味 |
|-----------|----------------|------|
| `post_path(post)` | `/posts/:id` | 投稿単体（非ネスト） |
| `sauna_post_path(post.sauna, post)` | `/saunas/:sauna_id/posts/:id` | サウナごとの投稿（ネスト構造） |

`sauna_post_path(post.sauna, post)` の引数  
- `post.sauna` → 親（サウナ）のID  
- `post` → 子（投稿）のID  

---

## 💡 コントローラ側のポイント
`PostsController` の各アクションもネスト構造を前提にする。

```ruby
class PostsController < ApplicationController
  before_action :set_sauna

  def show
    @post = @sauna.posts.find(params[:id])
  end

  private

  def set_sauna
    @sauna = Sauna.find(params[:sauna_id])
  end
end
```

---

## 🎯 まとめ
| 問題点 | 対策 |
|---------|------|
| ルーティングがネスト構造なのに、ビューが非ネスト構造だった | ルーティングとビューをネスト構造に統一 |
| URL `/posts/:id` にアクセス → Routing Error | `/saunas/:sauna_id/posts/:id` に修正 |
| `params[:sauna_id]` が取得できない | ネスト経由で親IDを渡す |

---

> ✅ **ポイント：**
> 「ルーティングをネストしたら、ビューとコントローラもネストに揃える」
>  
> Railsでは、親子関係（例：サウナ → 投稿）を明確にするため、
> 全てのルート・ヘルパー・コントローラ処理を統一して設計することが重要。
