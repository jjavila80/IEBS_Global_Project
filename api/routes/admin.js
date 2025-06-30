const express = require('express');
const router = express.Router();
const { getUsers, createUser } = require('../controllers/authController');
const { authenticate, isAdmin, validateUser } = require('../middlewares/authMiddleware');
const mapRolToRole = require('../middlewares/mapRolToRole');

router.get('/users', authenticate, mapRolToRole, isAdmin, getUsers);
router.post('/users', authenticate, mapRolToRole, isAdmin, validateUser, createUser);

module.exports = router;

