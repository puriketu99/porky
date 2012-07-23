##コンセプト
テストを書かずに自動テストを実現する

##概要
ChromeのJavascript Console上で利用し、jsのテストケースを書かずに最低限のテストケースを作成し、実行することができます。

テストケースをつくる際に必要な情報は、テストの名前とテストする関数です。

##ライセンス
Version: 0.1.0
Author: puriketu99
License: MIT license

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
```

Chromeのjavascriptコンソールから、下記を実行します。

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
##引数を指定してテストを登録する

下記のような関数に引数を渡すテストを登録する場合を考えます。

```javascript:args
destroy = function(name, father) {
  eric.name = name;
  return eric.family.father.name = father;
};
```

コンソールから、下記のようにargに引数を指定して登録します。

```javascript:args引渡し
>porky.regist({
    name: "destroy test",
    func: "destroy",
    arg: ["destroyer", "darth vader"],
    json_paths: ['window.eric']
})
```

##Ajaxを含むテストを登録する

下記のような関数に引数を渡すテストを登録する場合を考えます。

```javascript:ajax
ajax = function() {
  return $.ajax({
    url: 'sample.json'
  }).done(function(items) {
    var item, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      _results.push($("#tests").append(JSON.stringify(item)));
    }
    return _results;
  });
};
```

コンソールから、下記のようにis_ajaxにtrueを指定して登録します。

```javascript:args引渡し
>porky.regist({
    name: "ajax test",
    func: "ajax",
    is_ajax: true
})
```
##JSONオブジェクトもテストに含める

```javascript:destroy
destroy = function(name, father) {
  eric.name = name;
  return eric.family.father.name = father;
};
```

コンソールから、下記のように監視したいオブジェクトのjsonのパスの文字列を配列形式で指定して登録します。

```javascript:監視オブジェクト指定
>porky.regist(destroy_test = {
    name: "destroy test",
    func: "destroy",
    arg: ["destroyer", "darth vader"],
    json_paths: ['window.eric']
})
```

##仕組み

###registしたときにやっていること

1.registした瞬間のhtmlを保存する。オプションで監視対象のjsonも指定している場合は、対象のjsonオブジェクトも保存。

2.指定された関数を実行する

3.1番と同様に、関数実行後のhtmlやjsonを保存する

\#保存先は、ローカルのindexedDB

###runしたときにやっていること

テストケースごとに、下記を実行している

1.テストケースから、関数実行前のhtmlとjsonの状態を復元する

2.関数を実行する

3.関数実行後のhtmlとjsonの状態と、テストケースで保存されている関数実行後のhtmlとjsonを比較して、差がないかテストする

##連絡先

ぷりっぷりのおしり

puriketu.white at gmail dot com

twitter:@puriketu99

qiita:http://qiita.com/users/puriketu99


