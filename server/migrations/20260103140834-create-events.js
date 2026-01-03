'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('events', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      title: {
        type: Sequelize.STRING,
        allowNull: false
      },
      description: Sequelize.TEXT,
      event_date: Sequelize.DATE,
      location: Sequelize.STRING,
      image_url: Sequelize.TEXT
    });
  },

  async down(queryInterface) {
    await queryInterface.dropTable('events');
  }
};
