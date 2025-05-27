const supabase = require("../supabaseClient");

// Lấy tất cả podcast
exports.getPodcasts = async (req, res) => {
  const { data, error } = await supabase
    .from("Podcasts")
    .select("*")
    .order("releasedate", { ascending: false });
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
};
