# TipsGether

TipsGetherは、日々学んだことや役立つ情報を、気軽にメモ・管理・他者にシェアをすることができます。

## :globe_with_meridians: APP URL
### **https://tpsgthr-20201028125036.herokuapp.com/**


## :wrench: 使用方法

### 1:　ユーザー登録を行う :bust_in_silhouette:
はじめにユーザーを新規登録しましょう。

ゲストログインも可能です。

### 2:　投稿しよう :pen:
ヘッダーから新規投稿にアクセスして投稿しましょう。

公開にチェックを入れると他のユーザーからも視認が可能になります。

## :book: 実装している機能及びテスト

- レスポンシブWebデザイン
- ユーザー登録、ログイン機能(devise gem)
- Post の作成及び編集
- コメント投稿機能(ajax)
- いいねの機能(ajax)
- User は任意でプロフィール画像も登録可(carrierwave gem, AWS-S3)
- User&Post の切り替え可能な検索機能

- Rspec
    - Helpers: ヘルパーメソッドのテスト
    - Models: 各モデルのテスト
    - Requests: 各コントローラーのアクションの稼働テスト
    - System: ブラウザ上での統合テスト

- Rubocop

`git push` 時に Rspec と Rubocop が行われ、成功した場合にのみ Heroku にデプロイされます。
