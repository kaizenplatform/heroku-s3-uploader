require 'rubygems'
require 'sinatra'
require 'sinatra/json'
require 'aws/s3'
require 'dotenv'

Dotenv.load
UPLOAD_DIR='uploads/'

before do
  content_type 'application/json'
end

get '/' do
  json message: 'It works'
end

post '/' do
  headers 'Access-Control-Allow-Origin'  => '*'
  headers 'Access-Control-Allow-Headers' => 'Authorization,Accepts,Content-Type,X-CSRF-Token,X-Requested-With'
  headers 'Access-Control-Allow-Methods' => 'GET,POST,PUT,DELETE,OPTIONS'
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

