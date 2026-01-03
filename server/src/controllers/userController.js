const sequelize = require("../config/db");
const { User } = require("../../models") 

const getAllUsers = async (req, res) => {
    try {
        const users = await User.findAll({
            order: [['created_at', 'ASC']]
        });
        res.status(200).json(users);
    } catch(err) {
        res.status(500).json({error: "Users cant fetch"});
    }
}

const createUser = async (req, res) => {
    const { email, password } = req.body;
    try {
        const user = await User.create({
            email,
            password
        });
        res.status(201).json(user);
    } catch (err) {
        console.error(err);
        res.status(500).json({error: "User creation failed"});
    }
}

module.exports = {getAllUsers, createUser};