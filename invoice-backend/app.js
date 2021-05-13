var express = require('express')
var path = require('path')
var favicon = require('static-favicon')
var logger = require('morgan')
var cookieParser = require('cookie-parser')
var bodyParser = require('body-parser')
var mongoose = require('mongoose')
var dotenv = require('dotenv').config()
const session = require('express-session')
var expressLayouts = require('express-ejs-layouts')

var flash = require('connect-flash')
var routes = require('./routes/routes')
var authentication = require('./routes/auth');

var app = express()

// view engine setup
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'ejs')

// Connect flash
app.use(flash())

// Express session
app.use(
    session({
        secret: 'secret',
        resave: true,
        saveUninitialized: true
    })
)

app.use(expressLayouts)
app.use(favicon())
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded())
app.use(cookieParser())
app.use(express.static(path.join(__dirname, 'public')))
app.use(express.static(path.join(__dirname, '/')))

// Global variables
app.use(function(req, res, next) {
    res.locals.success_msg = req.flash('success_msg')
    res.locals.error_msg = req.flash('error_msg')
    res.locals.error = req.flash('error')
    next()
})

app.use('/app', routes)
app.use('/', authentication);

//Database Connection
mongoose.connect(
    process.env.MONGODB_PRODUCTION, {
        //  'mongodb+srv://jayesh:2Ol8BLec9QjxwVCm@notesapp-klr66.mongodb.net/ebill?retryWrites=true&w=majority', {
        // 'mongodb+srv://jayesh:2Ol8BLec9QjxwVCm@notesapp-klr66.mongodb.net/flutter-testing?retryWrites=true&w=majority', {
        useNewUrlParser: true,
        useUnifiedTopology: true
    },
    (err, result) => {
        if (err) {
            console.log(err)
            process.exit()
        } else {
            console.log('Database Connected')
        }
    }
)

var port = process.env.PORT || 3000

app.listen(port, function() {
    console.log('Express server listening on port ' + port)
})