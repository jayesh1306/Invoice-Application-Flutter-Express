const mongoose = require('mongoose')

const paymentSchema = new mongoose.Schema({
  amount: {
    type: Number,
    required: true
  },
  date: {
    type: Date,
    default: Date.now()
  },
  mode: {
    type: String,
    required: true
  }
})

module.exports = mongoose.model('Payment', paymentSchema)
