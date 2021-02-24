# 베이스 파일을 명시 FROM ~ FROM 까지 builder stage
FROM node:alpine as builder

#Create App Directory
WORKDIR /usr/src/app

#종속성을 매번 인스톨 하지 않기 위해
COPY package.json ./

# 추가적으로 필요한 파일을 다운로드
RUN npm install

# 소스코드가 컨테이너 외부에 있으므로 Local -> Docker Container 복사
COPY ./ ./

# 컨테이너 시작시 실행될 명령어를 명시
CMD ["npm", "run", "build"]

# nginx가 Client 요청에 따라 알맞은 정적 파일 제공을 위해 Build 데이터 -> nginx로 복사
FROM nginx
EXPOSE 80
COPY --from=builder /usr/src/app/build /usr/share/nginx/html

