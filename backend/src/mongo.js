const mongoose = require('mongoose');

const connectToMongo = async () => {
  try {
    // URI de conexión local
    const uri = 'mongodb://localhost:27017/vacas';

    await mongoose.connect(uri, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });

    console.log('✅ Conectado a MongoDB en localhost:27017/vacas');
  } catch (error) {
    console.error('❌ Error al conectar a MongoDB:', error);
    process.exit(1); // Finaliza el proceso si falla la conexión
  }
};

module.exports = connectToMongo;
