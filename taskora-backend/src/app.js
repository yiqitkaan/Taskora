const express = require('express');
const logger = require('./middleware/logger');
const taskRoutes = require('./routes/taskRoutes');

const app = express();
const port = process.env.PORT || 3000;

app.use(logger);
app.use(express.json());
app.use('/tasks', taskRoutes);

app.use((req, res) => res.status(404).json({ error: 'Endpoint bulunamadı.' }));

app.use((error, req, res, next) => {
  if (error instanceof SyntaxError && error.status === 400 && 'body' in error) {
    return res.status(400).json({ error: 'Geçersiz JSON gövdesi.' });
  }
  console.error(error);
  res.status(500).json({ error: 'Sunucu hatası.' });
});

app.listen(port, () => console.log(`Taskora API http://localhost:${port} adresinde çalışıyor.`));
