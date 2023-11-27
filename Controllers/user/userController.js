const userdb   = require('../../Service/authService/Serviceusers')
const { validateUser } = require('../../Models');
const CustomError = require('../../Service/errors');
const { existEmail,existEmailUpdate } = require('../common');

module.exports = {
    getAllUsers: async(req, resp, next) => {
        try {
            const users = await userdb.getAllUsers();
            resp.send({ result: users });
        } catch (err) {
            resp.status(500).send({ statusCode: 500, message: err.message });
        }          
        
    },
    createUser: async(req, resp, next) => {
        try { 
            //const createUser = req.user.U_ID;
            const newUser = validateUser(req.body);

            if(newUser.ids==undefined){
                if (await existEmail(req.body.correo)) 
                throw new CustomError({ correo: ['email already exists']}, 400);
            }

            //newUser.user_id = createUser;
            /* let result=null;
            if(newUser.ids==undefined){
                result = await userdb.createUser(newUser);
            }else{
                result = await userdb.updateUser(newUser);
            } */

            let result = await userdb.createUser(newUser);
            resp.send({ result });

        } catch (err) {
            if (err instanceof CustomError) {
                return next(err);  
            }
            resp.status(500).send({ statusCode: 500, message: err.message });
        } 
    },

    updateUser: async(req, resp, next) => {
        try {
            const updateUser = validateUser(req.body);

            if(await existEmailUpdate(req.body.correo, req.body.ids)){
                throw new CustomError({ correo: ['email already exists']}, 400);
            }

            let result = await userdb.updateUser(updateUser)
            resp.send({ result });
        } catch (err) {
            if (err instanceof CustomError) {
                return next(err);  
            }
            resp.status(500).send({ statusCode: 500, message: err.message });
        }
    }
    
};