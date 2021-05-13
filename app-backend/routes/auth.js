const express = require('express');
var Admin = require('../models/Admin')
const nodemailer = require('nodemailer')
var jwt = require('jsonwebtoken')
var sha256 = require('sha256');
var router = express.Router();

let transporter = nodemailer.createTransport({
    service: 'gmail', // true for 465, false for other ports
    auth: {
        user: process.env.EMAIL, // generated ethereal user
        pass: process.env.PASS // generated ethereal password
    }
})


router.get('/', (req, res, next) => {
    res.render('login', {
        title: "Login",
        user: null
    })
})

router.post('/', (req, res, next) => {
    console.log(req.body);

    Admin.findOne().then(admin => {
        if (admin.password == sha256(req.body.password)) {
            res.cookie('token', 'Bearer ' + admin.name)
            res.redirect('/app');
        } else {
            req.flash('error_msg', 'Wrong Password');
            res.redirect('/');
        }
    }).catch(err => {
        req.flash('error_msg', err.message);
        res.redirect('/')
    });
})

router.get('/forgot', (req, res, next) => {
    res.render('forgot', {
        user: req.cookies.token,
        title: "Forgot Password"
    })
})

router.post('/forgot', (req, res, next) => {
    Admin.findOne({ email: req.body.email }).then(admin => {
        if (admin) {
            var token = jwt.sign({
                name: admin.name
            }, 'secret', {
                expiresIn: 180
            })
            console.log(token);

            transporter
                .sendMail({
                    from: 'No Reply <no-reply@ebill.com>',
                    to: admin.email,
                    subject: 'Change Password ',
                    html: `Click <a href='https://ebill-app.herokuapp.com/change/${token}'>here</a> to change password] `
                })
            req.flash('success_msg', 'Please Click a link that sent you on email');
            res.redirect('/forgot');
        } else {
            req.flash('error_msg', 'You\'re not an admin');
            res.redirect('/forgot');
        }
    }).catch(err => {
        req.flash('error_msg', err.message);
        res.redirect('/forgot')
    });
})

router.post('/change', (req, res, next) => {
    var pass1 = sha256(req.body.pass1);
    var pass2 = sha256(req.body.pass2);
    if (pass1 == pass2) {

        Admin.updateOne({ email: 'bhupat203@gmail.com' }, { password: pass1 }).then(admin => {
            console.log(admin);

            req.flash('success_msg', 'Password Updated')
            res.redirect('/forgot');
        }).catch(err => {
            req.flash('error_msg', err.message);
            console.log('--------------------------------------------------------------------------');
            res.redirect('/forgot');
        });
    } else {
        req.flash('error_msg', 'Password do not Match');
        console.log('=====================================================================');
        res.redirect(`/`)
    }
})

router.get('/change/:token', (req, res, next) => {
    var decoded = jwt.verify(req.params.token, 'secret');
    if (decoded.exp > parseInt(Date.now() / 1000)) {
        res.cookie('email', decoded.email)
        res.render('change', {
            token: req.cookies.token,
            user: decoded.email
        })
    } else {
        req.flash('error_msg', 'Expired Link');
        res.redirect(`/change/${req.params.token}`);
    }
})


module.exports = router;