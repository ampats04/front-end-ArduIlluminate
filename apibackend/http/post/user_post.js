const express = require('express')
const userModel = require('../../models/user_model')
const app = express()

app.post('/api/user/oten', (req,res) => {
    userModel.addUser(req.body)
    console.log(req.body.id)
    res.send({'Message':'Success'})
})

module.exports = app