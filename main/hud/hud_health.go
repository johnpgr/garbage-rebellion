components {
  id: "hud_health"
  component: "/main/hud/hud_health.script"
}
embedded_components {
  id: "label"
  type: "label"
  data: "size {\n"
  "  x: 180.0\n"
  "  y: 32.0\n"
  "}\n"
  "text: \"o NORMAL\"\n"
  "font: \"/assets/fonts/pixel.font\"\n"
  "material: \"/builtins/fonts/label.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  "line_break: false\n"
  "leading: 1.0\n"
  "tracking: 0.0\n"
  "pivot: PIVOT_W\n"
  ""
}
