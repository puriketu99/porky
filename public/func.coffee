window.append = ()->
  $("#tests").append("test case1")

window.ajax = ()->
  $.ajax({url:'sample.json'}).done(
    (items)->
      for item in items
        $("#tests").append(JSON.stringify(item))
  )
window.destroy = (name,father)-> 
  eric.name = name
  eric.family.father.name = father

window.append_test =
  name:"append test"
  func:"append"

window.ajax_test = 
  name:"ajax test"
  func:"ajax"
  is_ajax:true

window.destroy_test = 
  name:"destroy test"
  func:"destroy"
  arg:["destroyer","darth vader"]
  json_paths:['window.eric']

window.eric = 
  name:"eric"
  company:"google"
  intro:()->console.log this.name
  family:
    father:
      name:'mark'
      comapny:'facebook'
      intro:()->console.log this.name
    mother:
      name:'mary'
      company:'horizon'
window.change = ->
  $("#tryit").html("Done")

