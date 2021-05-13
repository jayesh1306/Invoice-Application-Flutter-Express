var express = require('express');
var router = express.Router();
var Transaction = require('../models/Transaction');
var Product = require('../models/Product');

router.post('/addTransaction', (req, res, next) => {
    var newTransaction = new Transaction({
        name: req.body.name,
        date: req.body.date,
        reason: req.body.reason,
        amount: req.body.amount,
        type: req.body.type
    })
    newTransaction.save()
        .then(response => {
            console.log(response)
            res.status(200).json(response);
        })
        .catch(error => {
            res.status(400).json({ message: "Not Saved" })
        });
})

router.get('/allTransactions', (req, res, next) => {
    Transaction.find().sort({ date: 1 }).exec((err, data) => {
        if (err) {
            res.status(400).json({ message: error.message })
        } else {
            res.status(200).json(data)
        }
    })
})

router.get('/deleteAllTransactions', (req, res, next) => {
    Transaction.deleteMany()
        .then(result => {
            res.status(200).json(result);
        })
        .catch(err => {
            res.status(400).json(err);
        });
});

router.get('/deleteAllProducts', (req, res, next) => {
    Product.deleteMany()
        .then(result => {
            res.status(200).json(result);
        })
        .catch(err => {
            res.status(400).json(err);
        });
});

router.get('/delete/:id', (req, res, next) => {
    Transaction.deleteOne({ _id: req.params.id })
        .then(response => {
            res.status(200).json({ message: "Deleted" });
        })
        .catch(error => {
            res.status(400).json({ message: 'Cannot Delete' })
        });
})

router.get('/allProducts', (req, res, next) => {
    Product.find().sort({ 'date': 'asc' }).exec((err, product) => {
        if (err) {
            res.status(400).json(err)
        } else {
            res.status(200).json(product);
        }
    })
})

router.post('/addProduct', (req, res, next) => {
    if (!req.body.from) {
        req.body.from = 'R.J.K';
    }
    var newProduct = new Product(req.body)
    newProduct.save()
        .then(response => {
            res.status(200).json(response);
        })
        .catch(err => {
            console.log(err)
            res.status(400).json({ message: "Not Saved" })
        });
})

router.get('/deleteProduct/:id', (req, res, next) => {
    Product.deleteOne({ _id: req.params.id })
        .then(response => {
            res.status(200).json({ message: 'Delted' });
        })
        .catch(err => {
            console.log(err)
            res.status(400).json({ message: "Not Deleted" })
        });
})

module.exports = router;