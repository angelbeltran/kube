'use strict'

const mongoose = require('mongoose')


function connectToMongoDB (url, tries, wait, delay) {
  tries = tries || 0
  wait = wait || 15000
  delay = delay || 5000

  if (tries) {
    return new Promise((resolve, reject) => {
      mongoose.connect(url)
      mongoose.connection.on('error', reject)
      mongoose.connection.once('open', resolve)
      setTimeout(() => {
        reject(new Error('Failed to connect to mongodb in' + wait + 'ms'))
      }, wait)
    }).then(() => {
      console.log('Connected to mongodb@%s:%s', mongoose.connection.host, mongoose.connection.port)
    }, (err) => {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          resolve(connectToMongoDB(url, tries - 1, wait, delay))
        }, delay)
      })
    })
  } else {
    return Promise.reject(new Error('Failed to connect to mongodb'))
  }
}

// module.exports = connectToMongoDB('mongodb://localhost/test', 3).catch((err) => {
module.exports = connectToMongoDB('mongodb://database/test', 3).catch((err) => {
  console.error(err)
  process.exit(1)
})

