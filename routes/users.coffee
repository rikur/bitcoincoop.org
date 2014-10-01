db = require("../redis")

module.exports = ->
  create: (req, res) ->
    userkey = "farm:#{req.body.email}"
    db.hmset(userkey,
      email: req.body.email,
      phone: req.body.phone,
      address: req.body.address
    )

    res.render('welcome', 
      user: req.params.user, 
      layout: 'mail',
      js: (-> global.js), 
      css: (-> global.css),
      (err, html) ->
        sendgrid = require('sendgrid')(config.sendgrid_user, config.sendgrid_password)

        email = new sendgrid.Email(
          to: req.body.email
          from: 'sea.green@gmail.com'
          subject: 'Welcome to Karma Farma'
          html: html
        )

        sendgrid.send(email)
    )
