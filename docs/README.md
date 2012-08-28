#Without coding test, test automation for JavaScript.

##Contents
* Summary
* Principal use
* Not suitable use
* Lisence
* Getting started
* Register a test
* Run tests
* Set up a tested function with arguments
* Test for ajax function
* Observe JSON,in addition to html 
* Mechanism
* Contact

##Summary

Without coding test,porky helps that you automate testing for a function of Javascript. 

##Principal use

Regression test.

When you change a part of cord, porky helps you check whether the change influences the other parts.

##Not suitable use

Test first.

Test-driven development is often effective,but it is often painful to write a test and fix it.

##Lisence

Version: 0.1.0

Author: puriketu99

License: MIT license

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

##Register a test

Let's think that we register a test for the following function.

```coffeescript:append
append = function(){
  $("body").append("test case1");
};
```

On JavaScript console in Google Chrome,execute as follows.

```javascript:console
>porky.register({name:"test1",func:"append"})
//Registed
//success
//Object
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

##Set up a tested function with arguments

Let's think that we set up the folowing tested function with arguments.

```javascript:args
destroy = function(name, father) {
  eric.name = name;
  return eric.family.father.name = father;
};
```

On JavaScript console in Google Chrome,set up a tested function with arguments as follows.

```javascript:args
>porky.register({
    name: "destroy test",
    func: "destroy",
    arg: ["destroyer", "darth vader"],
    json_paths: ['window.eric']
})
```

##Test for ajax function

Let's think that we register a test for the following ajax function.

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

On JavaScript console, set up 'is_ajax' with true as follows.

```javascript:args
>porky.register({
    name: "ajax test",
    func: "ajax",
    is_ajax: true
})
```

##Observe JSON,in addition to html 

```javascript:destroy
destroy = function(name, father) {
  eric.name = name;
  return eric.family.father.name = father;
};
```

As follows,on JavaScript console,set up 'json_paths' with the path of JSON you want to observe.

```javascript:observe_json
>porky.register(destroy_test = {
    name: "destroy test",
    func: "destroy",
    arg: ["destroyer", "darth vader"],
    json_paths: ['window.eric']
})
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

##Contact

author:puriketu99

puriketu.white at gmail dot com

twitter:@puriketu99



