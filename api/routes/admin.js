const express = require('express');
const router = express.Router();
const { getUsers, createUser } = require('../controllers/authController');
const { authenticate, isAdmin } = require('../middlewares/authMiddleware');

router.get('/users', authenticate, isAdmin, getUsers);
router.post('/users', authenticate, isAdmin, createUser);

module.exports = router;

