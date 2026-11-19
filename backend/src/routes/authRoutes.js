const express = require("express");
const router  = express.Router();

const authenticate = require("../middlewares/auth");
const {
    loginOperator
} = require("../controllers/authController");

// Registro do login do operador no dashboard web.
// O login em si (e-mail e senha) é feito no Firebase pelo front;
// o "authenticate" valida o token do Firebase antes do controller.
router.post("/operator", authenticate, loginOperator);

module.exports = router;
