// Generated by CoffeeScript 1.3.1
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  window.indexedDB = window.indexedDB || window.webkitIndexedDB || window.mozIndexedDB || window.msIndexedDB;

  window.IDBTransaction = window.IDBTransaction || window.webkitIDBTransaction || window.msIDBTransaction;

  window.IDBKeyRange = window.IDBKeyRange || window.webkitIDBKeyRange || window.msIDBKeyRange;

  window.IDBCursor = window.IDBCursor || window.webkitIDBCursor || window.msIDBCursor;

  window.porky = {};

  porky.Db = (function() {
    var DBNAME, SCHEMA, TABLE, register_report, report;

    Db.name = 'Db';

    DBNAME = '';

    TABLE = '';

    SCHEMA = {};

    report = function(error, event) {
      console.group("Report");
      console.log(error);
      console.log(event);
      return console.groupEnd("Report");
    };

    register_report = function(data) {
      console.group("Registed");
      console.log("success");
      console.log(data);
      return console.groupEnd("Registed");
    };

    function Db(dbname, table) {
      DBNAME = dbname;
      TABLE = table;
      SCHEMA = {
        "schema": {
          "1": function(versionTransaction) {
            var fixture;
            fixture = versionTransaction.createObjectStore(TABLE, {
              "keyPath": "name",
              "autoIncrement": false
            });
            return fixture.createIndex("name");
          }
        }
      };
    }

    Db.prototype.put = function(data) {
      var obj;
      obj = $.indexedDB(DBNAME, SCHEMA).objectStore(TABLE);
      return obj.put(data).then(function() {
        return register_report(data);
      }, report);
    };

    Db.prototype.find = function(name) {
      return $.indexedDB(DBNAME, SCHEMA).objectStore(TABLE).get(name);
    };

    Db.prototype.get = function(run) {
      var list;
      list = [];
      return $.indexedDB(DBNAME, SCHEMA).objectStore(TABLE).index('name').each(function(e) {
        list.push(e.value);
      }).then(function() {
        return run(list);
      }, report);
    };

    Db.prototype["delete"] = function(key) {
      return $.indexedDB(DBNAME, SCHEMA).objectStore(TABLE)["delete"](key).then(report, report);
    };

    return Db;

  })();

  porky.Register = (function() {
    var DBNAME, TABLE, register, register_f2s, register_fixture;

    Register.name = 'Register';

    DBNAME = 'PORKY';

    TABLE = 'fixtures';

    register_f2s = function(obj_path) {
      var avoid_objects, checked_paths, helper, main_obj, native_func;
      main_obj = eval(obj_path);
      register_fixture.checked_objects = [];
      checked_paths = [];
      native_func = /(return)? *function .*\(.*\) {\n? +\[?native (function)?/;
      avoid_objects = ["window['performance']", "window['event']", "window['console']", "window['document']", "window['history']", "window['clientInformation']", "window['navigator']", "window['$']", "window['Audio']", "window['Image']", "window['Option']"];
      helper = function(help_obj, path) {
        var i, key, that, v, value, _ref;
        switch (false) {
          case help_obj !== null:
            return help_obj;
          case typeof help_obj !== 'function':
            return "(function(){return " + (String(help_obj)) + "})()";
          case __indexOf.call(register_fixture.checked_objects, help_obj) < 0:
            return "(function(){return " + path + "})()";
          case !(help_obj instanceof Array):
            register_fixture.checked_objects.push(help_obj);
            return (function() {
              var _i, _len, _results;
              _results = [];
              for (i = _i = 0, _len = help_obj.length; _i < _len; i = ++_i) {
                v = help_obj[i];
                _results.push(helper(v, "" + path + "[" + i + "]"));
              }
              return _results;
            })();
          case typeof help_obj !== "object":
            register_fixture.checked_objects.push(help_obj);
            that = {};
            for (key in help_obj) {
              value = help_obj[key];
              if (!(String(value).match(native_func)) && (_ref = "" + path + "['" + key + "']", __indexOf.call(avoid_objects, _ref) < 0) && key !== 'enabledPlugin') {
                that[key] = helper(value, "" + path + "['" + key + "']");
              }
            }
            return that;
          default:
            return help_obj;
        }
      };
      return helper(main_obj, obj_path);
    };

    register_fixture = {
      obj: null,
      arg: [],
      json_paths: []
    };

    register = function() {
      var obj;
      register_fixture.after_html = document.getElementsByTagName("html")[0].innerHTML;
      register_fixture.after_window = (function() {
        var _i, _len, _ref, _results;
        _ref = register_fixture.json_paths;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          obj = _ref[_i];
          _results.push(register_f2s(obj));
        }
        return _results;
      })();
      return (new porky.Db(DBNAME, TABLE)).put(register_fixture);
    };

    function Register(register_data) {
      var eval_code, field, obj, value;
      for (field in register_data) {
        value = register_data[field];
        register_fixture[field] = value;
      }
      if (register_fixture.json_paths != null) {
        register_fixture.before_window = (function() {
          var _i, _len, _ref, _results;
          _ref = register_fixture.json_paths;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            obj = _ref[_i];
            _results.push(register_f2s(obj));
          }
          return _results;
        })();
      }
      register_fixture.before_html = document.getElementsByTagName("html")[0].innerHTML;
      eval_code = "" + register_fixture.func + ".apply(register_fixture.obj,register_fixture.arg)";
      eval(eval_code);
      register_fixture.delay = register_fixture.delay || 0;
      setTimeout(function() {
        return register();
      }, register_fixture.delay);
    }

    return Register;

  })();

  porky.Reregister = (function() {
    var DBNAME, TABLE;

    Reregister.name = 'Reregister';

    DBNAME = 'PORKY';

    TABLE = 'fixtures';

    function Reregister(name) {
      (new porky.Db(DBNAME, TABLE)).find(name).done(function(fixture) {
        return new porky.Register(fixture);
      });
    }

    return Reregister;

  })();

  porky.Runner = (function() {
    var DBNAME, TABLE, after_f2s, before_s2f, func_pattern, judge, test, zip, zipWith;

    Runner.name = 'Runner';

    DBNAME = 'PORKY';

    TABLE = 'fixtures';

    zip = function(arr1, arr2) {
      var basic_zip;
      basic_zip = function(el1, el2) {
        return [el1, el2];
      };
      return zipWith(basic_zip, arr1, arr2);
    };

    zipWith = function(func, arr1, arr2) {
      var i, min, ret, _i;
      min = Math.min(arr1.length, arr2.length);
      ret = [];
      for (i = _i = 0; 0 <= min ? _i < min : _i > min; i = 0 <= min ? ++_i : --_i) {
        ret.push(func(arr1[i], arr2[i]));
      }
      return ret;
    };

    func_pattern = /\(function\(\)\{return /;

    before_s2f = function(db_obj, path) {
      var helper, setw;
      setw = function(path, help_db) {
        var eval_str;
        eval_str = "" + path + " = help_db";
        return eval(eval_str);
      };
      helper = function(help_db, path) {
        var key, v, value, _i, _len;
        if (path === "window['Audio']") {
          console.log("path");
        }
        switch (false) {
          case !(help_db instanceof Array):
            for (_i = 0, _len = help_db.length; _i < _len; _i++) {
              v = help_db[_i];
              helper(v, "" + path + "[" + _i + "]");
            }
            break;
          case typeof help_db !== "object":
            for (key in help_db) {
              value = help_db[key];
              helper(help_db[key], "" + path + "['" + key + "']");
            }
            break;
          case !(typeof help_db === 'string' && help_db.match(func_pattern) !== null):
            setw(path, eval(help_db));
            break;
          default:
            setw(path, help_db);
        }
      };
      return helper(db_obj, path);
    };

    after_f2s = function(db_obj, path) {
      var flag, helper, inner_fail, not_same_type;
      inner_fail = function(expected, actual, path) {
        var flag;
        console.group('json fail');
        console.error('fail');
        console.group('json path');
        console.log(path);
        console.groupEnd('json path');
        console.group('expected');
        console.log(expected);
        console.groupEnd('expected');
        console.group('actual');
        console.log(actual);
        console.groupEnd('actual');
        console.groupEnd('json fail');
        return flag = false;
      };
      not_same_type = function(expected, actual) {
        return typeof expected !== typeof actual;
      };
      flag = true;
      helper = function(help_db, path) {
        var evaled_func, evaled_obj, help_window, i, key, v, value, window_func, _i, _len;
        help_window = eval(path);
        switch (false) {
          case help_db !== null:
            if (help_window !== null) {
              inner_fail(help_db, help_window, path);
            }
            break;
          case !(help_db instanceof Array):
            if (help_db.length !== help_window.length || not_same_type(help_db, help_window)) {
              inner_fail(help_db, help_window);
            } else {
              for (i = _i = 0, _len = help_window.length; _i < _len; i = ++_i) {
                v = help_window[i];
                helper(help_db[i], "" + path + "[" + i + "]");
              }
            }
            break;
          case !(typeof help_window === 'object' && typeof help_db === 'string' && help_db.match(func_pattern) !== null):
            evaled_obj = eval(help_db);
            if (evaled_obj !== help_window) {
              inner_fail(evaled_obj, help_window, path);
            }
            break;
          case typeof help_db !== "object":
            if (not_same_type(help_db, help_window)) {
              inner_fail(help_db, help_window, path);
            } else {
              for (key in help_db) {
                value = help_db[key];
                helper(help_db[key], "" + path + "['" + key + "']");
              }
            }
            break;
          case typeof help_window !== 'function':
            window_func = "(function(){return " + (String(help_window)) + "})()";
            if (help_db !== window_func) {
              evaled_func = eval(help_db);
              inner_fail(evaled_func, help_window, path);
            }
            break;
          default:
            if (help_db !== help_window) {
              inner_fail(help_db, help_window, path);
            }
        }
      };
      helper(db_obj, path);
      return flag;
    };

    judge = function(arg) {
      var flags, i, path;
      console.group('Fixture');
      console.log(arg.fixture);
      console.groupEnd('Fixture');
      console.group('UI test');
      if (arg.fixture.after_html === document.getElementsByTagName("html")[0].innerHTML) {
        console.log('success');
      } else {
        console.error('ui fail');
      }
      console.groupEnd('UI test');
      console.group('JSON test');
      if (arg.fixture.json_paths != null) {
        flags = (function() {
          var _i, _len, _ref, _results;
          _ref = arg.fixture.json_paths;
          _results = [];
          for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
            path = _ref[i];
            _results.push(after_f2s(arg.fixture.after_window[i], path));
          }
          return _results;
        })();
      } else {
        flags = [];
      }
      if (__indexOf.call(flags, false) < 0) {
        console.log('success');
      }
      console.groupEnd('JSON test');
      console.log("Delay: " + arg.fixture.delay + "ms");
      console.timeEnd(arg.fixture.name);
      console.groupEnd(arg.fixture.name);
      arg.dfd.resolve();
    };

    test = function(list) {
      var dfd, eval_code, fixture, i, obj, _i, _len, _ref;
      if (list.length === 0) {
        console.timeEnd('Porky');
        console.groupEnd('Porky');
        return;
      }
      fixture = list.shift();
      console.group(fixture.name);
      console.time(fixture.name);
      if (fixture.before_window != null) {
        _ref = fixture.before_window;
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          obj = _ref[i];
          before_s2f(obj, fixture.json_paths[i]);
        }
      }
      document.getElementsByTagName("html")[0].innerHTML = fixture.before_html;
      dfd = $.Deferred();
      dfd.then(function() {
        return test(list);
      }, function(error, event) {
        console.error(error);
        console.log(fixture);
        console.timeEnd('Porky');
        console.groupEnd('Porky');
        return 'test error';
      });
      eval_code = "" + fixture.func + ".apply(fixture.obj,fixture.arg)";
      eval(eval_code);
      return setTimeout(function() {
        return judge({
          "fixture": fixture,
          "dfd": dfd
        });
      }, fixture.delay);
    };

    function Runner() {
      console.group('Porky');
      console.time('Porky');
      (new porky.Db(DBNAME, TABLE)).get(test);
    }

    return Runner;

  })();

  porky.Deleter = (function() {
    var DBNAME, TABLE;

    Deleter.name = 'Deleter';

    DBNAME = 'PORKY';

    TABLE = 'fixtures';

    function Deleter(key) {
      (new porky.Db(DBNAME, TABLE))["delete"](key);
    }

    return Deleter;

  })();

  porky.register = function(fixture) {
    return new porky.Register(fixture);
  };

  porky.reregister = function(name) {
    return new porky.Reregister(name);
  };

  porky.run = function() {
    return new porky.Runner();
  };

  porky["delete"] = function(key) {
    return new porky.Deleter(key);
  };

}).call(this);
