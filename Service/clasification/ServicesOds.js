const oracledb = require('oracledb');
const db = require('../../Settings/Database/database');

module.exports = {
    createOds: async(data) => {
        //data.ids = { type: oracledb.NUMBER, dir: oracledb.BIND_OUT, val:0};
        const options = {
            autoCommit: true,
            batchErrors: true,
            bindDefs: {
                report_id: { type: oracledb.NUMBER },
                ods_id: { type: oracledb.NUMBER },
                ids: { type: oracledb.NUMBER, dir: oracledb.BIND_OUT },
            }
        };
        const ods = await db.manyExecute(`INSERT INTO SAI_AUDITORIA_ODS(ODS_ID,REPORT_ID) 
        VALUES (:ods_id,:report_id) RETURNING id INTO :ids`, data, options);
        return ods;
    },
    deleteOds: async(ids) => {
        const result = await db.simpleExecute(`DELETE FROM SAI_AUDITORIA_ODS WHERE report_id= :ids `, [ids]);        
        return result;
    }
    ,
};

        