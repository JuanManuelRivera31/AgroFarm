const mongoose = require('mongoose');

const imageSchema = new mongoose.Schema({
  imagePath: String,
  idVaca: {
    type: String,
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Image', imageSchema);
