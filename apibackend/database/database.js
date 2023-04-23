const mysql = require('mysql');

const mysqlConnection = mysql.createConnection({

    host: 'localhost',
    user: 'root',
    password: '123456789',
    database: 'ardudb',
    debug: false,
    port: 3306,

});

mysqlConnection.connect(function (error){

    if(error){
        console.error('error connecting: ' + error.stack);
        return;
    }else{
        console.log('Database is connected');
    }
});

module.exports = mysqlConnection