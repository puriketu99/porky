##コンセプト

テストを書かずにテストの自動化を実現する

##主な用途
リグレッションテスト
一部を修正したときに他に影響がないかを確認するときに効果的です

##向かない用途
テストファーストによる開発

##テストの登録

下記の関数をテストケースに登録する場合を考えます。

```coffeescript:テスト対象の関数
append = function(){$("body").append("test case1");};
```

javascriptコンソールから、下記を実行します。

```javascript:console
>porky.register({name:"test1",func:"append"})
```

nameはテストの名称、funcは関数の名前です。
これでテストの登録は完了です。

##テストの実行

Chromeのjavascriptコンソールから下記を実行します。

```javascript:console
>porky.run()
```

pokry.runを実行すると、下記のようにテスト結果がconsole上に出力されます。

```yaml:結果
Porky 
  Runner
  test1 
    UI test 
      success 
    JSON test 
      success 
  test1: 13ms 
Porky: 25ms 
```


##仕組み
###registerしたときにやっていること

1.registerした瞬間のhtmlを保存する。オプションで監視対象のjsonも指定している場合は、対象のjsonオブジェクトも保存。

2.指定された関数を実行する

3.1番と同様に、関数実行後のhtmlやjsonを保存する

\#保存先は、ローカルのindexedDB

###runしたときにやっていること

テストケースごとに、下記を実行している

1.テストケースから、関数実行前のhtmlとjsonの状態を復元する

2.関数を実行する

3.関数実行後のhtmlとjsonの状態と、テストケースで保存されている関数実行後のhtmlとjsonを比較して、差がないかテストする


##導入

[https://github.com/puriketu99/porky](https://github.com/puriketu99/porky)からcloneして、必要なファイルを読み込む

```sh:clone
git clone https://github.com/puriketu99/porky.git
```

```html:必要なjavascriptファイルを読み込む
<script src="/porky/jquery.js"></script>
<script src="/porky/indexeddb.shim.js"></script>
<script src="/porky/jquery.indexeddb.js"></script>
<script src="/porky/porky.js"></script>
```

詳細は、docs/README.mdをご覧ください。
