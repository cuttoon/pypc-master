const express = require('express');
const router = express.Router();
const { Common } = require('../../../Controllers');
router.get('/getallCategorias', Common.getallCategoriaList);
router.get('/getallTipoAuditoria', Common.getallTipoAuditoriaList);
router.get('/getallOds', Common.getallOds);
router.get('/getallAmbito', Common.getallAmbitos);
router.get('/getallPais', Common.getallPaises);
router.get('/getallParametro/:table_name', Common.getallParametros);
router.get('/getallIdioma/', Common.getallIdiomas);
module.exports = (app, nextMain) => {
    app.use('/intosai/common', router);
    return nextMain();
};
