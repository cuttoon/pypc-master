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
    
               if (bcrypt.compareSync(password, datavalidEmail.PASSWORD)) {
               
               
                const payload = {
                    id: datavalidEmail.ID,
                    //is_staff: user.NUSU_IS_STAFF,
                    //is_superuser: user.NUSU_IS_SUPERUSER,
                    rol: datavalidEmail.ROL_ID
                    //grupo: user.NEFS_ID
                };   
                const token = TokenSignup(payload, secret,'12h');
                //jwt.sign(payload, secret, { expiresIn: '12h' });                    
                
                return   resp.status(200).send({ IdCuenta : datavalidEmail.ID,  IdRol : datavalidEmail.ROL_ID, Nombre: datavalidEmail.NOMBRE, Token:token }) 
            } else {
                return resp.status(401).send({statusCode: 400, message: "Datos inconsistente"});
            }
    

          }
        }catch(ex){
            return resp.status(500).send({ statusCode: 500, message: ex.message }); 
        }
   
    }
};