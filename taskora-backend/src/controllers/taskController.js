const fs = require('node:fs');
const path = require('node:path');

const dataFile = path.join(__dirname, '..', 'data', 'tasks.json');
const validStatuses = ['pending', 'in_progress', 'completed'];
const validPriorities = ['low', 'medium', 'high'];
const editableFields = ['title', 'description', 'status', 'priority', 'assignee', 'projectId'];

function readTasks() {
  const tasks = JSON.parse(fs.readFileSync(dataFile, 'utf8'));
  if (!Array.isArray(tasks)) throw new Error('Görev verisi bir dizi olmalıdır.');
  return tasks;
}

function writeTasks(tasks) {
  const temporaryFile = `${dataFile}.${process.pid}.tmp`;
  try {
    fs.writeFileSync(temporaryFile, `${JSON.stringify(tasks, null, 2)}\n`, 'utf8');
    fs.renameSync(temporaryFile, dataFile);
  } finally {
    if (fs.existsSync(temporaryFile)) fs.unlinkSync(temporaryFile);
  }
}

function parseId(value) {
  if (!/^[1-9]\d*$/.test(value)) return null;
  const id = Number(value);
  return Number.isSafeInteger(id) ? id : null;
}

function validateTask(body, isCreate) {
  if (!body || typeof body !== 'object' || Array.isArray(body)) {
    return 'İstek gövdesi bir JSON nesnesi olmalıdır.';
  }
  for (const field of Object.keys(body)) {
    if (!editableFields.includes(field)) return `${field} alanı değiştirilemez.`;
  }
  if (isCreate) {
    for (const field of ['title', 'status', 'priority', 'assignee']) {
      if (body[field] === undefined || body[field] === null || body[field] === '') {
        return `${field} alanı zorunludur.`;
      }
    }
  } else if (Object.keys(body).length === 0) {
    return 'Güncellenecek en az bir alan gönderilmelidir.';
  }
  for (const field of ['title', 'assignee']) {
    if (field in body && (typeof body[field] !== 'string' || !body[field].trim())) {
      return `${field} boş olmayan bir metin olmalıdır.`;
    }
  }
  if ('description' in body && typeof body.description !== 'string') {
    return 'description metin olmalıdır.';
  }
  if ('status' in body && !validStatuses.includes(body.status)) {
    return `status şu değerlerden biri olmalıdır: ${validStatuses.join(', ')}.`;
  }
  if ('priority' in body && !validPriorities.includes(body.priority)) {
    return `priority şu değerlerden biri olmalıdır: ${validPriorities.join(', ')}.`;
  }
  if ('projectId' in body && (!Number.isSafeInteger(body.projectId) || body.projectId < 1)) {
    return 'projectId pozitif bir tam sayı olmalıdır.';
  }
  return null;
}

exports.listTasks = (req, res, next) => {
  try {
    let tasks = readTasks();
    if (req.query.status) tasks = tasks.filter(task => task.status === req.query.status);
    if (req.query.priority) tasks = tasks.filter(task => task.priority === req.query.priority);
    res.json(tasks);
  } catch (error) { next(error); }
};

exports.getTask = (req, res, next) => {
  const id = parseId(req.params.id);
  if (id === null) return res.status(400).json({ error: 'Geçersiz görev ID.' });
  try {
    const task = readTasks().find(item => item.id === id);
    if (!task) return res.status(404).json({ error: 'Görev bulunamadı.' });
    res.json(task);
  } catch (error) { next(error); }
};

exports.createTask = (req, res, next) => {
  const validationError = validateTask(req.body, true);
  if (validationError) return res.status(400).json({ error: validationError });
  try {
    const tasks = readTasks();
    const now = new Date().toISOString();
    const task = {
      id: Math.max(0, ...tasks.map(item => item.id)) + 1,
      title: req.body.title.trim(),
      description: req.body.description || '',
      status: req.body.status,
      priority: req.body.priority,
      assignee: req.body.assignee.trim(),
      projectId: req.body.projectId ?? null,
      createdAt: now,
      updatedAt: now
    };
    tasks.push(task);
    writeTasks(tasks);
    res.status(201).json(task);
  } catch (error) { next(error); }
};

exports.updateTask = (req, res, next) => {
  const id = parseId(req.params.id);
  if (id === null) return res.status(400).json({ error: 'Geçersiz görev ID.' });
  const validationError = validateTask(req.body, false);
  if (validationError) return res.status(400).json({ error: validationError });
  try {
    const tasks = readTasks();
    const task = tasks.find(item => item.id === id);
    if (!task) return res.status(404).json({ error: 'Görev bulunamadı.' });
    for (const field of Object.keys(req.body)) {
      task[field] = ['title', 'assignee'].includes(field) ? req.body[field].trim() : req.body[field];
    }
    task.updatedAt = new Date().toISOString();
    writeTasks(tasks);
    res.json(task);
  } catch (error) { next(error); }
};

exports.deleteTask = (req, res, next) => {
  const id = parseId(req.params.id);
  if (id === null) return res.status(400).json({ error: 'Geçersiz görev ID.' });
  try {
    const tasks = readTasks();
    const index = tasks.findIndex(item => item.id === id);
    if (index === -1) return res.status(404).json({ error: 'Görev bulunamadı.' });
    tasks.splice(index, 1);
    writeTasks(tasks);
    res.json({ message: 'Görev başarıyla silindi.' });
  } catch (error) { next(error); }
};
