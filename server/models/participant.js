const { Model, DataTypes } = require('sequelize');
const sequelize = require('../src/config/db');

module.exports = (sequelize, DataTypes) => {
  class Participant extends Model {}
  
  Participant.init({
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    event_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    full_name: {
      type: DataTypes.STRING,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Participant',
    tableName: 'participants',
    timestamps: false,
    underscored: false
  });
  
  return Participant
};
