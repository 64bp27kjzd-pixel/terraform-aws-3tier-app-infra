#!/bin/bash
set -euo pipefail

dnf update -y
dnf install -y httpd amazon-cloudwatch-agent
dnf install mariadb105 -y

systemctl enable httpd
systemctl start httpd

cat <<EOF > /var/www/html/index.html
<h1>Hello from $(hostname)</h1>
EOF

cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/dnf.log",
            "log_group_name": "/${env}/ec2/dnf",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/httpd/access_log",
            "log_group_name": "/${env}/ec2/httpd/access",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/httpd/error_log",
            "log_group_name": "/${env}/ec2/httpd/error",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF

systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent