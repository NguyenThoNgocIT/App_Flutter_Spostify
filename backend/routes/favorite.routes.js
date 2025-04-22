const express = require('express');
const router = express.Router();
const favoriteController = require('../controllers/favoriteController');

router.get('/', favoriteController.getAllFavorites);
router.get('/:userid', favoriteController.getFavoritesByUserId);// lấy favorites theo userid 
router.post('/', favoriteController.createFavorite);// tạo mới favorite
router.delete('/:id', favoriteController.deleteFavorite);// xóa favorite theo id
router.put('/:id', favoriteController.updateFavorite);// sửa favorite theo userid và songid 
// là mình truyền vào id của favorite cần sửa, còn userid và songid là mình truyền vào body
module.exports = router;
