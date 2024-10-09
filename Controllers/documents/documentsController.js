const userdb = require("../../Service/documents/ServiceDocuments");

module.exports = {
  getAllDocuments: async (req, res, next) => {
    try {
      const document = await userdb.getAllDocuments();
      res.send({ result: document });
    } catch (error) {
      res.status(500).send({ statusCode: 500, message: error.message });
    }
  },
  getDetail: async (req, res, next) => {
    try {
        console.log("detail", req.body)
      const document = await userdb.getDetail({ document_id: req.body.document_id });
      res.send({ result: document });
    } catch (error) {
      res.status(500).send({ statusCode: 500, message: error.message });
    }
  },
  getSimpleSearch: async (req, res, next) => {
    try {
      const document = await userdb.getSimpleSearch(req.body);
      res.send({ result: document });
    } catch (error) {
      res.status(500).send({ statusCode: 500, message: error.message });
    }
  },
  getAdvanceSearch: async (req, res, next) => {
    try {
      const document = await userdb.getAdvanceSearch(req.body);
      res.send({ result: document });
    } catch (error) {
      res.status(500).send({ statusCode: 500, message: error.message });
    }
  },
  postModelGraph: async (req, resp, next) => {
    try {
      const document = await userdb.postModelGraph(req.body);
      resp.send({ result: document });
    } catch (err) {
      resp.status(500).send({ statusCode: 500, message: err.message });
    }
  },
  postInteractionGraph: async (req, resp, next) => {
    try {
        console.log(req.body)
      const document = await userdb.postInteractionGraph(req.body);
      resp.send({ result: document });
    } catch (err) {
      resp.status(500).send({ statusCode: 500, message: err.message });
    }
  },
  postPhaseGraph: async (req, resp, next) => {
    try {
      const document = await userdb.postPhaseGraph(req.body);
      resp.send({ result: document });
    } catch (err) {
      resp.status(500).send({ statusCode: 500, message: err.message });
    }
  },
};
