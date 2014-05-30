require 'sinatra'
require 'pry'
require 'shotgun'
require 'pg'


def find_articles
  connection = PG.connect(dbname: 'slacker_news')
  results = connection.exec('SELECT * FROM articles')
  connection.close

  results
end


def save_article(title, description, url)
  sql = "INSERT INTO articles (title, description, url) " +
  "VALUES ($1, $2, $3)"

  connection = PG.connect(dbname: 'slacker_news')
  results = connection.exec_params(sql, [title, description, url])
  connection.close
end

get '/articles' do
  @articles = find_articles
  erb :'index.html'
end

get '/articles/new' do

  erb :'new.html'
end

post '/articles/new' do

  #save new info to database
  save_article(params["title"], params["description"], params["url"])

  redirect '/articles'
end
