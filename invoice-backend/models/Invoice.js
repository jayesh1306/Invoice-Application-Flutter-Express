const mongoose = require('mongoose')

const invoiceSchema = new mongoose.Schema({
  rate: {
    type: Number,
    required: true
  },
  quantity: {
    type: Number,
    required: true
  },
  products: {
    type: String,
    required: true
  },
  date: {
    type: Date,
    default: Date.now()
  },
  challan: {
    type: String,
    default: null
  }
})

module.exports = mongoose.model('Invoice', invoiceSchema)
