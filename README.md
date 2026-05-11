# terraform-aws-3tier-app-infra

TerraformでAWS上に3層構成（Web/AP/DB）をモジュール化して構築したインフラ構成です。

## 構成
- Web層：ALB
- AP層：EC2（Auto Scaling Group）
- DB層：RDS

## 環境
- dev / prod の2環境に対応
- tfstateはS3 + DynamoDBで管理

## 関連記事
- [第1回：全体設計・モジュール構成編]