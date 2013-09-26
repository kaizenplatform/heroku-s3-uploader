require 'rubygems'
require 'sinatra'
require 'sinatra/json'
require 'aws/s3'
require 'dotenv'

Dotenv.load
UPLOAD_DIR='uploads/'

before do
  content_type 'application/json'
  headers 'Access-Control-Allow-Origin'  => '*'
  headers 'Access-Control-Allow-Headers' => 'Authorization,Accepts,Content-Type,X-CSRF-Token,X-Requested-With,Cache-Control'
  headers 'Access-Control-Allow-Methods' => 'POST'
  halt 200 if request.request_method == 'OPTIONS'
end

get '/' do
  json message: 'It works'
end

post '/' do
  bucket   = ENV['AMAZON_S3_BUCKET']
  endpoint = ENV['AMAZON_S3_ENDPOINT']
  file     = params[:file][:tempfile]
  filename = params[:file][:filename]
  data     = open(file.path)
  begin
    AWS::S3::DEFAULT_HOST.replace endpoint
    AWS::S3::Base.establish_connection!(
      access_key_id:     ENV['AMAZON_ACCESS_KEY_ID'],
      secret_access_key: ENV['AMAZON_SECRET_ACCESS_KEY']
    )
    AWS::S3::S3Object.store "#{UPLOAD_DIR}#{filename}", data, bucket, access: :public_read
  rescue Exception => e
    return json error: e
  end
  url = "https://#{bucket}.s3.amazonaws.com/#{UPLOAD_DIR}#{filename}"
  json url: url
end

post '/json' do
  json params:  params, post_id: rand(1000), mode: params[:post] && params[:post][:id] ? "update" : "create"
end

