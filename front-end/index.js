'use strict'

// const Koa = require('koa')
const koa = require('koa')
const body = require('koa-better-body')
const koaStatic = require('koa-static')
const route = require('koa-route')
const request = require('superagent') // TODO: add superagent to docker file
const path = require('path')
const fs = require('fs')


// const app = new Koa()
const app = koa()
const id = Math.ceil(10000 * Math.random())

console.log('Server id: %d', id)

// set up the id of the server on the webpage
fs.writeFileSync('public/index.html', fs.readFileSync('public/template.html').toString().replace('{id}', id))

// provide the backend endpoints
app.use(body())

app.use(route.get('/hello', function *() {
  yield request
    .get('back-end:3000/hello')
    .then((res) => {
      console.log('Response from backend: res.text:', res.text)
      this.body = res.text
      this.status = 200
    }, (err) => {
      console.log('Error in forwarding request: %j', err)
      this.body = 'No bueno!'
      this.status = 200
    })
}))

app.use(route.post('/pet', function *() {
  // console.log('Request to /pet:', this.request)

  let fields = [
    'json',
    'text',
    'buffer',
    'multipart',
    'fields'
  ]

  console.log('logging field values')
  fields.forEach((field) => {
    console.log('field:', field)
    console.log(this.request[field])
  })
  // console.log('Request keys:', Object.keys(this.request))
  yield request
    .post('back-end:3000/pet')
    .send(this.request.fields)
    .then((res) => {
      console.log('Response:', res)
      // console.log('Response from backend: res.text:', res.text)
      // console.log('Response from backend: res.body:', res.body)
      this.body = res.text
      this.status = 200
    }, (err) => {
      console.log('Error in forwarding request: %j', err)
      this.body = 'No bueno!'
      this.status = 200
    })
}))

app.use(route.get('/pet/:name', function *(name) {
    yield request
      .get('back-end:3000/pet/' + name)
      .then((res) => {
        console.log('Response from backend: res.text:', res.text)
        console.log('Response from backend: res.body:', res.body)

        this.body = res.body
        this.status = 200
      }, (err) => {
        console.log('Error in forwarding request: %j', err)
        this.body = null
        this.status = 200
      })
}))

// serve the webapp
app
  .use(body())
  .use(koaStatic(path.resolve(__dirname, 'public')))


console.log('Koa app listening on port localhost:3000')
app.listen(3000)
