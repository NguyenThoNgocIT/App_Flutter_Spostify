const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const songRoutes = require('./routes/song.routes');
app.use('/api/songs', songRoutes);
app.use('/api/auth', require('./routes/auth.routes'));
app.use('/api/favorites', require('./routes/favorite.routes'));
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
