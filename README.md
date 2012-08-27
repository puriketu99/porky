#Without coding test, test automation for JavaScript.

##Principal use

Regression test.

This is effective when checking whether there are any other influences when a part is corrected. 

##Not suitable use

Test first.

Test first development is often effective,but it is often a pain to write test code and fix it. 

##Register a test

Let's think that we register a test for the following function.

```coffeescript:append
append = function(){$("body").append("test case1");};
```

On JavaScript console in Google Chrome,execute as the following.

```javascript:console
>porky.register({name:"test1",func:"append"})
```

'name' is name of test. 'func' is name of function.

Registring test has been done.

##Run tests

On JavaScript console in Google Chrome,Run as the following.

```javascript:console
>porky.run()
```

When you execute pokry.run,print results of tests on the console.

```yaml:result
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


##Mechanism
###about registering

1.It saves the snapshot of html when you execute 'porky.register()'.If you specify json,it save the json.This is option.

2.It executes the function specified.

3.As well As #1、it saves the snapshot after it executes.

\#Saved data is saved in indexed db.

###about running

By the test cases,It executes the following.

1.It restores html and json to Saved data before executing the function. 

2.It excutes the function.

3.It compares row and saved data after executing the function.


##Getting started

Clone [https://github.com/puriketu99/porky](https://github.com/puriketu99/porky) and import files.

```sh:clone
git clone https://github.com/puriketu99/porky.git
```


```html:importfiles
<script src="/porky/jquery.js"></script>
<script src="/porky/indexeddb.shim.js"></script>
<script src="/porky/jquery.indexeddb.js"></script>
<script src="/porky/porky.js"></script>
```


About details,read docs/READ.md
