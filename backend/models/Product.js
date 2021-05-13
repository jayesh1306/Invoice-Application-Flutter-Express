var mongoose = require('mongoose');


var productSchema = new mongoose.Schema({
    date: {
        type: String,
        required: true
    },
    item: {
        type: String,
        required: true
    },
    truckNo: {
        type: String,
        required: true
    },
    from: {
        type: String,
        default: "Bhupat Prajapati"
    },
    to: {
        type: String,
        required: true
    },
    quantity: {
        type: String,
        required: true
    },
})

module.exports = mongoose.model('Product', productSchema);