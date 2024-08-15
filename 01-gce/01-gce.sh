###############################################################
###############################################################
# Creating a VM using the web console


# Navigate to Compute Engine -> VM Instances -> Create 

# Fill the form :

name : vm-instance-01, change the first letter to uppercase and show the error

Region : Select different regions and show the changes in the price
Show that the types of machines available are also different across regions

Zone : show all the other options and finally select "us-central1-a"
		
Machine Configuration :

Machine family : change to all the option and show how the price differ 
				finally select : " General-purpose "

Series : E2
Machine type : e2-micro 


boot disk : click on the "Change" -> nothing to change but show all the possible options and click on cancel 

Access scopes : select " Allow full access to all cloud APIs"

# Access scopes are the legacy method of specifying authorization for your VM instance. They define the default OAuth scopes used in requests from the gcloud CLI or the client libraries. Access scopes don't apply for calls made using gRPC.

# Access scopes apply on a per-VM basis and persists only for the life of the VM. You can set access scopes when creating a VM or update the access scope on an existing VM.

FireWall : Allow HTTP traffic

# Click on management, security, ..... show and click on else


# Click on compute engine pricing  -> view entire page

# Click on command line( to see the command line code) -> then click on create

# Show the instance created on the main VM instances page

# Now click on the instance which was created just now

# Click on Details and scroll down

# Click on Monitoring and scroll down


# Click on Disks and show that one persistent disk has been created


###############################################################
###############################################################
# Creating instances using the gcloud command line tool

# Here is the URL to install gcloud on local machine
# https://cloud.google.com/sdk/docs/install

# Open up Cloud Shell, make this full screen and open in a new tab

$ gcloud config set project plucky-respect-310804

$ gcloud compute instances list


# Create a new instance - notice that this new instance is in a different region


$ gcloud compute instances create vm-instance-02 \
--project=plucky-respect-310804 \
--zone=europe-north1-a \
--machine-type=f1-micro \
--image=debian-12-bookworm-v20240709 \
--image-project=debian-cloud \
--boot-disk-size=10GB \
--maintenance-policy=TERMINATE \
--no-restart-on-failure

# Go to the VM instances page and show that this has been created

# Click on vm-instance-02 and show the details of the instance

# Check the Availability Policies

On host maintenance: Terminate VM instance
Automatic restart: Off

# Note how the external IP address specified looks different (because we have not enabled this instance to receive HTTP/HTTP traffic)


#################################################
######## Communicating between VMs

# SSH into vm-instance-01

$ ping vm-instance-02

$ ping <external IP of vm-instance-02>

$ ping <internal IP of vm-instance-02>

# Both will work

# From the terminal window of the local machine or from Cloud Shell

$ ping <external IP of vm-instance-02>

$ ping <internal IP of vm-instance-02>

# External IP will work, internal IP will not work



































