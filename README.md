# 로봇플러스 협업지능 챌린지 2024용 ROS CUDA Docker
>  협업지능 챌린지 2024용 ROS 도커 이미지 생성을 위한 레포지토리

## 1. 도커파일 기본 구성 환경
<img src="images/ubt.jpg" alt="ubuntu" width="200px" style="margin-right: 50px;"/> <img src="images/cuda.jpg" alt="cuda" width="200px" style="margin-right: 50px;"/> <img src="images/ros.png" alt="ROS_Noetic" width="200px"/>

- Ubuntu 20.04 Focal
- Nvidia CUDA 11.3.1
- ROS1 Noetic
- OpenSSH
- Add New User
- Add Useful ROS, catkin Setup to bashrc
<br>
<br>

## 2. 도커파일 생성시 사용되는 Arguments
- UBUNTU_RELEASE: 가져올 Ubuntu OS의 버전
    + 기본값: 20.04

- CUDA_VERSION: 가져올 Nvidia CUDA 이미지의 버전
    + 기본값: 11.3.1

- CUDA_ENV_VERSION: 환경변수 설정에 사용할 Nvidia CUDA 버전
    + 기본값: 11.3

- CUDA_PURPOSE: 가져올 Nvidia CUDA 이미지의 배포 종류(devel, runtime)
    + 기본값: "devel"

- CUDNN_VERSION: 추가적으로 넣을 CuDNN 여부 및 버전
    + 기본값: "" (빈 값은 CuDNN 넣지 않음)
    + CuDNN 추가할 경우의 값: cudnn8-

- ROS_VER: 설치할 ROS의 버전
    + 기본값: noetic

- USER_NAME: 사용할 도커의 유저 이름
    + 기본값: ros

- PASSWORD: 사용할 도커의 유저의 비밀번호
    + 기본값: keti
<br>
<br>

## 3. 챌린지용 ROS CUDA 도커파일 Portainer 사용 방법
### 1). 도커 이미지 생성
- 협업지능 챌린지 2024용 Portainer 웹페이지 접속
    > 접속주소: https://robotplus.duckdns.org:9443

- 본인이 신청한 아이디와 비밀번호로 로그인
    - <img src="images/login.png" alt="portainer_login" width="500px" />
<br>

- Environments에 challenge-2024 오른쪽의 [Live Connect] 선택
    - <img src="images/home.png" alt="portainer_home" width="500px"/>
<br>

- 자신의 도커 이미지를 빌드하여 생성하기 위해 왼쪽 메뉴의 images 선택
    - <img src="images/dash.png" alt="portainer_dash" width="500px"/>
<br>

- Image List의 오른쪽 하단 [Build a new image] 선택
    - <img src="images/build.png" alt="portainer_build" width="500px"/>
<br>

- 현재 로봇플러스 협업지능 챌린지 Github Repository의 Dockerfile 안에 작성된 내용을 Web editor에 붙여넣기
    - <img src="images/editor.png" alt="portainer_editor" width="500px"/>
<br>

- Dockerfile에 정의된 ARG 변수들 값을 위의 [Arguments](#2-도커파일-생성시-사용되는-arguments) 정보를 참조하여 수정 후 Actions의 [Build the image] 선택
    - <img src="images/docker_build.png" alt="portainer_docker_build" width="500px"/>
<br>

- 도커 이미지 생성 완료 후 로그 화면 출력됨
    - <img src="images/build_complete.png" alt="portainer_build_complete" width="500px"/>
<br>

- 왼쪽 Images 메뉴로 들어가 생성된 도커 이미지 확인
    - <img src="images/check_image.png" alt="portainer_check_image" width="500px"/>

<br>
<br>

### 2). 도커 컨테이너 생성
- 왼쪽 Stacks 메뉴로 들어가 [Add stack] 선택
    - <img src="images/stack.png" alt="portainer_stack" width="500px"/>
<br>

- Name 항목에 stack 이름 설정 및 Web Editor에 아래 내용을 붙여넣고, 수정한 후 Actions의 [Deploy the stack]로 Stack 실행
    ```yaml
    version: "3.8"

    services:
      my-ros-noetic-cuda:
        image: my-challenge-2024-ros:cuda
        ports:
          - "4000:22"
        deploy:
          resources:
            limits:
              cpus: '4.0'
              memory: 4000M
            reservations:
              cpus: '2.0'
              memory: 2000M
              devices:
                - driver: nvidia
                  count: 1
                  capabilities: [gpu]
          restart_policy:
            condition: on-failure
    ```
  + services 밑에 사용하기 원하는 서비스 이름 작성
  + image: 자신의 도커 이미지 이름 및 태그 작성
  + ports: 자신이 부여받은 도커 컨테이너 SSH 접속에 사용할 포트번호 작성
  + <img src="images/create_stack.png" alt="portainer_create_stack" width="500px"/>
<br>

- 생성 및 실행된 Stack 선택
    - <img src="images/my_stack.png" alt="portainer_my_stack" width="500px"/>
<br>

- Stack에서 생성한 컨테이너가 정상 작동 중인지 확인
    - <img src="images/check_stack.png" alt="portainer_check_stack" width="500px"/>
<br>

### 3). 도커 컨테이너 접속 테스트
- Portainer를 사용한 접속
    - 왼쪽 Containers 메뉴 선택 후 자신의 컨테이너에서 Quick Actions의 [Exec Console] 선택
        - <img src="images/container_exec.png" alt="portainer_container_exec" width="500px"/>
        <br>
    - User 항목에 자신의 User Name 작성 후 [Connect] 연결
        - <img src="images/console_connect.png" alt="portainer_console_connect" width="500px"/>
        <br>
    - 생성된 컨테이너 콘솔 접속 확인
        - <img src="images/check_console.png" alt="portainer_check_console" width="500px"/>
        <br>

- 터미널 사용한 접속
  - SSH를 통해 생성한 도커 컨테이너 연결(포트번호는 부여된 번호로 설정)
      ```bash
      ssh ros@robotplus.duckdns.org -p 4000
      ```
      - <img src="images/terminal_ssh.png" alt="portainer_terminal_ssh" width="500px"/>
    <br>

## 4. 개인용 ROS CUDA 도커파일 사용 방법
### 1). 도커파일 빌드 방법
- git 레포지토리 클론
    ```bash
    git clone https://github.com/robot-plus-program/robotplus-challenge-2024-ros.git
    ```

- 레포지토리로 이동
    ```bash
    cd robotplus-challenge-2024-ros
    ```

- 터미널에서 CLI로 도커 이미지 빌드

    ```bash
    docker build -t robotplus-challenge-2024-ros-cuda:base . \
            --build-arg UBNUTU_RELEASE=20.04 \
            --build-arg CUDA_VERSION=11.3.1 \
            --build-arg CUDA_ENV_VERSION=11.3 \
            --build-arg CUDA_PURPOSE=devel \
            --build-arg CUDNN_VERSION="" \
            --build-arg ROS_VER=noetic \
            --build-arg USER_NAME=ros \
            --build-arg PASSWORD=keti
    ```

- 또는 build.bash 파일 사용
    + 파일 안에 환경변수 값 수정하여 사용
    ```bash
    chmod 755 build.bash && bash build.bash
    ```
<br>
<br>

### 2). 도커파일 실행 방법 
- 터미널에 입력
    + -p 에는 SSH 접속에 사용할 포트번호 입력(예:4000)
    ```bash
    docker run -d --gpus all -p 4000:22 robotplus-challenge-2024-ros-cuda:base
    ```

- 또는 run.bash 파일 사용
    + 파일 안에 ssh_port_num의 값 수정하여 사용(예:ssh_port_num=4000)
    ```bash
    chmod 755 run.bash && bash run.bash
    ```
<br>
<br>

### 3). 도커 컨테이너 SSH 접속 방법 
- 터미널에 입력
    + 도커 실행할때 사용한 SSH 포트번호와 USER_NAME, PASSWORD를 사용

    ```bash
    ssh ros@robotplus.duckdns.org -p 4000
    ```
