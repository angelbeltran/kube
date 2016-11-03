FROM node

WORKDIR /home

CMD ["node", "."]

RUN npm install --save koa
RUN npm install --save koa-better-body
RUN npm install --save koa-static
RUN npm install --save koa-route
RUN npm install --save superagent

COPY index.js /home/index.js
RUN mkdir /home/public
COPY public/template.html /home/public/template.html
COPY public/build/app.js /home/public/build/app.js
