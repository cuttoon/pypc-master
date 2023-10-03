const express = require('express');
const router = express.Router();
const { Security } = require('../../../Controllers');
const  { Filter , Destroy } = require('../../Server/midlewar/permissions');
router.post('/Singup', Security.Singup);
router.post('/Signoff', Destroy);


module.exports = (app, nextMain) => {
    app.use('/intosai/security', router);
    return nextMain();
};

