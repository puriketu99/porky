window.destroy_test = 
  name:"destroy test"
  func:"destroy"
  arg:["destroyer","darth vader"]
  #  json_paths:['window.eric']

window.normal = 
  name:"normal test"
  func:"change"

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
      #window.eric.self = window.eric

window.destroy = (name,father)-> 
  eric.name = name
  eric.family.father.name = father

window.change = ->
  $("#tryit").html("Done")
