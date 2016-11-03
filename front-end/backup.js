'use strict'

const Koa = require('koa')
const body = require('koa-better-body')
const request = require('superagent')


const app = new Koa()
const id = Math.ceil(10000 * Math.random())

app
  .use(body())
  .use((ctx, next) => {
    console.log('Incoming request:', ctx)
    console.log('Forwarding request to back-end:3000')
    return request
      .get('back-end:3000')
      .then((res) => {
        console.log('Back end responded!')
        ctx.body = ctx.request.body || ''
        if (ctx.body) {
          ctx.body += '\n'
        }
        ctx.body += 'This was served through proxy ' + id
        ctx.status = 200
      }, (err) => {
        console.log('Error in forwarding request: %j', err)
        ctx.body = 'No Bueno ' + id
        ctx.status = 200
      })
  })


console.log('Koa app listening on port localhost:3000')
app.listen(3000)
