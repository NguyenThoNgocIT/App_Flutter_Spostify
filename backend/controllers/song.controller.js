const supabase = require('../supabaseClient');

exports.getSongs = async (req, res) => {
  const { data, error } = await supabase.from('Songs').select('*');
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
};
