テストを書かないjsテスティングツール「Porky」をリリースしました
##目次
コンセプト
概要
ライセンス
導入

##コンセプト
テストを書かずに自動テストを実現する
##概要
ChromeのJavascript Console上で利用し、jsのテストケースを書かずに最低限のテストケースを作成し、実行することができます。
テストケースをつくる際に必要な情報は、テストの名前とテストする関数です。
##ライセンス
MITラインセンス
作者:puriketu99
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

##テストの登録
下記の関数をテストケースに登録する場合を考えます。

```coffeescript:テスト対象の関数
append = function(){
  $("body").append("test case1");
};
```Chromeのjavascriptコンソールから、下記を実行します。
```javascript:console
>porky.regist({name:"test1",func:"append"})
//Registed
//success
//Object
```

これでテストの登録は完了です。

##テストの実行
Chromeのjavascriptコンソールから下記を実行します。

```
>porky.run()
//Porky 
//  Runner
//  test1 
//    UI test 
//      success 
//    JSON test 
//      success 
//  test1: 13ms 
//Porky: 25ms 

```
##著作権
author:ぷりっぷりのおしりpuriketu99
twitter:@puriketu99
qiita:http://qiita.com/users/puriketu99
