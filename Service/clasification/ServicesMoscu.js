const oracledb = require('oracledb');
const db = require('../../Settings/Database/database');

module.exports = {
    createDeclaracion: async(data) => {
        const options = {
            autoCommit: true,
            batchErrors: true,
            bindDefs: {
                report_id: { type: oracledb.NUMBER },
                declaration_moscu_id: { type: oracledb.NUMBER },              
                ids: { type: oracledb.NUMBER, dir: oracledb.BIND_OUT },
            }
        };
        const ods = await db.manyExecute(`INSERT INTO SAI_AUDITORIA_MOSCU(REPORT_ID,DECLARATION_MOSCU_ID) 
        VALUES (:report_id,:declaration_moscu_id) RETURNING id INTO :ids`, data, options);
        return ods;
    },
    deleteDeclaracion: async(ids) => {
        const result = await db.simpleExecute(`DELETE FROM SAI_AUDITORIA_MOSCU WHERE report_id= :ids `, [ids]);        
        return result;
    }
    ,
};

  