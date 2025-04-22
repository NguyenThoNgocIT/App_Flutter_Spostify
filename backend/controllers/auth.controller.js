const supabase = require('../supabaseClient');

// Đăng ký
exports.register = async (req, res) => {
  const { email, password } = req.body;

  const { data, error } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });

  if (error) return res.status(400).json({ error: error.message });
  res.json({ message: 'User registered successfully', user: data.user });
};

// Đăng nhập
exports.login = async (req, res) => {
  const { email, password } = req.body;

  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) return res.status(401).json({ error: error.message });
  res.json({ message: 'Login successful', session: data });
};
// lấy tất cả users
exports.getAllUsers = async (req, res) => {
  const { data, error } = await supabase.from('Users').select('*');
  if (error) return res.status(400).json({ error });
  res.json(data);
};
// lấy user theo id
exports.getUserById = async (req, res) => {
  const { id } = req.params;
  const { data, error } = await supabase
    .from('Users')
    .select('*')
    .eq('id', id)
    .single();
  if (error) return res.status(400).json({ error });
  res.json(data);
};
// cập nhật user theo id
exports.updateUser = async (req, res) => {
  const { id } = req.params;
  const { email, password } = req.body;

  const { data, error } = await supabase
    .from('Users')
    .update({ email, password })
    .eq('id', id)
    .select('*')
    .single();

  if (error) return res.status(400).json({ error });
  res.json(data);
};
// xóa user theo id
exports.deleteUser = async (req, res) => {
  const { id } = req.params;

  const { error } = await supabase.from('Users').delete().eq('id', id);
  if (error) return res.status(400).json({ error });
  res.status(204).send();
};
// Đăng xuất
exports.logout = async (req, res) => {
  const token = req.headers.authorization?.replace('Bearer ', '');

  const { error } = await supabase.auth.signOut(token);
  if (error) return res.status(401).json({ error: error.message });

  res.json({ message: 'Logout successful' });
};
// Lấy profile từ access token
exports.profile = async (req, res) => {
  const token = req.headers.authorization?.replace('Bearer ', '');

  const { data, error } = await supabase.auth.getUser(token);
  if (error) return res.status(401).json({ error: error.message });

  res.json({ user: data.user });
};
