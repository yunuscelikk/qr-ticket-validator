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

const deleteUser = async (req, res) => {
    const { email } = req.body;
    try {
        const deletedCount = await User.destroy({
            where: {
                email: email
            }
        });
        if(deletedCount === 0) {
            return res.status(404).json({error: "User not found"});
        }
        return res.status(200).json({
            message: "User deleted successfully",
            count: deletedCount
        });
    } catch (err) {
        console.error(err)
        res.status(500).json({error: "Server error during deletion"})
    }
}

module.exports = {getAllUsers, createUser, deleteUser};