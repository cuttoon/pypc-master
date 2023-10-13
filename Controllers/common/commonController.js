const userdb   = require('../../Service/common/ServiceCommon')

module.exports = {
    getallCategoriaList: async(req, resp, next) => {
        try {
            const temas = await userdb.getallCategoria();
            resp.send({ result: temas });
        } catch (err) {
            resp.status(500).send({ statusCode: 500, message: err.message });
        }            
    },
    getallTipoAuditoriaList: async(req, resp, next) => {
        try {
            const temas = await userdb.getallTipoAuditoria();
            resp.send({ result: temas });
        } catch (err) {
            resp.status(500).send({ statusCode: 500, message: err.message });
        }            
    },   
    getallOds: async(req, resp, next) => {
        try {
            const temas = await userdb.getallODS();
            resp.send({ result: temas });
        } catch (err) {
            resp.status(500).send({ statusCode: 500, message: err.message });
        }            
    },
    getallAmbitos: async(req, resp, next) => {
        try {
            const temas = await userdb.getallAmbito();
            resp.send({ result: temas });
        } catch (err) {
            resp.status(500).send({ statusCode: 500, message: err.message });
        }            
    },
    getallPaises: async(req, resp, next) => {
        try {
            const temas = await userdb.getallPais();
            resp.send({ result: temas });
        } catch (err) {
            resp.status(500).send({ statusCode: 500, message: err.message });
        }            
    },
    getallParametros: async(req, resp, next) => {
        try {
          
            const temas = await userdb.getallParametro(req);
            resp.send({ result: temas });
        } catch (err) {
            resp.status(500).send({ statusCode: 500, message: err.message });
        }            
    },
    getallIdiomas: async(req, resp, next) => {
        try {
          
            const temas = await userdb.getallIdiomas();
            resp.send({ result: temas });
        } catch (err) {
            resp.status(500).send({ statusCode: 500, message: err.message });
        }            
    }      
};