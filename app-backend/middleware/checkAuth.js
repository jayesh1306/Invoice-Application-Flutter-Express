module.exports = (req, res, next) => {
    if (req.cookies.token) {
        req.user = req.cookies.token
        next()
    } else {
        req.flash('error_msg', 'Please Login');
        res.redirect('/')
    }
}