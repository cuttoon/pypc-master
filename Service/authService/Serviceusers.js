const oracledb = require('oracledb');
const db = require('../../Settings/Database/database');

module.exports = {
    getAllUsers: async() => {
        const data = { cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }};
        const users = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_USUARIOS(:cursor); END;`, data);
        return users.cursor;
    },
    existEmail: async(email) => {
        const user = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_GENERIC_SELECT_EXECUTE(:sql_stmt,:cursor); END;`, {
            sql_stmt: `SELECT EMAIL FROM SAI_USUARIOS WHERE EMAIL='${email}'`,
            cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }
        });
        return user.cursor[0];
    },
    existEmailUpdate: async(email,ids) => {
        const user = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_GENERIC_SELECT_EXECUTE(:sql_stmt,:cursor); END;`, {
            sql_stmt: `SELECT EMAIL FROM SAI_USUARIOS WHERE EMAIL='${email}' AND ID!='${ids}'`,
            cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }
        });
        return user.cursor[0];
    },
    createUser: async(data) => {
        data.ids = { type: oracledb.NUMBER, dir: oracledb.BIND_OUT };
        const newEvent = await db.procedureExecute(`BEGIN PG_SAI_CONSULTA.PA_SAI_INSERT_USUARIO(
            :apellido,
            :correo,
            :sexo,
            :ids,
            :nombre,
            :pais,
            :clave,
            :rol
            ); END;`, data); 
        return newEvent.ids;    
    },
    updateUser: async(data) => {
        data.ids = { type: oracledb.NUMBER, dir: oracledb.BIND_INOUT ,val:data.ids};
        const newEvent = await db.procedureExecute(`BEGIN PG_SAI_CONSULTA.PA_SAI_UPDATE_USUARIO(
            :apellido,
            :correo,
            :sexo,
            :ids,
            :nombre,
            :pais,
            :clave,
            :rol); END;`, data); 
        return newEvent.ids;    
    }
}