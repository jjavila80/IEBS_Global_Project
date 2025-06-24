const express = require('express');
const router = express.Router();
const { getUsers, createUser } = require('../controllers/authController');
const { authenticate, isAdmin, validateUser } = require('../middlewares/authMiddleware');

router.get('/users', authenticate, isAdmin, getUsers);
router.post('/users', authenticate, isAdmin, validateUser, createUser);

module.exports = router;

