components {
  id: "game"
  component: "/main/game/game.script"
}
embedded_components {
  id: "enemy_factory"
  type: "factory"
  data: "prototype: \"/main/enemy/enemy.go\"\n"
  ""
}
embedded_components {
  id: "wall_factory"
  type: "factory"
  data: "prototype: \"/main/debug_box/debug_box.go\"\n"
  ""
}
