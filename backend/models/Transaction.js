var mongoose = require('mongoose');


var transactionSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    date: {
        type: String,
        required: true
    },
    reason: {
        type: String,
        required: true
    },
    amount: {
        type: Number,
        required: true
    },
    type: {
        type: String,
        required: true
    }
})


module.exports = mongoose.model('Transaction', transactionSchema);