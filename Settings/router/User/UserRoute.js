const express = require('express');
const router = express.Router();
const { User } = require('../../../Controllers');
const  { Filter  } = require('../../Server/midlewar/permissions');
router.get('/getAllUsers',Filter, User.getAllUsers);
router.post('/Users',Filter, User.createUser);
router.post('/register', User.createUser);
module.exports = (app, nextMain) => {
    app.use('/intosai/users', router);
    return nextMain();
};
