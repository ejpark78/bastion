

# 엔드포인트를 MiniStack으로 고정하기 위한 별칭(Alias) 설정 (편의용)
alias aws-local='aws --endpoint-url=http://localhost:4566'

# 기본 설정 (이미 되어 있다면 생략 가능)
# ID/Key는 'test'로 입력하면 됩니다.
aws configure set aws_access_key_id test
aws configure set aws_secret_access_key test
aws configure set region us-east-1




# 실행 파일 이름을 'aws'로 명시하여 다시 등록
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

alias aws-local='uvx --from awscli aws --endpoint-url=http://localhost:4566 --region us-east-1'

# 이제 다시 테스트
aws-local ec2 describe-instances


# 1. 인스턴스 목록 확인 (빈 리스트가 나오면 정상)
aws-local ec2 describe-instances

# 2. 테스트용 키 페어 생성
aws-local ec2 create-key-pair --key-name my-local-key

# 2. 가상 인스턴스 생성 테스트
aws-local ec2 run-instances --image-id ami-12345678 --instance-type t2.micro

# 3. 생성된 인스턴스 다시 확인
aws-local ec2 describe-instances --query "Reservations[*].Instances[*].InstanceId"

