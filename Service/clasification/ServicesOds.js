const oracledb = require('oracledb');
const db = require('../../Settings/Database/database');

module.exports = {
    createOds: async(data) => {
        const options = {
            autoCommit: true,
            batchErrors: true,
        };
        const ods = {
            ods_id: data.ods_id,
            report_id: data.report_id,
        };

        const insertedOds = await db.insertRow('SCAI_AUDITORIA_ODS', ods, options);
        return insertedOds;
    },
    deleteOds: async(ids) => {
        const options = {
            autoCommit: true,
            batchErrors: true,
        };
        const whereClause = `report_id= :ids`;
        const parameters = [ids];
        const result = await db.deleteRow('SCAI_AUDITORIA_ODS', whereClause, options);
        return result;
    },
};

        