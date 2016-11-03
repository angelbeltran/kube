'use strict'

// const Koa = require('koa')
const koa = require('koa')
const body = require('koa-better-body')
const route = require('koa-route')
const connected = require('./connect')
const Pet = require('./models').Pet


const app = koa()
const id = Math.ceil(10000 * Math.random())

console.log('Server id: %d', id)

// make request body available
app.use(body())

// make sure conneection to mongodb is complete before delegating requests
app.use(function *(next) {
  yield connected
  yield next
})

// serve various routes for db
app.use(route.post('/pet', function *() {
  console.log('/pet')
  console.log(this.request)
  let fields = this.request.fields
  console.log('fields:', fields)
  let newPet = new Pet(fields)
  try {
    yield newPet.save()
    this.body = fields
  } catch (err) {
    console.error(err)
    this.body = ''
  }
  this.status = 200
}))

app.use(route.get('/pet/:name', function *(name) {
  console.log('/pet/' + name)
  console.log(this.request)
  this.body = ''
  yield Pet.find({ name: name }, null, { lean: true }).then((docs) => {
    console.log('Pets found:', docs)
    this.body = docs[0] || {} // just get the first pet for now, until all the mongo db's are linked
  })
  console.log('this.body:', this.body)
  this.status = 200
}))

app.use(route.get('/hello', function *() {
  console.log('/hello')
  console.log('Incoming request: %j', this.request)
  this.body = 'Hello! This is server ' + id
  this.status = 200
}))

app.use(function *() {
  console.log('NO PATH HIT')
  this.body = 'WOOPS! No path hit'
  this.status = 200
})

app.listen(3000)
