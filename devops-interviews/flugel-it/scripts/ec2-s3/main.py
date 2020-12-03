import json
import sys
import boto3

# Move to settings file
# tags = [{'InUse':'Yes'}]

region =  'us-east-1'

def get_unused_ec2(tags):
    # EC2
    ec2 = boto3.resource('ec2',region)
    ec2Client = boto3.client('ec2',region)

    allowedInstances = {}
    for reservation in ec2Client.describe_instances()["Reservations"]:
        for instance in reservation['Instances']:
            tags_ec2 = instance["Tags"]

            for tag in tags_ec2:
                for t in tags:
                    for key, value in t.items():
                        if (tag['Key'] == key and tag['Value'] == value):
                            allowedInstances[instance['InstanceId']] = False
                            break

                        else:
                            if (instance['InstanceId'] in allowedInstances):
                                break
                            allowedInstances[instance['InstanceId']] = True

    return list(map(lambda x: x[0], (filter(lambda k: k[1] == True,allowedInstances.items()))))

def get_unused_s3(tags):
    s3 = boto3.resource('s3', region)
    s3Client = boto3.client('s3', region)

    buckets = list(s3.buckets.all())

    allowedBuckets = {}

    for b in buckets:
        try:
            tags_bucket = s3Client.get_bucket_tagging(Bucket=b.name)['TagSet']

            for tag in tags_bucket:
                for t in tags:
                    for key, value in t.items():
                        if (tag['Key'] == key and tag['Value'] == value):

                            allowedBuckets[b.name] = False
                            break

                        else:
                            if (b.name in allowedBuckets):
                                break
                            allowedBuckets[b.name] = True

        except:
            # TODO: Improve error handling here, right now it's swallowing all the exceptions, it should only catch
            # exceptions of type botocore.exceptions.ClientError
            allowedBuckets[b.name] = True
    return list(map(lambda x: x[0], (filter(lambda k: k[1] == True,allowedBuckets.items()))))

if __name__ == "__main__":
    userInput = json.loads(sys.argv[1])
    print('Unused Resources based on tags: ' + str(userInput) +' | Region: ' + region)
    print('  S3 buckets:')
    print(get_unused_s3(userInput))
    print('  EC2 instances:')
    print(get_unused_ec2(userInput))

# - [x] As a developer, I want a tool to list unused AWS resources to save costs. The tool input is a list of tags and it returns the list of EC2 instances and S3 buckets that don't match any of the tags in the N. Virginia region.
# - [x] Implement some automatic tests to verify that the tool works as expected. Use Terraform to create resources to validate the tool works as expected.
# - [x] Package the application as a Docker image, so the user doesn't have to install python and other packages locally.
# - [x] Publish your code in a public GitHub repository, and share a Pull Request with your code. Do not merge into master until the PR is approved.
# - [x] Include documentation describing the steps to run and test the automation.