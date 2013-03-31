require 'rubygems'
require 'sinatra'
get('/') { open('public/index.html').read }
run Sinatra::Application
