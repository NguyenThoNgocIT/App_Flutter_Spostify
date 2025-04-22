const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');

router.post('/register', authController.register);
router.post('/login', authController.login);
router.get('/profile', authController.profile);
router.get('/users', authController.getAllUsers); // lấy tất cả users
router.get('/users/:id', authController.getUserById); // lấy user theo id
router.put('/users/:id', authController.updateUser); // cập nhật user theo id
router.delete('/users/:id', authController.deleteUser); // xóa user theo id


module.exports = router;
