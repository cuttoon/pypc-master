const userdb   = require('../../Service/authService/Serviceaccount')
const userdbUser   = require('../../Service/authService/Serviceusers')
const { secret } = require('../../Settings/Enviroment/config');
const bcrypt = require('bcrypt');
const { validateUser } = require('../../Models');
const { existEmail } = require('../common');
const {TokenSignup} =require('../../Settings/Server/midlewar/TokenService')
module.exports = {
    Signin: async(req, resp, next) => {
        
        try{
            const {email , password} = req.body;
            if((email == null) &&(password == null)){
                return resp.status(400).send({statusCode: 400, message: "Datos imcompletos"});
            }         
            else{
    
               let datavalidEmail = await userdb.getUserbyEmail(email)
    
               if (bcrypt.compareSync(password, datavalidEmail.CUSU_PASSWORD)) {
               
               
                const payload = {
                    id: datavalidEmail.NUSU_ID,
                    rol: datavalidEmail.NUSU_ROLID
                };   
                const token = TokenSignup(payload, secret,'12h');                    
                
                return   resp.status(200).send({ IdCuenta : datavalidEmail.NUSU_ID,  IdRol : datavalidEmail.NUSU_ROLID, Nombre: datavalidEmail.NOMBRE, Token:token }) 
            } else {
                return resp.status(401).send({statusCode: 400, message: "Datos inconsistente"});
            }
    

          }
        }catch(ex){
            return resp.status(500).send({ statusCode: 500, message: ex.message }); 
        }
   
    },
    Signup: async(req, resp, next) => {
        
        try { 
            const newUser = validateUser(req.body);

            if (await existEmail(req.body.correo)) {
                throw new CustomError({ correo: ['email already exists']}, 400);
            }

            let result = await userdbUser.createUser(newUser);
            resp.send({ result });

        } catch(ex){
            return resp.status(500).send({ statusCode: 500, message: ex.message }); 
        }
   
    }
};