const express = require("express");
const router  = express.Router();

const authenticate = require("../middlewares/auth");
const {
    getAllTests
} = require("../controllers/testController");

// O middleware "authenticate" roda antes do controller:
// sem token válido, a requisição nem chega em getAllTests
router.get("/", authenticate, getAllTests);

module.exports = router;
