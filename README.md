Newrelic-cloudwatch
===================

A simple [newrelic cloudwatch plugin](https://github.com/newrelic-platform/newrelic_aws_cloudwatch_plugin) docker container
This image is available for pulling from the [Docker hub](https://index.docker.io/u/gekkie/newrelic-cloudwatch/)

Launch this container with the following environment variables to suit your situation:

* NEWRELIC_KEY
* AWS_SECRET_KEY
* AWS_ACCESS_KEY

These will be used by the agent to connect to your AWS account.

### Why use this container?

This container has everything setup so you can easily run the monitoring agent without having to install everything by hand. It's not much, but still
Even though it isn't particularly difficult, it can be cumbersome. It also allows to contain all the dependencies inside the container and keep the host clean.

### IAM credentials for correct usage

In order to keep access to your AWS environment as manageable as possible it's advised to create a specific AWS/Newrelic IAM user with
specific read-only rights to your cloudformation information.

As mentioned by the plugin authors themselves:

* Create a new IAM user `NewRelicCloudWatch` (and save the credentials in a file for later reference)
* Create a new IAM group, `NewRelicCloudWatch`
* Create a custom policy for the group, `NewRelicCloudWatch`
* Use the following JSON for the policy document.

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "autoscaling:Describe*",
        "cloudwatch:Describe*",
        "cloudwatch:List*",
        "cloudwatch:Get*",
        "ec2:Describe*",
        "ec2:Get*",
        "ec2:ReportInstanceStatus",
        "elasticache:DescribeCacheClusters",
        "elasticloadbalancing:Describe*",
        "sqs:GetQueueAttributes",
        "sqs:ListQueues",
        "rds:DescribeDBInstances",
        "SNS:ListTopics"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
```
* Add the user to the `NewRelicCloudWatch` IAM group.

### Running this container

Running this container is as simple as running the following command:

    docker run -d \
	    -e NEWRELIC_KEY=123 \
        -e AWS_ACCESS_KEY=123123 \
        -e AWS_SECRET_KEY=123 \
        gekkie/newrelic-cloudwatch

