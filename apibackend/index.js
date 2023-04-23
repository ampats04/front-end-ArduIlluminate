const express = require('express');
const app = express();


const userPost = require('./http/post/user_post')
const userRoutes = require('../apibackend/routes/user_routes')
//settings
app.set('port', process.env.PORT || 8000);

//Middlewares
app.use(express.json());

//Routes

app.use("/",userRoutes)

app.get('/', (req,res) => {
    res.send({"message": "welcome", })
})

//Starting the server
app.listen(app.get('port'), () => {
    console.log('Server on port', app.get('port'));
});



