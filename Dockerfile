FROM node:alpine as builder

WORKDIR '/app'
# copy当前目录下的package。json到workdir下
COPY package.json . 

RUN npm install

COPY . .
RUN npm run build

#这个dockerfile这样两步的build step就是为了优化。上一步的（npm install？）会产生很多文件，但是实际runtime的时候我们只需要它产生出来的build目录下的东西就
#行了，而且现在我即要用alpine的image和nginx的image，所以可以这样结合
#FROM关键之就是分隔了上下部分作为隔离的步骤,是sequential的
FROM nginx
EXPOSE 80 
#复制 from /app/build 到 usr。。。
COPY --from=builder /app/build /usr/share/nginx/html
#nginx 有默认的start命令所以这里不用写start
