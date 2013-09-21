heroku-s3-uploader
==================

Simple Sinatra app to upload files to Amazon S3

```bash
heroku config:set \
  AMAZON_S3_BUCKET=mybucket \
  AMAZON_ACCESS_KEY_ID=XXXXXXXXXX \
  AMAZON_SECRET_ACCESS_KEY=YYYYYYYYYY \
  AMAZON_S3_ENDPOINT=s3-ap-northeast-1.amazonaws.com
```
