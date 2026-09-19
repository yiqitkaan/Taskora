module.exports = function logger(req, res, next) {
  const timestamp = new Date().toISOString().replace('T', ' ').slice(0, 19);
  console.log(`[${timestamp}] ${req.method} ${req.originalUrl}`);
  next();
};
