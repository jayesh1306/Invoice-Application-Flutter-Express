var express = require('express')
var router = express.Router()
var Customer = require('../models/Customer')
var Invoice = require('../models/Invoice')
var Payment = require('../models/Payment')
var Admin = require('../models/Admin')
var pdf = require('pdf-creator-node')
var fs = require('fs')
var path = require('path')
var numToWords = require('convert-rupees-into-words');
var upload = require('../handlers/multer')
var cloudinary = require('cloudinary')
const Nexmo = require('nexmo');
var checkAuth = require('../middleware/checkAuth')
var pdf = require('html-pdf');
var ejs = require('ejs');

const nexmo = new Nexmo({
    apiKey: process.env.NEXMO_KEY,
    apiSecret: process.env.NEXMO_SECRET,
    applicationId: process.env.NEXMO_APP_ID
        // apiKey: '49d231dd',
        // apiSecret: 'iCpPw8sjTJowiOlh',
        // applicationId: 'dd9f38d1-d433-471c-8045-a64e93139d71',
});


require('../handlers/cloudinary')

// router.use(checkAuth);

router.get('/', (req, res, next) => {
    console.log(req.user);
    res.render('index', {
        title: 'Ebill | Rameshwar Enterprise',
        user: req.user
    })
})

router.get('/profile', (req, res, next) => {
    Admin.findOne().then(admin => {
        console.log(admin);
        res.render('profile', {
            title: 'User Profile',
            admin,
            user: req.user
        })
    }).catch(err => {
        req.flash('error_msg', err.message);
        req.redirect('/app');
    });
})


router.get('/addCustomer', (req, res, next) => {
    res.render('addCustomer', {
        title: 'Add Customer',
        user: req.user
    })
})


router.post('/addCustomer', (req, res, next) => {
    var { address, name, contact, email } = req.body
    var customer = new Customer({
        name,
        contact,
        email,
        address
    })

    if (address == null || name == null || contact == null || email == null) {
        res.status(404).json();
    }

    customer.save().then(result => {
        console.log(result)
        console.log(result)
        res.status(200).json(result)
            // req.flash('success_msg', 'Added Succesfully')
            // res.redirect('/app/addCustomer')
    })
})

router.get('/details', (req, res, next) => {
    Customer.find()
        .then(customer => {
            res.status(200).json(customer);
            console.log(customer)
                // res.render('details', {
                //     title: 'Details',
                //     customer,
                //     user: req.user
                // })
        })
        .catch(err => {
            console.log(err)
            res.status(400).json(err)
                // req.flash('error_msg', err.message)
                // res.redirect('/app')
        })
})

router.get('/details/delete/customer/:id', (req, res, next) => {
    Customer.deleteOne({ _id: req.params.id })
        .then(result => {
            res.status(200).json(result);
            // req.flash('success_msg', 'Deleted Successfully')
            // res.redirect('/app/details')
        })
        .catch(err => {
            console.log(err)
            res.status(401).json(err)
                // req.flash('error_msg', err.message)
                // res.redirect('/app/details')
        })
})

router.get('/details/edit/customer/:id', (req, res, next) => {
    Customer.findOne({ _id: req.params.id })
        .then(customer => {
            res.status(200).json(customer);
            // res.render('editCustomer', {
            //     user: req.user,
            //     title: "Edit Customer",
            //     customer
            // })
        })
        .catch(err => {
            console.log(err)
            res.status(401).json(err)
                // req.flash('error_msg', err.message)
                // res.redirect('/app/details')
        })
})

router.post('/details/edit/customer/:id', (req, res, next) => {
    Customer.updateOne({ _id: req.params.id }, req.body)
        .then(result => {
            res.status(200).json(result);
            // req.flash('success_msg', 'Successfully Edited')
            // res.redirect(`/app/details/edit/customer/${req.params.id}`);
        })
        .catch(err => {
            console.log(err)
            res.status(401).json(err)
                // req.flash('error_msg', err.message)
                // res.redirect(`/app/details/edit/customer/${req.params.id}`)
        })
})

router.get('/create', (req, res, next) => {
    Customer.find()
        .then(customer => {
            res.render('invoice', {
                title: 'Create Invoice',
                customer,
                user: req.user
            })
        })
        .catch(err => {
            console.log(err)
            req.flash('error_msg', err.message)
            req.redirect('/app')
        })
})

router.post('/uploadFile', upload.single('challan'), async(req, res, next) => {
    console.log(req.body)
    if (req.file) {
        console.log('-------------------------------')
        var result = await cloudinary.v2.uploader.upload(req.file.path)
        imageResult = result.url
        res.status(200).json(imageResult);
    } else {
        res.status(400).json(null)
    }
});

router.post('/create/:id', async(req, res, next) => {
    var date = new Date(req.body.invoiceDate)
    if (date == 'Invalid Date') {
        date = Date.now()
    }

    var invoice = new Invoice({
        rate: req.body.rate,
        date,
        challan: req.body.imageUrl,
        quantity: req.body.quantity,
        products: req.body.products
    })

    invoice
        .save()
        .then(result => {
            Customer.update({ _id: req.params.id }, { $push: { invoice: result._id } })
                .then(customer => {
                    res.status(200).json(result)
                        // req.flash('success_msg', 'Successfull Created Invoice ')
                        // res.redirect(`/app/create/${req.params.id}`)
                })
                .catch(err => {
                    console.log(err)
                    res.status(401).json(err)
                        // req.flash('error_msg', err.message)
                        // res.redirect(`/app/create/${req.params.id}`)
                })
        })
        .catch(err => {
            console.log(err)
            res.status(402).json(err)
                // req.flash('error_msg', err.message)
                // res.redirect(`/app/create/${req.params.id}`)
        })
})

router.get('/create/:id', (req, res, next) => {
    var customerId = req.body
    Customer.findOne({ _id: req.params.id })
        .then(customer => {
            res.render('createInvoice', {
                title: 'Create Invoice',
                customer,
                user: req.user
            })
        })
        .catch(err => {
            console.log(err)
            req.flash('error_msg', err.message)
            res.redirect('/app/create')
        })
})

router.get('/details/advance/:customerId', (req, res, next) => {
    Customer.findOne({ _id: req.params.customerId })
        .then(customer => {
            res.status(200).json(customer);
            // res.render('advance', {
            //     title: 'Advance Payment',
            //     customer,
            //     user: req.user
            // })
        })
        .catch(err => {
            console.log(err)
            res.status(401).json(err)
                // req.flash('error_msg', err.message)
                // res.redirect('/app/details')
        })
})

router.post('/details/advance/:customerId', (req, res, next) => {
    var date = new Date(req.body.advanceDate)
    var advance = {
        amount: req.body.amount,
        date: date
    }
    Customer.updateOne({ _id: req.params.customerId }, { advance: advance })
        .then(result => {
            res.status(200).json(result);
            // req.flash('success_msg', 'Successfully Added Advance')
            // res.redirect(`/app/details`)
        })
        .catch(err => {
            console.log(err)
            res.status(401).json(err)
                // req.flash('error_msg', err.message)
                // res.redirect(`/app/details/advance/${req.params.customerId}`)
        })
})

router.get('/details/:customerId/:invoiceId/edit', (req, res, next) => {
    console.log(req.params.customerId, req.params.invoiceId)
    Invoice.findOne({ _id: req.params.invoiceId })
        .then(invoice => {
            res.status(200).json(invoice);
            // console.log(invoice)
            // res.render('editInvoice', {
            //     title: 'Edit Invoice',
            //     customerId: req.params.customerId,
            //     invoice,
            //     user: req.user
            // })
        })
        .catch(err => {
            console.log(err)
            res.status(401).json(err)
                // req.flash('error_msg', err.message)
                // res.redirect(`/app/details/${req.params.customerId}`)
        })
})

router.post('/details/:customerId/:invoiceId/edit', (req, res, next) => {
    console.log(req.body)
    var date = new Date(req.body.invoiceDate)
    if (date == 'Invalid Date') {
        date = Date.now()
    }
    var invoice = {
        rate: req.body.rate,
        date,
        quantity: req.body.quantity,
        products: req.body.products
    }
    Invoice.updateOne({ _id: req.params.invoiceId }, invoice)
        .then(result => {
            res.status(200).json(result)
                // req.flash('success_msg', 'Successfully Updated')
                // res.redirect(`/app/details/${req.params.customerId}`)
        })
        .catch(err => {
            console.log(err)
            res.status(401).json(err)
                // req.flash('error_msg', err.message)
                // res.redirect(`/app/details/${req.params.customerId}`)
        })
})

router.get('/details/:id', (req, res, next) => {
    Customer.findOne({
            _id: req.params.id
        })
        .populate('invoice', '_id date challan rate quantity products', null, { sort: { 'date': 1 } })
        .then(customer => {
            var totalBill = 0;
            var invoices = customer.invoice;
            // console.log(invoices)
            res.status(200).json(invoices)
                // res.render('invoiceDetails', {
                //     title: 'Details of Invoice of One Customer',
                //     invoice: customer,
                //     totalBill,
                //     user: req.user
                // })
        })
        .catch(err => {
            console.log(err)
            res.status(401).json(err)
                // req.flash('error_msg', err.message)
                // res.redirect(`/app/details/${req.params.customerId}`)
        })
})

router.get('/details/:customerId/:invoiceId/delete', (req, res, next) => {
    Invoice.deleteOne({ _id: req.params.invoiceId })
        .then(result => {
            res.status(200).json(result)
                // req.flash('success_msg', 'Successfully Deleted')
                // res.redirect(`/app/details/${req.params.customerId}`)
        })
        .catch(err => {
            console.log(err)
            res.status(401).json(err)
                // req.flash('error_msg', err.message)
                // res.redirect(`/app/details/${req.params.customerId}`)
        })
})

router.get('/details/:customerId/getPDF', (req, res, next) => {
    res.render('getPDf', {
        title: 'PDF',
        customerId: req.params.customerId,
        user: req.user
    })
})

router.post('/details/:customerId/getPDF', async(req, res, next) => {
    var { fromDate, toDate } = req.body
    var fdate = new Date(fromDate);
    var tdate = new Date(toDate);
    // fdate.setDate(fdate.getDate() - 1)
    tdate.setDate(tdate.getDate() + 1)
    console.log(fdate, tdate)
    var toDate =
        console.log();
    var totalPrice = 0
    Customer.findOne({ _id: req.params.customerId })
        .populate('payments').populate('invoice')
        .then(customer => {
            console.log(customer)
            Invoice.find({
                $and: [{
                    '_id': { $in: customer.invoice },
                }, {
                    date: {
                        $gte: fdate.toISOString(),
                        $lte: tdate.toISOString()
                    }
                }]
            }, (err, invoice) => {
                console.log(invoice)
                if (err) {
                    console.log(err);
                    res.status(401).json(err)
                        // req.flash('error_msg', err.message);
                        // res.redirect(`/details/${req.params.customerId}/getPDF`);
                } else {
                    for (var i = 0; i < invoice.length; i++) {
                        totalPrice += (invoice[i].quantity * (invoice[i].rate * 10)) / 10;
                    }
                    // for (var i = 0; i < customer.payments.length; i++) {
                    //     totalPrice -= customer.payments[i].amount
                    // }
                    totalPrice -= customer.advance.amount

                    var totalWords = numToWords(totalPrice);
                    // res.status(200).json({
                    //     invoice: invoice,
                    //     payment: customer.payments,
                    //     customer: customer,
                    //     logo: req.body.logo,
                    //     totalPrice,
                    //     totalWords,
                    // })
                    console.log(req.body.creator)
                    if (invoice.length == 0) {
                        res.status(400).json({ message: 'No Invoices' });
                    } else {
                        ejs.renderFile(path.join(__dirname, '../views/pdf.ejs'), {
                            invoice: invoice,
                            payment: customer.payments,
                            customer: customer,
                            logo: req.body.logo,
                            totalPrice,
                            totalWords,
                            creator: req.body.creator,
                            user: req.user
                        }, (err, data) => {
                            if (err) {
                                res.send(err);
                            } else {
                                let options = {
                                    "height": "11.75in",
                                    "width": "8.25in",
                                };
                                pdf.create(data, options).toFile("report.pdf", function(err, data) {
                                    if (err) res.send(err);

                                    else res.send({ data: 'success' });
                                });
                            }
                        })
                    }
                    // res.render('pdf', {
                    //     invoice: invoice,
                    //     payment: customer.payments,
                    //     customer: customer,
                    //     logo: req.body.logo,
                    //     totalPrice,
                    //     totalWords,
                    //     user: req.user,
                    // })
                }
            })
        })
        .catch()
})

router.get('/details/:customerId/payments', (req, res, next) => {
    Customer.findOne({ _id: req.params.customerId })
        .populate('payments')
        .then(customer => {
            var payment = customer.payments
            console.log(payment)
            res.status(200).json(payment);
            // res.render('paymentDetails', {
            //     customer,
            //     title: 'Payment Details',
            //     payment,
            //     user: req.user
            // })
        })
        .catch()
})

//Delete Payment
router.get('/details/:customerId/payments/delete/:paymentId', (req, res, next) => {
    Payment.deleteOne({ _id: req.params.paymentId })
        .then(response => {
            res.status(200).json(response);
            // req.flash('success_msg', 'Deleted Successfully')
            // res.redirect(`/app/details/${req.params.customerId}/payments`);
        })
        .catch(err => {
            console.log(err);
            res.status(401).json(err)
                // req.flash('error_msg', err.message);
                // res.redirect(`/app/details/${req.params.customerId}/payments`)
        })
})

router.get('/payments', (req, res, next) => {
    Customer.find()
        .then(customer => {
            res.status(200).json(customer)
                // res.render('customer', {
                //     title: 'Customer',
                //     customer,
                //     user: req.user
                // })
        })
        .catch()
})

router.get('/addPayment/:customerId', (req, res, next) => {
    Customer.findOne({ _id: req.params.customerId })
        .then(customer => {
            // res.status(200).json(customer);
            res.render('addPayment', {
                title: 'Add Payment',
                customer,
                user: req.user
            })
        })
        .catch()
})

router.post('/addPayment/:customerId', (req, res, next) => {
    console.log(req.body)
    var payment = new Payment({
        amount: req.body.amount,
        date: new Date(req.body.date),
        mode: req.body.mode
    })
    payment
        .save()
        .then(payment => {
            if (req.body.send == true) {
                Customer.findOne({ _id: req.params.customerId }).then(customer => {
                    nexmo.message.sendSms('BHUPAT PRAJAPATI', `+91${customer.contact}`, `Hello ${customer.name}, My name is Bhupat Prajapati, I have received payment of Rs ${req.body.amount} Dated ${req.body.date}. Payment mode is ${req.body.mode}`);
                    Customer.updateOne({ _id: req.params.customerId }, { $push: { payments: payment._id } }).then(result => {
                        res.status(200).json(payment);

                        // req.flash('success_msg', 'SUccessfully Added Paymet')
                        // res.redirect(`/app/addPayment/${req.params.customerId}`)
                    })
                }).catch(err => {
                    res.status(401).json(err)
                        // req.flash('error_msg', err.message);
                        // res.redirect(`/app/addPayment/${req.params.customerId}`)
                });
            } else {
                Customer.updateOne({ _id: req.params.customerId }, { $push: { payments: payment._id } }).then(result => {
                    res.status(200).json(payment);

                    // req.flash('success_msg', 'SUccessfully Added Paymet')
                    // res.redirect(`/app/addPayment/${req.params.customerId}`)
                })
            }
        })
        .catch(err => {
            console.log(err)
            res.status(402).json(customer);

            // req.flash('error_msg', err.message);
            // res.redirect(`/app/addPayment/${req.params.customerId}`)
        })
})

router.get('/sendSms/:customerId', (req, res, next) => {
    var totalPrice = 0;
    Customer.findOne({ _id: req.params.customerId }).populate('invoice').populate('payments').then(customer => {
        for (var i = 0; i < customer.invoice.length; i++) {
            totalPrice += (customer.invoice[i].quantity * (customer.invoice[i].rate * 10)) / 10;
        }
        if (customer.payments.length != 0) {
            for (var i = 0; i < customer.payments.length; i++) {
                totalPrice -= customer.payments[i].amount
            }
        }
        totalPrice -= customer.advance.amount
        nexmo.message.sendSms('BHUPAT PRAJAPATI', `+91${customer.contact}`, `Hello ${customer.name}, My name is Bhupat Prajapati, You have pending bill of Rs ${totalPrice}`, result => {
            res.status(200).json(result);
            console.log(result)
                // req.flash('success_msg', `Successfully Sent message to ${customer.name}`);
                // res.redirect(`/app/details`)
        })
    }).catch(err => {
        console.log(err)
        res.status(401).json(err)
            // req.flash('error_msg', err.message);
            // res.redirect(`/app/details`)
    });
})

router.get('/logout', (req, res, next) => {
    res.clearCookie('token');
    res.redirect('/');
})

module.exports = router