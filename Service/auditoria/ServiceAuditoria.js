const { parseJSON } = require('jquery');
const oracledb = require('oracledb');
const db = require('../../Settings/Database/database');
const { deleteDeclaracion, createDeclaracion } = require('../clasification/ServicesMoscu');
const { createOds, deleteOds } = require('../clasification/ServicesOds');
const { deleteTag, createTag, getTag, newTag } = require('../clasification/ServicesTag');
const { deleteParticipante, createParticipante } = require('../participant/ServiceParticipant');

const parseOds = (data, report) => {
    return data.map(ele => {
        ele.report_id = report;
        ele.ods_id = ele.ods_id ? parseInt(ele.ods_id) : ele.ods_id;
        //ele.organizacion_count = ele.organizacion_count ? parseInt(ele.organizacion_count) : ele.organizacion_count;
        //ele.pais_count = ele.pais_count ? parseInt(ele.pais_count) : ele.pais_count;
        return ele;
    });
};

const parseDeclaration = (data, report) => {
    return data.map(ele => {
        ele.report_id = report;
        ele.declaration_moscu_id = ele.declaration_moscu_id ? parseInt(ele.declaration_moscu_id) : ele.declaration_moscu_id;
        return ele;
    });
};

const parseTag = (data, report) => {
    return data.map(ele => {
        ele.report_id = report;
        ele.tag_id = ele.tag_id ? parseInt(ele.tag_id) : ele.tag_id;
        return ele;
    });
};

const parseParticipante = (data, report) => {
    return data.map(ele => {
        ele.report_id = report;
        ele.ambito_id = ele.ambito_id ? parseInt(ele.ambito_id) : ele.ambito_id;
        ele.entidad = ele.entidad ? ele.entidad.toString() : ele.entidad;
        ele.otro_id = ele.otro_id ? parseInt(ele.otro_id) : ele.otro_id;
        ele.pais_id = ele.pais_id ? parseInt(ele.pais_id) : ele.pais_id;
        ele.rol_id = ele.rol_id ? parseInt(ele.rol_id) : ele.rol_id;
        ele.tipo_id = ele.tipo_id ? parseInt(ele.tipo_id) : ele.tipo_id;
        //ele.participante_id = ele.participante_id ? parseInt(ele.participante_id) : ele.participante_id;
        //ele.organizacion_count = ele.organizacion_count ? parseInt(ele.organizacion_count) : ele.organizacion_count;
        //ele.pais_count = ele.pais_count ? parseInt(ele.pais_count) : ele.pais_count;
        return ele;
    });
};


module.exports = {
    getallAuditoria: async() => {
        const data = { cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }};
        const cursor = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_AUDITORIA(:cursor); END;`, data);
        return cursor.cursor;
    },
    getMore: async(data) => {
        data.cursor_a = { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
        data.cursor_o = { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
        data.cursor_m = { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
        data.cursor_p = { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };    
        data.cursor_i = { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };    
        const events = await db.procedureExecuteCursorsArray(`BEGIN PG_SAI_CONSULTA.PA_SAI_GET_DETALLE_AUDITORIA(:auditoria_id,:cursor_a,:cursor_o,:cursor_m,:cursor_p,:cursor_i); END;`, data);
        return { auditoria: events.cursor_a, ods: events.cursor_o, moscu: events.cursor_m, participante: events.cursor_p, informe: events.cursor_i };
    },
    getSimpleSearch: async(data) => {
        //data.buscar= { type: oracledb.STRING ,maxSize: 200};
        data.cursor= { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };

        // const data = { 
        //     buscar: { type: oracledb.STRING ,maxSize: 200},
        //     cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }
        // };

        const cursor = await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_GET_AUDITORIA_GENERAL(:buscar,:cursor); END;`, data);
        return cursor.cursor;
    },
    getAdvanceSearch: async(data) => {
        //data.buscar= { type: oracledb.STRING ,maxSize: 200};
        data.cursor= { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };

        // const data = { 
        //     buscar: { type: oracledb.STRING ,maxSize: 200},
        //     cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }
        // };
        

        const cursor =  await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_GET_AUDITORIA_ADVANCE(:idiomas,:ambito,:pais,:inicio,:fin,:tipo,:categoria,:ods,:moscu,:anio ,:cursor); END;`, data);
        return cursor.cursor;
    },

    getPolarGraph: async(data) => {

        data.cursor= { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
  

        const cursor =  await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_POLAR_GRAPH(:mes,:categoria,:ods,:tipo,:pais,:anio,:cursor); END;`, data);
        return cursor.cursor;
    },
    getDateGraph: async(data) => {

        data.cursor= { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
  

        const cursor =  await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_DATE_GRAPH(:ambito,:categoria,:ods,:tipo,:pais,:anio,:cursor); END;`, data);
        return cursor.cursor;
    },
    getCategoriesGraph: async(data) => {

        data.cursor= { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
  

        const cursor =  await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_CATEGORIES_GRAPH(:ambito,:mes,:ods,:tipo,:pais,:anio,:cursor); END;`, data);
        return cursor.cursor;
    },
    getOdsGraph: async(data) => {

        data.cursor= { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
  

        const cursor =  await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_ODS_GRAPH(:ambito,:mes,:categoria,:tipo,:pais,:anio,:cursor); END;`, data);
        return cursor.cursor;
    },
    getTypeReportGraph: async(data) => {

        data.cursor= { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
  

        const cursor =  await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_TYPE_REPORT_GRAPH(:ambito,:mes,:categoria,:ods,:pais,:anio,:cursor); END;`, data);
        return cursor.cursor;
    },
    getCountryGraph: async(data) => {

        data.cursor= { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
  

        const cursor =  await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_COUNTRY_GRAPH(:ambito,:mes,:categoria,:tipo,:ods,:anio,:cursor); END;`, data);
        return cursor.cursor;
    },
    getauditlist: async(data) => {

        data.cursor= { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
  

        const cursor =  await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_AUDIT_LIST(:usuario,:estado,:cursor); END;`, data);
        return cursor.cursor;
    },
    getlistreasons: async(data) => {
    
        data.cursor= { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
    
        const cursor =  await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_LIST_OF_REASONS(:ids,:cursor); END;`, data);
        return cursor.cursor;
    },
    getlistusers: async(data) => {
        data.cursor= { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
    
        const cursor =  await db.procedureExecuteCursor(`BEGIN PG_SAI_CONSULTA.PA_SAI_LIST_USERS(:ids,:cursor); END;`, data);
        return cursor.cursor;
    },
    getTags: async() => {
        const tags_= await getTag();
        const result = {
            tags: tags_
        };
        return result;
    },
    newTags: async(data) => {
        const tags_= await newTag(data);
        const result = {
            tags: tags_
        };
        return result;
    }, 
    newobservation: async(data) => {
        var element =[]
       element.push({
        report_id :data.report_id ,
        motivo : data.motivo
       });

        const options =     {
            autoCommit: true,
            batchErrors: true,
            bindDefs: {
                report_id: { type: oracledb.NUMBER },
                motivo: { type: oracledb.STRING, maxSize: 255 },
                ids: { type: oracledb.NUMBER , dir: oracledb.BIND_OUT }
            }
        };
        const observation = await db.manyExecute(`INSERT INTO SAI_OBSERVACION(report_id, motivo)
         VALUES (:report_id,:motivo) RETURNING ID INTO :ids `, element, options);

        return observation;
    }, 
    createParticipants: async(data)=> {
        let _participante = await deleteParticipante(data.report_id);
        const participante_ = await createParticipante(parseParticipante(data.participante,data.report_id));

        
        //console.log(addEventIdToExponents(exponents.outBinds, data.evento_id));
        const result = {
            participante: participante_
        };
        return result;
    },
    updatestatusaudit: async(data) => {
        
        //data.cursor_p = { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
        data.ids = { type: oracledb.NUMBER, dir: oracledb.BIND_INOUT ,val:data.ids};
         
        const events = await db.procedureExecute(`BEGIN PG_SAI_CONSULTA.PA_SAI_UPDATE_STATUS_AUDITORIA(:ids,:status,:usuario); END;`, data);
        return events.ids;    
    },
    getParticipants: async(data) => {
        data.cursor_p = { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
         
        const events = await db.procedureExecuteCursorsArray(`BEGIN PG_SAI_CONSULTA.PA_SAI_GET_PARTICIPANTES(:auditoria_id,:cursor_p); END;`, data);
        return {  participante: events.cursor_p};
    },
    createClasification: async(data)=> {
        let _ods = await deleteOds(data.report_id);
        const ods_ = await createOds(parseOds(data.ods,data.report_id));

        //const exponents = await createExponents(data.expositores);

        let _declaration = await deleteDeclaracion(data.report_id);
        const declaration_ = await createDeclaracion(parseDeclaration(data.moscu, data.report_id));

        let _tag = await deleteTag(data.report_id);
        const tag_ = await createTag(parseTag(data.tag,data.report_id));

        //console.log(addEventIdToExponents(exponents.outBinds, data.evento_id));
        const result = {
            ods: ods_,
            declaration: declaration_,
            tag: tag_
        };
        return result;
    },
    getClasification: async(data) => {
        data.cursor_o = { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };
        data.cursor_m = { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };    
        data.cursor_t = { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };    
        const events = await db.procedureExecuteCursorsArray(`BEGIN PG_SAI_CONSULTA.PA_SAI_GET_CLASIFICACIONES(:auditoria_id,:cursor_o,:cursor_m,:cursor_t); END;`, data);
        return { ods: events.cursor_o, moscu: events.cursor_m, tag: events.cursor_t};
    },
    
    createInforme: async(data) => {

        if ( isNaN(data.ids))
            data.ids = { type: oracledb.NUMBER, dir: oracledb.BIND_INOUT};
        else
            data.ids = { type: oracledb.NUMBER, dir: oracledb.BIND_INOUT, val: parseInt(data.ids) };


        const newEvent = await db.procedureExecute(`BEGIN PG_SAI_CONSULTA.PAI_SAI_INSERT_REPORT(
            :publicacion,
            :idioma,
            :ids,
            :imagen,
            :informe,
            :pais,
            :report,
            :url       
            ); END;`, data); 
            // :ffin,
            // :fini,
        return newEvent.ids;  

    },
    createPractica: async(data) => {
        //data.ids = { type: oracledb.NUMBER, dir: oracledb.BIND_OUT};
        // const options = {
        //     autoCommit: true,
        //     batchErrors: true,
        //     bindDefs: {
        //         estado: { type: oracledb.STRING , maxSize: 200 },
        //         argumento: { type: oracledb.STRING , maxSize: 200 },
        //         detalle: { type: oracledb.STRING , maxSize: 200 },
        //         nivel: { type: oracledb.STRING , maxSize: 200 },
        //         reporte: { type: oracledb.NUMBER },
        //         nombre: { type: oracledb.STRING, maxSize: 200 }//, 
        //         //ids : { type: oracledb.NUMBER, dir: oracledb.BIND_INOUT}
        //     }
        // };
        if ( isNaN(data.ids))
            data.ids = { type: oracledb.NUMBER, dir: oracledb.BIND_INOUT};
        else
            data.ids = { type: oracledb.NUMBER, dir: oracledb.BIND_INOUT, val: parseInt(data.ids) };


    const practica = await db.procedureExecute(`BEGIN PG_SAI_CONSULTA.PAI_SAI_INSERT_PRACTICE(
        :argumento,
        :detalle,
        :estado,
        :ids,
        :nivel,
        :nombre,
        :reporte
        ); END;`, data); 
        //const practica = await db.manyExecute(`INSERT INTO SAI_PRACTICA(ACTIVO, CONTEXTO,DESCRIPCION,ETAPA,REPORT_ID,TITULO) VALUES (:estado,:argumento,:detalle,:nivel,:reporte,:nombre) RETURNING ID INTO :ids`, data, options);
        return practica.ids; 
    },
    createAuditoria: async(data) => {
        data.ids = { type: oracledb.NUMBER, dir: oracledb.BIND_OUT };
        const newEvent = await db.procedureExecute(`BEGIN PG_SAI_CONSULTA.PAI_SAI_INSERT_AUDITORIA(
            :categoria,
            :ffin,
            :fini,
            :ids,
            :imagen,
            :objetivo,
            :resumen,
            :tipo,
            :titulo,
            :usuario            
            ); END;`, data); 
            // :ffin,
            // :fini,
        return newEvent.ids;    
    },

    updateAuditoria: async(data) => {
        data.ids = { type: oracledb.NUMBER, dir: oracledb.BIND_INOUT ,val:data.ids};
        const newEvent = await db.procedureExecute(`BEGIN PG_SAI_CONSULTA.PAI_SAI_UPDATE_AUDITORIA(
            :categoria,
            :ffin,
            :fini,
            :ids,
            :imagen,
            :objetivo,
            :resumen,
            :tipo,
            :titulo,
            :usuario            
            ); END;`, data);
        return newEvent.ids;    
    }
}