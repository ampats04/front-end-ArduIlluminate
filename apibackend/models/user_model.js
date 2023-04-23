const db_con = require("../database/database");


const userModel = function(user){

    this.name = user.name;
    this.birthdate = user.birthdate;
    this.email = user.email;
    this.username = user.username;
    this.password = user.password;
};


userModel.create = (newUser, result) => {
    db_con.query("INSERT INTO users SET ?", newUser, (err,res) => {
            if(err){
                console.log("error: ", err);
                result(err,null);
                return;
            }
        console.log("Created User: ", {user_id: res.insertId, ...newUser});
        console.log("added new user")
       
    });
}

userModel.getAll = (user_id,result) => {

    let query = "SELECT * FROM users";

    if(user_id){
        query += `WHERE user_id LIKE '%${user_id}%'`;
    }
    db_con.query(query, (err,res) => {
        if(err){
            console.log("error: ", err);
            result(null,err);
            return;
        }
        console.log("Users: ", res);
        return(null, err);
    });
};

userModel.updateById = (user_id, user, result) => {

    db_con.query(
        "UPDATE users SET name = ?, birthdate = ?, email = ?, username = ?, password = ? WHERE user_id = ?",
        [user.name, user.birthdate, user.email, user.username, user.password, user_id],
        (err,res) => {
            if(err){
                console.log("error: ", err);
                result(null, err);
                return;
            }

            if(res.affectedRows == 0) {
                result({kind: "not_found"}, null);
                return;
            }
            console.log("updated tasl: ", {user_id: user_id, ...user});
            result(null, {user_id: user_id, ...user});
        }
    );
}


userModel.remove = (user_id, result) => {
    db_con.query("DELETE FROM users WHERE user_id =?", user_id, (err,res) => {
        if(err){

            console.log("error: ", err);
            result(null,err);
            return;
        }
        if(res.affectedRows == 0){
            result({kind: "not found"}, null);
            return;
        }
        console.log("deleted task with id: " , id);
        result(null,res);
    })
}


    module.exports = userModel