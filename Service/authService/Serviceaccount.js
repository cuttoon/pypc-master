const oracledb = require('oracledb');
const db = require('../../Settings/Database/database');

module.exports = {
    getUserbyEmail: async(email) => {
        const user = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_GENERIC_SELECT_EXECUTE(:sql_stmt,:cursor); END;`, {
            sql_stmt: `SELECT ID,EMAIL,PASSWORD,IS_ACTIVE,IS_SUPERADMIN,IS_STAFF,ROL_ID, FIRST_NAME AS NOMBRE FROM SAI_USUARIOS WHERE EMAIL='${email}'`,
            cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }
        });
        return user.cursor[0];
    }
}