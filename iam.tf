resource "aws_iam_role" "ecs_autoscale_role" {
  name               = "${var.project}-${var.environment}-ecs-autoscale-role"
  assume_role_policy = "${file("${path.module}/templates/autoscale-assume-role.json")}"
}

resource "aws_iam_policy" "ecs_autoscale_policy" {
    name        = "${var.project}-${var.environment}-ecs-autoscale-policy"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:DescribeServices",
                "ecs:UpdateService"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DescribeAlarms"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-autoscale-role-attach" {
    role       = "${aws_iam_role.ecs_autoscale_role.name}"
    policy_arn = "${aws_iam_policy.ecs_autoscale_policy.arn}"
}
