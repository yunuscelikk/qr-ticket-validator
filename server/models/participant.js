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
    },
    qr_code: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      allowNull: false,
      unique: true
    },
    checked_in_at: {
      type: DataTypes.DATE,
      allowNull: true
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
