const CustomError = require('../service/errors');
const validator = require('email-validator');
const bycrypt = require('bycrypt');

const user = {
  nombre: 'string',
  apellido: 'string',
  correo: 'string',
  clave: 'string',
  rol: 'number',
  sexo: 'string',
  pais: 'number',
  ids:'number'
};

const validateObj = (validate, data) => {
  const error = {};
  const fields = Object.keys(data);

  Object.keys(validate).forEach(ele => {
    if (!fields.includes(ele) || !data[ele]) {
        if(!isNaN(data[ele]) ){
            if(ele=="clave" && data["ids"]==undefined){
                error[ele] = ['This field may not be blank.'];
            }else if (data[ele]?.lenght === 0 || data[ele]=='') {
                error[ele] = ['This field may not be blank.'];                 
            }
        }

    } else if (Array.isArray(validate[ele])) {
        if (data[ele]?.lenght === 0 || data[ele]=='') {
            error[ele] = ['This field may not be blank.'];                 
        } else if (!validate[ele].includes(typeof data[ele])) {                
            error[ele] = [`This field must be an ${validate[ele][0]} or null`];
        }
    } else {
        
        if (ele === 'sexo' && !["M", "F"].includes(data[ele])) {
            error[ele] = [`This field must be 'M' or 'F' .`];
        } 
        
        if (ele === 'rol' && ![1, 2, 3].includes(data[ele])) {
            error[ele] = [`This field must be 1 ,2 or 3`];
        } 

        if (ele === 'correo' && !validator.validate(data[ele])) {
            error[ele] = [`This field must be format email`];
        }

        if (validate[ele] !== typeof data[ele]) {
            error[ele] = [`This field must be an ${validate[ele]}`];
        }           
    }
}); 
return error;
};

const validateUser = (data) => {
  let is_superadmin = 0;
  let is_staff = 0;

  const error = validateObj(user, data);
  if (Object.keys(error).length >= 1) {
      throw new CustomError(error, 400);
  } else {
      switch (data.rol) {
      case 1:
          is_superadmin = 1;
          break;
      case 2:
          is_staff = 1;
          break;
      case 3:            
          break;
      }
      if(data.clave!=null){
          data.clave = bcrypt.hashSync(data.clave, 10);
      }
      

      return data;
  }
};

module.exports = validateUser;