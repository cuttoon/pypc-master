const userdb   = require('../../Service/authService/Serviceaccount')
const { secret } = require('../../Settings/Enviroment/config');
const bcrypt = require('bcrypt');
//const jwt = require('jsonwebtoken');
const {TokenSignup} =require('../../Settings/Server/midlewar/TokenService')
module.exports = {
    Singup: async(req, resp, next) => {
        
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
                    //is_staff: user.NUSU_IS_STAFF,
                    //is_superuser: user.NUSU_IS_SUPERUSER,
                    rol: datavalidEmail.NUSU_ROLID
                    //grupo: user.NEFS_ID
                };   
                const token = TokenSignup(payload, secret,'12h');
                //jwt.sign(payload, secret, { expiresIn: '12h' });                    
                
                return   resp.status(200).send({ IdCuenta : datavalidEmail.NUSU_ID,  IdRol : datavalidEmail.NUSU_ROLID, Nombre: datavalidEmail.CUSU_EMAIL, Token:token }) 
            } else {
                return resp.status(401).send({statusCode: 400, message: "Datos inconsistente"});
            }
    

          }
        }catch(ex){
            return resp.status(500).send({ statusCode: 500, message: ex.message }); 
        }
   
    }
};