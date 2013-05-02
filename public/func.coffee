window.destroy = 
  name:"destroy test"
  func:"remarriagea"
  arg:["destroyer","darth vader"]
  json_paths:['window.eric']

window.normal = 
  name:"normal test"
  func:"change"

window.eric = 
  name:"eric"
  company:"google"
  intro:->
  family:
    father:
      name:'mark'
      comapny:'facebook'
    mother:
      name:'mary'
      company:'horizon'

window.remarriagea  = (name,father)-> 
  eric.name = name
  eric.company = father
  #eric.family.father.name = father

window.change = ->
  $("#tryit").html("Done")
