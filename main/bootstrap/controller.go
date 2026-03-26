components {
  id: "controller"
  component: "/main/bootstrap/controller.script"
}
embedded_components {
  id: "menu_proxy"
  type: "collectionproxy"
  data: "collection: \"/main/menu/menu.collection\"\n"
  ""
}
embedded_components {
  id: "game_proxy"
  type: "collectionproxy"
  data: "collection: \"/main/main.collection\"\n"
  ""
}
