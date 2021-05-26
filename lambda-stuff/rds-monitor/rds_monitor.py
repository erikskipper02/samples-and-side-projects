import sys
import botocore
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
   rds = boto3.client('rds')
   db_instances = ['']
   for i in db_instances:
      try:
         print('Stopping the following RDS DB: ' + i)
         response = rds.stop_db_instance(DBInstanceIdentifier=i)
         print('Done!')
      except ClientError as e:
         print(e)