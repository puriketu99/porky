window.destroy = 
  name:"destroy test"
  func:"remarriagea"
  arg:["destroyer","darth vader"]
  delay:1000
  json_paths:['window.eric']

window.normal = 
  name:"normal test"
  func:"change"
  delay:1000

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
      #window.eric.family.me = window.eric

window.remarriagea  = (name,company)-> 
  eric.name = name
  eric.company = company
  eric

window.change = ->
  $("#tryit").html("Done")
