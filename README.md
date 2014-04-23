#Kill TDD!!

#Without coding test, test automation for JavaScript.

##Principal use

Regression test.

When you change a part of cord, porky helps you check whether the change influences the other parts.

##Not suitable use

Test first.

Test-driven development is often effective,but it is often painful to write a test and fix it.

##DEMO

http://porky-demo.herokuapp.com/

##Register a test

Let's think that we register a test for the following function.

```coffeescript:append
append = function(){$("body").append("test case1");};
```

On JavaScript console in Google Chrome,execute as follows.

```javascript:console
>porky.register({name:"test1",func:"append"})
```

'name' is the name of the test. 'func' is the name of the function.

Registring test has been completed.

##Run tests

On JavaScript console in Google Chrome,Run as follows.

```javascript:console
>porky.run()
```

When you execute pokry.run,print , the results of the tests will be output on the console.

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

1.It saves the snapshot of html when you execute 'porky.register()'.If you specify json,it also saves the json.This is option.

2.It executes the specified function.

3.it also saves the snapshot of the html or the json after the function are executed in the same way as #1

\#the data is saved in the local indexed db.

###about running

In each test case, It executes the following process.

1.It restores html and json to Saved data before executing the function. 

2.It excutes the function.

3.It compares the previous html and json with the present html and json and check whether there is the difference between them or not.


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


Read docs/READ to get details.
