const Security = require('./auth/securityController');
const User = require('./user/userController');
const Common = require('./common/commonController')
const Auditoria = require('./auditoria/auditoriaController')
module.exports = {
    Security,
    User,
    Common,
    Auditoria
};