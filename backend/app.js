var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var mongoose = require('mongoose');
var cors = require('cors')

var index = require('./routes/index');

mongoose.connect(
        // 'mongodb+srv://jayesh:2Ol8BLec9QjxwVCm@notesapp-klr66.mongodb.net/transactions?retryWrites=true&w=majority', { useNewUrlParser: true, useUnifiedTopology: true })
        'mongodb://localhost:27017/transactions', { useNewUrlParser: true, useUnifiedTopology: true })
    .then(response => {
        console.log('COnnected DB');
    })
    .catch(error => {
        console.log(error);
    });

var app = express();

app.use(cors())

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/api', index);

var port = process.env.PORT || 3000;

app.listen(port, () => {
    console.log(`Listening on port ${port}`)
})