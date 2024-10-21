import { application } from "./application"

import SelectController from "./select_controller"
application.register("select", SelectController)

import TabsController from "./tabs_controller"
application.register("tabs", TabsController)

import MenubarController from "./menubar_controller"
application.register("menubar", MenubarController)
