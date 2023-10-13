const oracledb = require('oracledb');
const db = require('../../Settings/Database/database');



module.exports = {
    getallCategoria: async() => {
        const data = { cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }};
        const cursor = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_TEMAS(:cursor); END;`, data);
        return cursor.cursor;
    },
    getallTipoAuditoria: async() => {
        const data = { cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }};
        const cursor = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_TIPO_TEMAS(:cursor); END;`, data);
        return cursor.cursor;
    },
    getallODS: async() => {
        const data = { cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }};
        const cursor = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_ODS(:cursor); END;`, data);
        return cursor.cursor;
    },

    getallAmbito:async() => {
        const data = { cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }};
        const cursor = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_AMBITO(:cursor); END;`, data);
        return cursor.cursor;
    },
    getallPais:async() => {
        const data = { cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }};
        const cursor = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_PAIS(:cursor); END;`, data);
        return cursor.cursor;
    },
    getallParametro:async(req) => {
        const cursor = await db.procedureExecuteCursor(`BEGIN PG_SIE_CONSULTA.PA_SIE_GENERIC_SELECT_EXECUTE(:sql_stmt,:cursor); END;`, {
            sql_stmt: `SELECT CODE ID, VALUE_NAME  AS DESCRIPTION FROM SAI_PARAMETRO WHERE TABLE_NAME ='${req.params.table_name}' ORDER BY CODE `,
            cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }
        });

        return cursor.cursor;
    },
    getallIdiomas:async(req) => {
        const cursor = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_GENERIC_SELECT_EXECUTE(:sql_stmt,:cursor); END;`, {
            sql_stmt: `SELECT  ID, LANGUAGE_NAME  AS DESCRIPTION FROM SAI_IDIOMA  ORDER BY ID `,
            cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }
        });

        return cursor.cursor;
    },   
    
}

