var mongoose = require('mongoose')

var customerSchema = mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  email: {
    type: String,
    default: null
  },
  contact: {
    type: String,
    required: true
  },
  address: {
    type: String,
    required: true
  },
  advance: {
    amount: {
      type: Number,
      default: 0
    },
    date: {
      type: Date,
      default: null
    }
  },
  invoice: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Invoice'
    }
  ],
  payments: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Payment'
    }
  ]
})

module.exports = mongoose.model('Customer', customerSchema)
