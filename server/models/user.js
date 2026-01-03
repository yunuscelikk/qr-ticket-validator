const { Model, DataTypes } = require('sequelize');
const { sequelize, Sequelize } = require('.');

module.exports = (sequelize, DataTypes) => {
    class User extends Model {}

    User.init({
        id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        email: {
            type: DataTypes.STRING,
            allowNull: false,
            unique: true
        },
        password: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        created_at: {
             type: DataTypes.DATE,
             defaultValue: DataTypes.NOW,
        }
    }, {
        sequelize,
        modelName: 'User',
        tableName: 'users',
        timestamps: true,
        underscored: true,
        createdAt: 'created_at',
        updatedAt: false
    });

    return User;
}