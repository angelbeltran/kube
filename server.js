'use strict'

// TODO: remove unneeded dependencies
const koa = require('koa')
const proxy = require('koa-proxy')


const app = koa()

app.use(proxy({
  host: 'http://192.168.99.100:30001/'
}))

console.log('Koa server listening on localhost:3000')
app.listen(3000)
