components {
  id: "hud_bar"
  component: "/main/hud/hud_bar.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"health_bar\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/hud/hud.atlas\"\n"
  "}\n"
  ""
}
