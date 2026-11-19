const prisma = require("../database/prisma");

async function getOperatorByFirebaseUid(firebaseUid) {
    return await prisma.operator.findUnique({
        where: {
            firebaseUid
        }
    });
};

async function updateLastAccess(id) {
    return await prisma.operator.update({
        where: {
            id
        },
        data: {
            lastAccessAt: new Date()
        }
    });
};

module.exports = {
    getOperatorByFirebaseUid,
    updateLastAccess
};
