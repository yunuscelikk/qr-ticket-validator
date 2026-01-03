const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Event extends Model {}
  
  Event.init({
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    title: {
      type: DataTypes.STRING,
      allowNull: false
    },
    description: {
      type: DataTypes.TEXT
    },
    event_date: {
      type: DataTypes.DATE,
      allowNull: false
    },
    location: {
      type: DataTypes.STRING
    },
    image_url: {
      type: DataTypes.STRING
    }
  }, {
    sequelize,
    modelName: 'Event',
    tableName: 'events',
    timestamps: false, // created at ve updated at için true olmalı
    underscored: true
  });
  
  return Event;
};