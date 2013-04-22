window.indexedDB = window.indexedDB || window.webkitIndexedDB || window.mozIndexedDB || window.msIndexedDB
window.IDBTransaction = window.IDBTransaction || window.webkitIDBTransaction || window.msIDBTransaction
window.IDBKeyRange = window.IDBKeyRange|| window.webkitIDBKeyRange || window.msIDBKeyRange
window.IDBCursor = window.IDBCursor || window.webkitIDBCursor || window.msIDBCursor

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
    console.log "success"
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
  register_f2s = (obj_path)->
    main_obj = eval(obj_path)
    register_fixture.checked_objects = []
    checked_paths = []
    native_func = /(return)? *function .*\(.*\) {\n? +\[?native (function)?/
    avoid_objects = ["window['performance']","window['event']","window['console']","window['document']","window['history']","window['clientInformation']","window['navigator']","window['$']","window['Audio']","window['Image']","window['Option']"]
    helper = (help_obj,path)->
      switch 
        when help_obj is null
          help_obj
        when typeof help_obj is 'function'
          "(function(){return #{String(help_obj)}})()"
        when help_obj in register_fixture.checked_objects
          "(function(){return #{path}})()"
        when help_obj instanceof Array
          register_fixture.checked_objects.push help_obj
          return (helper v,"#{path}[#{i}]" for v,i in help_obj)
        when typeof help_obj is "object"
          register_fixture.checked_objects.push help_obj
          that = {}
          for key,value of help_obj
            if !(String(value).match native_func) and "#{path}['#{key}']" not in avoid_objects and key isnt 'enabledPlugin' 
              that[key] = helper value,"#{path}['#{key}']"
          return that
        else help_obj
    helper(main_obj,obj_path)
  register_fixture = 
    obj:null
    arg:[]
  register = ()->
    register_fixture.after_html = document.getElementsByTagName("html")[0].innerHTML
    if register_fixture.json_paths?
      register_fixture.after_window = (register_f2s obj for obj in register_fixture.json_paths) 
    (new porky.Db(DBNAME,TABLE)).put register_fixture
  constructor:(register_data)->
    for field,value of register_data
      register_fixture[field] = value
    if register_fixture.json_paths?
      register_fixture.before_window = (register_f2s obj for obj in register_fixture.json_paths)
    register_fixture.before_html = document.getElementsByTagName("html")[0].innerHTML
    eval_code = "#{register_fixture.func}.apply(register_fixture.obj,register_fixture.arg)"
    eval eval_code
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
  zip = (arr1, arr2) ->
    basic_zip = (el1, el2) -> [el1, el2]
    zipWith basic_zip, arr1, arr2
  zipWith = (func, arr1, arr2) ->
    min = Math.min arr1.length, arr2.length
    ret = []
    for i in [0...min]
      ret.push func(arr1[i], arr2[i])
    ret
  func_pattern = /\(function\(\)\{return /

  before_s2f = (db_obj,path)->
    setw = (path,help_db)->
      eval_str = "#{path} = help_db"
      eval(eval_str)
    helper = (help_db,path)->
      if path is "window['Audio']"
        console.log "path"
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
    helper(db_obj,path)

  after_f2s = (db_obj,path)->
    inner_fail = (expected,actual,path)-> 
      console.group 'json fail'
      console.error 'fail'
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
    helper = (help_db,path)->
      help_window = eval(path)
      switch 
        when help_db is null
          if help_window isnt null
            inner_fail(help_db,help_window,path)
        when help_db instanceof Array
          if help_db.length isnt help_window.length or not_same_type(help_db,help_window)
            inner_fail(help_db,help_window)
          else
            (helper help_db[i],"#{path}[#{i}]" for v,i in help_window)
        when typeof help_window is 'object' and typeof help_db is 'string' and help_db.match(func_pattern) isnt null
          evaled_obj = eval(help_db)
          if evaled_obj isnt help_window
            inner_fail(evaled_obj,help_window,path)
        when typeof help_db is "object"
          if not_same_type(help_db,help_window)
            inner_fail(help_db,help_window,path)
          else
            for key,value of help_db
              helper help_db[key],"#{path}['#{key}']"
        when typeof help_window is 'function'
          window_func = "(function(){return #{String(help_window)}})()"
          if help_db isnt window_func
            evaled_func = eval(help_db)
            inner_fail(evaled_func,help_window,path)
        else
          if help_db isnt help_window
            inner_fail(help_db,help_window,path)
      return
    helper(db_obj,path)
    return flag

  judge = (arg)->
    console.group 'Fixture'
    console.log arg.fixture
    console.groupEnd 'Fixture'
    console.group 'UI test'
    if arg.fixture.after_html is document.getElementsByTagName("html")[0].innerHTML
      console.log 'success'
    else
      console.error 'ui fail'
    console.groupEnd 'UI test'
    console.group 'JSON test'
    if arg.fixture.json_paths?
      flags = (after_f2s(arg.fixture.after_window[i],path) for path,i in arg.fixture.json_paths)
    else
      flags = []
    if false not in flags
      console.log 'success'
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
    eval eval_code
    setTimeout(
      ->judge({"fixture":fixture,"dfd":dfd}),
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
