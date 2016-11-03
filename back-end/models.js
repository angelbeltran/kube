'use strict'

const mongoose = require('mongoose')


let PetSchema = mongoose.Schema({
  name: { type: String, required: true },
  age: { type: Number, default: 0 },
  type: { type: String, default: 'Kitty Kat' },
})

let Pet = mongoose.model('Pet', PetSchema)


module.exports = {
  Pet: Pet,
}
