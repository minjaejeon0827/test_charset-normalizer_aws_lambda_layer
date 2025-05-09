# TODO : Python 3.11 환경용으로 패키지 "charset-normalizer"를 아마존 웹서비스(AWS) 람다 함수(Lambda Function) 계층(Layer) 생성하기 위해 Dockerfile 구현 (2025.05.09 minjae)
# 참고 URL - https://chatgpt.com/c/681d2707-803c-8010-9391-4cac3ee29d1a

# 패키지 "charset-normalizer"
# 참고 URL - https://pypi.org/project/charset-normalizer/
# 참고 2 URL - https://wikidocs.net/235932
# 참고 3 URL - https://www.piwheels.org/project/charset-normalizer/
# 참고 4 URL - https://stackoverflow.com/questions/77790767/runtime-importmoduleerror-unable-to-import-module-main-cannot-import-name-i
# 참고 5 URL - https://repost.aws/questions/QU-Tmic1RVRnehTle9GneaRA/unable-to-import-module-lambda-function-no-module-named-charset-normalizer

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

# TODO : Docker 명령어 실행시 아래와 같은 오류 메시지 출력되어 아래 Docker 명령어 실행하여 Docker 캐시 삭제 (이미지 재다운로드) 처리함. (2025.05.09 minjae)
# docker builder prune --all --force
# docker image prune --all --force
# 오류 메시지
# ERROR: failed to solve: failed to prepare extraction snapshot ...
# parent snapshot ... does not exist: not found
# 오류 원인
# 이 에러는 Docker 이미지 레이어 캐시가 깨졌거나 손상된 경우에 발생할 수 있습니다. 종종 다음과 같은 상황에서 발생합니다:
# 이전에 pull한 이미지가 불완전하게 저장되었음
# Docker 내부 캐시가 꼬였음

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