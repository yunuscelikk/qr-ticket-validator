'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('participants', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      event_id: {
        type: Sequelize.INTEGER,
        references: {
          model: 'events',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      full_name: {
        type: Sequelize.STRING,
        allowNull: false
      },
      email: Sequelize.STRING
    });
  },

  async down(queryInterface) {
    await queryInterface.dropTable('participants');
  }
};
