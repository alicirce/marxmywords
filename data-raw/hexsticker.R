hexSticker::sticker(
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Karl_Marx_001.jpg/640px-Karl_Marx_001.jpg",
  package = "marxmywords",
  p_y = 0.5,
  p_color = "red",
  p_size = 15,
  p_fontface = "bold",
  h_color = "red",
  h_fill = "white",
  s_width = 1.6,
  s_y = 0,
  white_around_sticker = TRUE,
  filename = file.path("man", "figures", "marxsticker.png")
)
s <- magick::image_read(file.path("man", "figures", "marxsticker.png"))
s_tiny <- magick::image_scale(s, "150")
magick::image_write(
  s_tiny,
  path = file.path("man", "figures", "marxsticker_small.png"),
  format = "png"
)
