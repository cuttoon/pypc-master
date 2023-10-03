const oracledb = require('oracledb');
const db = require('../../Settings/Database/database');

module.exports = {
    createTag: async(data) => {
        const options =     {
            autoCommit: true,
            batchErrors: true,
            bindDefs: {
                report_id: { type: oracledb.NUMBER },
                tag_id: { type: oracledb.NUMBER },              
                ids: { type: oracledb.NUMBER, dir: oracledb.BIND_OUT },
            }
        };
        const ods = await db.manyExecute(`INSERT INTO SAI_AUDITORIA_TAG(REPORT_ID,TAG_ID) 
        VALUES (:report_id,:tag_id) RETURNING id INTO :ids`, data, options);
        return ods;
    },
    deleteTag: async(ids) => {
        const result = await db.simpleExecute(`DELETE FROM SAI_AUDITORIA_TAG WHERE report_id= :ids `, [ids]);        
        return result;
    }
    ,
    getTag:async(req) => {
        const cursor = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_GENERIC_SELECT_EXECUTE(:sql_stmt,:cursor); END;`, {
            sql_stmt: `SELECT ID, NAME, NORMALIZED  AS DESCRIPTION FROM SAI_TAG ORDER BY ID `,
            cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }
        });

        return cursor.cursor;
    },
    

    newTag: async(data) => {
        var element =[]
       element.push({
        nombre :data.nombre ,
        normalizado : data.normalizado
       });

        const options =     {
            autoCommit: true,
            batchErrors: true,
            bindDefs: {
                nombre: { type: oracledb.STRING, maxSize: 255 },
                normalizado: { type: oracledb.STRING, maxSize: 255 },
                ids: { type: oracledb.NUMBER , dir: oracledb.BIND_OUT }
            }
        };
        const tag = await db.manyExecute(`INSERT INTO SAI_TAG(NAME, NORMALIZED)
         VALUES (:nombre,:normalizado) RETURNING ID INTO :ids `, element, options);

        return tag;
    },
};
