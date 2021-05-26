# LIBRARIES #
 
import urllib3
import boto3
 
# GLOBAL VARIABLES #
 
ss_dev = ''
region = ''
instance_list = ['']
 
success = 0
error = 1

http = urllib3.PoolManager()

def make_request(url):
    try:
        r = http.request('GET', 'https://' + url + '/', timeout=2.5)
        http_status = r.status
        print(http_status)
        print(success)
        return success
    except:
        print(error)
        return error
 
def check_request():
    check = make_request(ss_dev)
    if check == success:
        print(ss_dev + " is up and running!")
        return True
    else:
        print(ss_dev + " is down!")
        return False
 
def reboot_instance():
    if check_request() != True:
        print('Rebooting ' + ss_dev + ' instance...')
        ec2 = boto3.client('ec2', region_name=region)
        ec2.reboot_instances(InstanceIds=instance_list)
    else:
        print('Exiting function...')
 
def lambda_handler(event, context):
    
    # MAIN FUNCTION
    
    reboot_instance()