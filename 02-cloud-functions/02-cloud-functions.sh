#################################
# Cloud Functions
#################################

# These APIs are already enabled on my account

# From the navigation menu go to "APIs & Services" -> Dashboard -> Enable API & Services

# In search write "Cloud Function" and enable the Cloud Function API 

# In search write "Cloud Build" and enable the Cloud Build API

# From the side navigation go to "Cloud Functions" and click on it


########################################################
########################################################
### Triggering Cloud Functions with Storage Events

# Create a bucket

# Click on the hamburger menu and go to "Storage" -> "Bucket" -> "Create Bucket"

name: loony-cf-src-bucket

# Expand the options and quickly explain

# Keep everything as it is and click on "Create"

# https://unsplash.com/photos/an-aerial-view-of-a-city-with-tall-buildings-D4Og4wYSArQ

# Upload buildings.jpg to the bucket

# Note the size of the image

# Click through and show the image

# Create the destination bucket

name: loony-cf-dest-bucket

# Keep everything as it is and click on "Create"

# Keep the buckets open in one tab

---------------

# Go back to cloud functions > Create Function

enviroment : gen 2
function name : resize-image
Region : we will use the default one
Trigger : Cloud storage
Event type : google.cloud.storage.object.v1.finalized
Bucket : loony-cf-src-bucket

# If asking for permissions, Grant All Permissions

# Click on "Next"

# Choose the Python 3.12 runtime and change the main.py to the following:

# Now change the main.py to the following:

# main.py
import functions_framework
from google.cloud import storage
from PIL import Image
import io

storage_client = storage.Client()
dest_bucket_name = "loony-cf-dest-bucket"

@functions_framework.cloud_event
def resize_image(cloud_event):
    data = cloud_event.data
    
    bucket_name = data["bucket"]
    file_name = data["name"]
    
    print(f"Bucket: {bucket_name}")
    print(f"File: {file_name}")

    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    file_contents = blob.download_as_bytes()
    print(f"Downloaded file: {file_name}")

    image = Image.open(io.BytesIO(file_contents))
    resized_image = image.resize((256, 256))
    buffer = io.BytesIO()
    resized_image.save(buffer, format=image.format)
    buffer.seek(0)

    dest_bucket = storage_client.bucket(dest_bucket_name)
    new_file_name = "resized_" + file_name
    dest_blob = dest_bucket.blob(new_file_name)
    dest_blob.upload_from_file(buffer)
    print(f"Uploaded resized image as '{new_file_name}' to destination bucket: {dest_bucket_name}")


entry_point: resize_image

# requirements.txt
functions-framework==3.*
google-cloud-storage
Pillow

# In Cloud Function "Deploy" the function


# Trigger Event
{
  "data": {
    "name": "buildings.jpg",
    "bucket": "loony-cf-src-bucket"
  },
  "type": "google.cloud.storage.object.v1.finalized",
  "specversion": "1.0",
  "source": "//pubsub.googleapis.com/",
  "id": "1234567890"
}

Click "Run Test"
# Observe the logs

# Go back to the dest bucket and download the resized_buildings.jpg

# Observe the image resolution is 256x256


# https://unsplash.com/photos/a-close-up-of-a-flower-on-a-tree-branch-q2_FIOXIPq8

# Now upload "flowers.jpg" to the bucket (Observe it is a huge image)

# In Cloud Function "Logs" and observe the recent logs

# Show resized_flowers.jpg

