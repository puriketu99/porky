window.indexedDB = window.indexedDB || window.webkitIndexedDB || window.mozIndexedDB || window.msIndexedDB
window.IDBTransaction = window.IDBTransaction || window.webkitIDBTransaction || window.msIDBTransaction
window.IDBKeyRange = window.IDBKeyRange|| window.webkitIDBKeyRange || window.msIDBKeyRange
window.IDBCursor = window.IDBCursor || window.webkitIDBCursor || window.msIDBCursor

avoid_objects = ["window['performance']"
"window['event']"
"window['console']"
"window['document']"
"window['history']"
"window['clientInformation']"
"window['navigator']"
"window['$']"
"window['Audio']"
"window['Image']"
"window['Option']"
]
success = ->
  console.log("%csuccess","background-color:#5bb75b;color:white")
fail = ->
  console.log("%cfail","background-color:#da4f49;color:white")

window.porky = {}
class porky.Db
  DBNAME = ''
  TABLE = ''
  SCHEMA = {}
  report = (error,event)->
    console.group "Report"
    console.log error
    console.log event
    console.groupEnd "Report"
  register_report = (data)->
    console.group "Registed"
    success()
    console.log data
    console.groupEnd "Registed"
  constructor:(dbname,table)->
    DBNAME = dbname
    TABLE = table
    SCHEMA = 
      "schema": 
        "1": (versionTransaction)->
          fixture = versionTransaction.createObjectStore(TABLE, {
            "keyPath": "name"
            "autoIncrement": false
          })
          fixture.createIndex "name"
  put:(data)->
    obj = $.indexedDB(DBNAME,SCHEMA).objectStore(TABLE)
    obj.put(data).then(
          ->
            register_report(data)
          report
        )
  find:(name)->
    $.indexedDB(DBNAME,SCHEMA).objectStore(TABLE).get(name)
  get:(run)->
    list = []
    $.indexedDB(DBNAME,SCHEMA).objectStore(TABLE).index('name').each((e)->
      list.push e.value
      return
    ).then(
      -> run list
      report
    )
  delete:(key)->
    $.indexedDB(DBNAME,SCHEMA).objectStore(TABLE)
	    .delete(key).then(report,report)

class porky.Register
  DBNAME = 'PORKY'
  TABLE = 'fixtures'
  checked_objects = {}
  register_f2s = (obj,obj_path,obj_type)->
    checked_objects[obj_type] = []
    register_fixture.checked_paths[obj_type] = register_fixture.checked_paths[obj_type] || []
    native_func = /(return)? *function .*\(.*\) {\n? +\[?native (function)?/
    helper = (help_obj,path)->
      switch 
        when help_obj is null
          help_obj
        when typeof help_obj is 'function'
          "(function(){return #{String(help_obj)}})()"
        when help_obj in checked_objects[obj_type]
          path_index = checked_objects[obj_type].indexOf help_obj
          temp_path = register_fixture.checked_paths[obj_type][path_index]
          "(function(){return #{temp_path}})()"
        when help_obj instanceof Array
          checked_objects[obj_type].push help_obj
          register_fixture.checked_paths[obj_type].push path
          return (helper v,"#{path}[#{i}]" for v,i in help_obj)
        when help_obj instanceof jQuery
          console.log('%cPorky does not support jQuery objects','color:#666')
          'jQuery object'
        when typeof help_obj is "object"
          checked_objects[obj_type].push help_obj
          register_fixture.checked_paths[obj_type].push path
          that = {}
          for key,value of help_obj
            if !(String(value).match native_func) and "#{path}['#{key}']" not in avoid_objects and key isnt 'enabledPlugin' 
              that[key] = helper value,"#{path}['#{key}']"
          return that
        else help_obj
    helper(obj,obj_path)
  register_fixture = 
    obj:null
    arg:[]
    json_paths:[]
    checked_paths:{}
  register = ()->
    register_fixture.after_html = document.getElementsByTagName("html")[0].innerHTML
    register_fixture.after_window = (register_f2s(eval(obj_path),obj_path,"after_window") for obj_path in register_fixture.json_paths) 
    (new porky.Db(DBNAME,TABLE)).put register_fixture
  constructor:(register_data)->
    for field,value of register_data
      if field is 'arg'
        register_fixture[field] = register_f2s(value,'fixture.arg','arg')
      else
        register_fixture[field] = value
    if register_fixture.json_paths?
      register_fixture.before_window = (register_f2s(eval(obj_path),obj_path,"before_window") for obj_path in register_fixture.json_paths) 
    register_fixture.before_html = document.getElementsByTagName("html")[0].innerHTML
    eval_code = "#{register_fixture.func}.apply(register_fixture.obj,register_fixture.arg)"
    register_fixture.return_value =  register_f2s(eval(eval_code),'fixture.return_value','return_value')
    register_fixture.delay =  register_fixture.delay || 0
    setTimeout(
      ->register(),
      register_fixture.delay)

class porky.Reregister
  DBNAME = 'PORKY'
  TABLE = 'fixtures'
  constructor:(name)->
    (new porky.Db(DBNAME,TABLE)).find(name)
      .done((fixture)->new porky.Register(fixture))

class porky.Runner
  DBNAME = 'PORKY'
  TABLE = 'fixtures'
  func_pattern = /\(function\(\)\{return /
  before_s2f = (obj,obj_path)->
    setw = (path,help_db)->
      eval_str = "#{path} = help_db"
      eval(eval_str)
    helper = (help_db,path)->
      switch 
        when help_db instanceof Array
          for v in help_db
            helper(v,"#{path}[#{_i}]")
        when typeof help_db is "object"
          for key,value of help_db
            helper(help_db[key],"#{path}['#{key}']")
        when typeof help_db is 'string' and help_db.match(func_pattern) isnt null
          setw path,eval(help_db)
        else
          setw path,help_db
      return
    helper(obj,obj_path)
  judge = (arg)->
    after_f2s = (obj,obj_path,obj_type)->
      fixture = arg.fixture
      inner_fail = (expected,actual,path)-> 
        console.group 'javascript object fail'
        console.log '%cfail','background-color:red;color:white'
        console.group 'json path'
        console.log path 
        console.groupEnd 'json path'
        console.group 'expected'
        console.log expected
        console.groupEnd 'expected'
        console.group 'actual'
        console.log actual
        console.groupEnd 'actual'
        console.groupEnd 'json fail'
        flag = false
      not_same_type = (expected,actual)->
       typeof expected isnt typeof actual 
      flag = true
      checked_objects = []
      helper = (help_db,path)->
        help_window = eval(path)
        switch 
          when help_db is null
            if help_window isnt null
              inner_fail(help_db,help_window,path)
          when help_window instanceof jQuery
            console.log('%cPorky does not support jQuery objects','color:#666')
            'jQuery object'
          when help_db in checked_objects
            path_index = checked_objects.indexOf help_db
            db_path = fixture.checked_paths[obj_type][path_index]
            evaled_obj = eval(db_path)
          when help_db instanceof Array
            checked_objects.push help_db
            if help_db.length isnt help_window.length or not_same_type(help_db,help_window)
              inner_fail(help_db,help_window)
            else
              (helper help_db[i],"#{path}[#{i}]" for v,i in help_window)
          when typeof help_window is 'object' and typeof help_db is 'string' and help_db.match(func_pattern) isnt null
            evaled_obj = eval(help_db)
            checked_objects.push evaled_obj
            if evaled_obj isnt help_window
              inner_fail(evaled_obj,help_window,path)
          when typeof help_db is "object"
            checked_objects.push help_db
            if not_same_type(help_db,help_window)
              inner_fail(help_db,help_window,path)
            else
              for key,value of help_db
                helper help_db[key],"#{path}['#{key}']"
          when typeof help_window is 'function' and typeof help_db is 'string'
            window_func = "(function(){return #{String(help_window)}})()"
            if help_db isnt window_func
              evaled_func = eval(help_db)
              inner_fail(evaled_func,help_window,path)
          else
            if help_db isnt help_window
              inner_fail(help_db,help_window,path)
        return
      helper(obj,obj_path)
      return flag
    console.group 'Fixture'
    console.log arg.fixture
    console.groupEnd 'Fixture'
    console.group 'UI test'
    if arg.fixture.after_html is document.getElementsByTagName("html")[0].innerHTML
      success()
    else
      fail()
    console.groupEnd 'UI test'
    console.group 'Return value test'
    flag = after_f2s(arg.current_return_value,'arg.current_return_value','return_value')
    if flag
      success()
    console.groupEnd 'Return value test'
    console.group 'JSON test'
    if arg.fixture.json_paths?
      flags = (after_f2s(arg.fixture.after_window[i],path,'after_window') for path,i in arg.fixture.json_paths)
    else
      flags = []
    if false not in flags
      success()
    console.groupEnd 'JSON test'
    console.log "Delay: #{arg.fixture.delay}ms"
    console.timeEnd arg.fixture.name
    console.groupEnd arg.fixture.name
    arg.dfd.resolve()
    return
  test = (list)->
    if list.length is 0
      console.timeEnd 'Porky'
      console.groupEnd 'Porky'
      return 
    fixture = list.shift()
    console.group fixture.name
    console.time fixture.name
    if fixture.before_window?
      (before_s2f(obj,fixture.json_paths[i]) for obj,i in fixture.before_window)
    document.getElementsByTagName("html")[0].innerHTML = fixture.before_html
    dfd = $.Deferred()
    dfd.then(
      ()->test list
      (error,event)->
        console.error error 
        console.log fixture
        console.timeEnd 'Porky'
        console.groupEnd 'Porky'
        return 'test error'
    )
    eval_code = "#{fixture.func}.apply(fixture.obj,fixture.arg)"
    current_return_value = eval(eval_code)
    setTimeout(
      ->judge({"fixture":fixture,"dfd":dfd,"current_return_value":current_return_value}),
      fixture.delay)

  constructor:()->
    console.group 'Porky'
    console.time 'Porky'
    (new porky.Db(DBNAME,TABLE)).get(test)

class porky.Deleter
  DBNAME = 'PORKY'
  TABLE = 'fixtures'
  constructor:(key)->
    (new porky.Db(DBNAME,TABLE)).delete(key)


porky.register = (fixture)->(new porky.Register(fixture))
porky.reregister = (name)->(new porky.Reregister(name))
porky.run = ()->(new porky.Runner())
porky.delete = (key)->(new porky.Deleter(key))
