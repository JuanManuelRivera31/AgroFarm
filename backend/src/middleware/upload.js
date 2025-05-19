const multer = require('multer');
const path = require('path');

// Configuración básica
const storage = multer.diskStorage({
  destination: 'uploads/', // Carpeta donde se guardan las imágenes
  filename: (req, file, cb) => {
    const uniqueName = Date.now() + path.extname(file.originalname); // ejemplo: 1716070000000.jpg
    cb(null, uniqueName);
  }
});

const upload = multer({ storage });

module.exports = upload;