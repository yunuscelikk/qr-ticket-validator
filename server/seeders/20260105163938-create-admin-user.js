'use strict';
const bcrypt = require('bcryptjs');

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {

    const hashedPassword = await bcrypt.hash('123456', 10);

    await queryInterface.bulkInsert('users', [{
      full_name: 'Yönetici',
      email: 'admin@app.com',
      password: hashedPassword,
      createdAt: new Date(),
      updatedAt: new Date()
    }],{});
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.bulkDelete('users', { email: 'admin@app.com'}, {});
  }
};
