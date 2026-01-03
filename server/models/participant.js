const { Model } = require('sequelize');

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
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Participant',
    tableName: 'participants',
    timestamps: true,
    underscored: true
  });
  
  return Participant;
};