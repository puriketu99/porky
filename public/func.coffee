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
window.eric.family.me = window.eric

window.remarriagea  = (name,company)-> 
  eric.name = name
  eric.company = company

window.change = ->
  $("#tryit").html("Done")
