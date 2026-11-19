// Seed de desenvolvimento: cria um provedor e um operador ADMIN de teste
// para conseguirmos testar o login.
// O usuário do operador é criado no Firebase Auth (é lá que fica a senha)
// e o operador no nosso banco é ligado a ele pelo firebase_uid.
// Pode rodar mais de uma vez: reaproveita o usuário do Firebase e o
// upsert não duplica os registros.
require("dotenv").config();

const prisma = require("../src/database/prisma");
const { getFirebaseAuth } = require("../src/config/firebase");

// Busca o usuário no Firebase pelo e-mail; se não existir, cria
async function getOrCreateFirebaseUser(email, password, displayName) {
    const auth = getFirebaseAuth();

    try {
        return await auth.getUserByEmail(email);
    } catch (error) {
        if (error.code !== "auth/user-not-found") {
            throw error;
        }

        return await auth.createUser({ email, password, displayName });
    }
}

async function main() {
    const provider = await prisma.provider.upsert({
        where: {
            cnpj: "00000000000191"
        },
        update: {},
        create: {
            name:     "Provedor Teste",
            cnpj:     "00000000000191",
            ipRanges: ["192.168.0.0/16"]
        }
    });

    const email    = process.env.SEED_ADMIN_EMAIL    || "admin@provedorteste.com";
    const password = process.env.SEED_ADMIN_PASSWORD || "admin123";
    const name     = "Administrador Teste";

    const firebaseUser = await getOrCreateFirebaseUser(email, password, name);

    const operator = await prisma.operator.upsert({
        where: {
            login: email
        },
        update: {
            firebaseUid: firebaseUser.uid
        },
        create: {
            providerId:  provider.id,
            name,
            login:       email,
            firebaseUid: firebaseUser.uid,
            accessLevel: "ADMIN"
        }
    });

    console.log(`Provedor: ${provider.name} (id ${provider.id})`);
    console.log(`Operador: login "${operator.login}" (id ${operator.id}, firebase_uid ${operator.firebaseUid})`);
}

main()
    .catch((error) => {
        console.error("Erro ao rodar o seed: ", error);
        process.exitCode = 1;
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
