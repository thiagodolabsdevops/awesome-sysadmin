import boto3
from moto import mock_ec2
from moto import mock_s3
 
import main
 
region = 'us-east-1'
 
@mock_ec2
def test_get_ununsed_ec2():
    client = boto3.client('ec2', region)
    in_use_creation_result = client.run_instances(
        ImageId='ami-1e749f67',
        InstanceType='t2.small',
        KeyName='Flugel1',
        MaxCount=1,
        MinCount=1,
        TagSpecifications=[
            {
                'ResourceType': 'instance',
                'Tags': [
                    {
                        'Key': 'Name',
                        'Value': 'Flugel1',
                    },
                    {
                        'Key': 'InUse',
                        'Value': 'Yes',
                    },
                ]
            },
        ],
    )

    not_used_creation_result = client.run_instances(
        ImageId='ami-1e749f67',
        InstanceType='t2.small',
        KeyName='Flugel2',
        MaxCount=1,
        MinCount=1,
        TagSpecifications=[
            {
                'ResourceType': 'instance',
                'Tags': [
                    {
                        'Key': 'Name',
                        'Value': 'Flugel2',
                    },
                    {
                        'Key': 'InUse',
                        'Value': 'No',
                    },
                ]
            },
        ],
    )
    in_use_id = in_use_creation_result['Instances'][0].get('InstanceId')
    not_used_id = not_used_creation_result['Instances'][0].get('InstanceId')
 
    assert main.get_unused_ec2([{"InUse": "No"}]) == [in_use_id]
    assert main.get_unused_ec2([{"InUse": "Yes"}]) == [not_used_id]

@mock_s3
def test_get_ununsed_s3():
 
    bucket_in_use = 'flugel-bucket1'
    bucket_not_in_use = 'flugel-bucket2'
 
    client = boto3.client('s3')
 
    client.create_bucket(Bucket=bucket_in_use)
    client.create_bucket(Bucket=bucket_not_in_use)
 
    client.put_bucket_tagging(
        Bucket=bucket_in_use,
        Tagging={
            'TagSet': [
                {
                    'Key': 'InUse',
                    'Value': 'Yes'
                },
            ]
        }
    )
 
    client.put_bucket_tagging(
        Bucket=bucket_not_in_use,
        Tagging={
            'TagSet': [
                {
                    'Key': 'InUse',
                    'Value': 'No'
                },
            ]
        }
    )
 
    assert main.get_unused_s3([{"InUse": "No"}]) == [bucket_in_use]
    assert main.get_unused_s3([{"InUse": "Yes"}]) == [bucket_not_in_use]