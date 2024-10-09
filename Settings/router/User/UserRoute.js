const express = require('express');
const router = express.Router();
const { User } = require('../../../Controllers');
const  { Filter  } = require('../../Server/midlewar/permissions');
router.get('/getAllUsers',Filter, User.getAllUsers);
router.post('/create',Filter, User.createUser);
module.exports = (app, nextMain) => {
    app.use('/pypc/users', router);
    return nextMain();
};
