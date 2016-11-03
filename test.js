'use strict'

const spawn = require('child_process').spawn
const CLUSTER_IP = process.env.CLUSTER_IP || '192.168.99.100'
const FRONT_END_PORT = process.env.FRONT_END_PORT || 30001
const BACK_END_PORT = process.env.BACK_END_PORT || 30002

function noop () {}

function run (cmd, args, cb) {
  cb = cb || noop
  let cp = spawn(cmd, args)

  cp.stdout.on('data', (data) => {
    console.log(data.toString())
  })
  cp.stderr.on('data', (data) => {
    console.error(data.toString())
  })
  cp.on('close', (code) => {
    if (code) {
      console.error('process closed with non-zero error code:', code.toString())
    }
    cb()
  })
}


function hitFrontEnd (times, cb) {
  times = times || 0
  cb = cb || noop
  if (times) {
    run('curl', ['-sS', 'http://' + CLUSTER_IP + ':' + FRONT_END_PORT], hitFrontEnd.bind(null, times - 1, cb))
  } else {
    cb()
  }
}

function hitBackEnd (times, cb) {
  times = times || 0
  cb = cb || noop
  if (times) {
    run('curl', ['-sS', 'http://' + CLUSTER_IP + ':' + BACK_END_PORT], hitBackEnd.bind(null, times - 1, cb))
  } else {
    cb()
  }
}

hitFrontEnd(5, hitBackEnd.bind(null, 5))
