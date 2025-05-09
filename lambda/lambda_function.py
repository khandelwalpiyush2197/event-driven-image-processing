import boto3
import os
from PIL import Image
import io

s3 = boto3.client('s3')
dest_bucket = os.environ['DEST_BUCKET']

def lambda_handler(event, context):
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # Download image from source bucket
    response = s3.get_object(Bucket=source_bucket, Key=key)
    image = Image.open(io.BytesIO(response['Body'].read()))

    # Resize image
    image = image.resize((128, 128))

    # Save to in-memory file
    out_image = io.BytesIO()
    image.save(out_image, format='PNG')
    out_image.seek(0)

    # Upload to destination bucket
    s3.put_object(Bucket=dest_bucket, Key=f"processed/{key}", Body=out_image)

    return {
        'statusCode': 200,
        'body': f'Processed image uploaded to {dest_bucket}/processed/{key}'
    }
