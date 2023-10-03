const oracledb = require('oracledb');
const db = require('../../Settings/Database/database');

module.exports = {
    createParticipante: async(data) => {
        const options = {
            autoCommit: true,
            batchErrors: true,
            bindDefs: {
                report_id: { type: oracledb.NUMBER },
                ambito_id: { type: oracledb.NUMBER },              
                pais_id: { type: oracledb.NUMBER },              
                entidad: { type: oracledb.STRING ,maxSize:150},
                otro_id: { type: oracledb.NUMBER },              
                rol_id: { type: oracledb.NUMBER },              
                tipo_id: { type: oracledb.NUMBER },              
                ids: { type: oracledb.NUMBER , dir: oracledb.BIND_OUT}
            }

                
            
        };
        //const participante = await db.bacherExecute(`INSERT INTO SAI_PARTICIPANTE(REPORT_ID, AMBITO_ID, PAIS_ID, ENTIDAD, OTRO_ID, ROL_ID) 
        const participante = await db.manyExecute(`INSERT INTO SAI_PARTICIPANTE(REPORT_ID, AMBITO_ID, PAIS_ID, ENTIDAD, OTRO_ID, ROL_ID, TIPO_ENTIDAD_ID) 
        VALUES (:report_id,:ambito_id,:pais_id,:entidad,:otro_id,:rol_id, :tipo_id) RETURNING ID INTO :ids`, data, options);
        return participante;
    },
    deleteParticipante: async(ids) => {
        const result = await db.simpleExecute(`DELETE FROM SAI_PARTICIPANTE WHERE report_id= :ids `, [ids]);        
        return result;
    }
    ,
};

        