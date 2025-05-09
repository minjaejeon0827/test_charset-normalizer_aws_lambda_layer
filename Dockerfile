# TODO : Python 3.11 환경용으로 패키지 "charset-normalizer"를 아마존 웹서비스(AWS) 람다 함수(Lambda Function) 계층(Layer) 생성하기 위해 Dockerfile 구현 (2025.05.09 minjae)
# 참고 URL - https://chatgpt.com/c/681d2707-803c-8010-9391-4cac3ee29d1a

# 아마존 웹서비스(AWS) 람다 함수(Lambda Function) 계층(Layer) 전용
# layer.zip 파일 만드는 순서 
# 1) Docker Desktop 응용 프로그램 실행 
# 2) 비쥬얼스튜디오코드(VSCode) 실행 -> 터미널창 생성 -> 아래 명령어 입력 및 엔터 
# docker build -t lambda-layer-builder .
# 3) 2)번 명령어 실행 후 -> 터미널창에 아래 명령어 입력 및 엔터 
# docker create --name temp-container lambda-layer-builder
# 4) 3)번 명령어 실행 후 -> 터미널창에 아래 명령어 입력 및 엔터 
# docker cp temp-container:/build/layer.zip .
# 5) 4)번 명령어 실행 후 -> 터미널창에 아래 명령어 입력 및 엔터 
# docker rm temp-container

FROM public.ecr.aws/lambda/python:3.11 AS build

# 작업 디렉토리 설정
WORKDIR /build

# zip 설치 + pip 패키지 설치
# 명령어 "yum install -y zip" 의미: Amazon Linux 기반 Lambda 이미지에서 zip 설치
RUN yum install -y zip && \
    pip install --upgrade pip && \
    pip install charset-normalizer -t python/

# zip 파일 생성
RUN zip -r layer.zip python/