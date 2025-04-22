const supabase = require('../supabaseClient');

// Lấy tất cả favorites
exports.getAllFavorites = async (req, res) => {
  const { data, error } = await supabase.from('Favorites').select('*');
  if (error) return res.status(400).json({ error });
  res.json(data);
};

// Lấy favorites theo userid
exports.getFavoritesByUserId = async (req, res) => {
  const { userid } = req.params;
  const { data, error } = await supabase
    .from('Favorites')
    .select('*')
    .eq('userid', userid);
  if (error) return res.status(400).json({ error });
  res.json(data);
};

// Tạo mới favorite
exports.createFavorite = async (req, res) => {
  const { userid, songid } = req.body;
  const { data, error } = await supabase
    .from('Favorites')
    .insert([{ userid, songid }])
    .select('*');
  if (error) return res.status(400).json({ error });
  res.status(201).json(data);
};

// Xóa favorite theo id
exports.deleteFavorite = async (req, res) => {
  const { id } = req.params;
  const { error } = await supabase.from('Favorites').delete().eq('id', id);
  if (error) return res.status(400).json({ error });
  res.status(204).send();
};
// sửa favorite theo userid và songid
exports.updateFavorite = async (req, res) => {
  const { userid, songid } = req.body;
  const { id } = req.params;
  const { data, error } = await supabase
    .from('Favorites')
    .update({ userid, songid })
    .eq('id', id)
    .select('*')
    .single();
  if (error) return res.status(400).json({ error });
  res.json(data);
};