FROM node

WORKDIR /home

CMD ["node", "."]

RUN npm install --save koa
RUN npm install --save koa-better-body
RUN npm install --save koa-route
RUN npm install --save mongoose

COPY index.js /home/index.js
COPY models.js /home/models.js
COPY connect.js /home/connect.js

