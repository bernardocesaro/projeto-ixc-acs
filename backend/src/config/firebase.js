// Inicializa o Firebase Admin SDK, usado pelo backend para validar
// os tokens de login dos operadores e criar usuários (seed).
// As credenciais vêm da conta de serviço do projeto Firebase
// (Configurações do projeto > Contas de serviço > Gerar nova chave privada).
const { initializeApp, cert, getApps } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");

function getFirebaseAuth() {
    // Inicializa só na primeira chamada: assim a API sobe mesmo sem
    // as variáveis do Firebase (ex.: para testar a rota /health)
    if (getApps().length === 0) {
        const { FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL, FIREBASE_PRIVATE_KEY } = process.env;

        if (!FIREBASE_PROJECT_ID || !FIREBASE_CLIENT_EMAIL || !FIREBASE_PRIVATE_KEY) {
            throw new Error(
                "Firebase não configurado: defina FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL e FIREBASE_PRIVATE_KEY no .env"
            );
        }

        initializeApp({
            credential: cert({
                projectId:   FIREBASE_PROJECT_ID,
                clientEmail: FIREBASE_CLIENT_EMAIL,
                // No .env a chave fica em uma linha só, com "\n" escrito;
                // aqui trocamos de volta por quebras de linha reais
                privateKey:  FIREBASE_PRIVATE_KEY.replace(/\\n/g, "\n")
            })
        });
    }

    return getAuth();
}

module.exports = {
    getFirebaseAuth
};
