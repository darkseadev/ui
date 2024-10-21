import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "content", "trigger"]

  connect() {
    this.closeAllMenus()
    this.menuOpen = false
  }

  toggleMenu(event) {
    const menu = event.currentTarget.closest("[data-menubar-target='menu']")
    const content = menu.querySelector("[data-menubar-target='content']")

    if (content.classList.contains("hidden")) {
      this.closeAllMenus()
      this.openMenu(menu)
      this.menuOpen = true
    } else {
      this.closeMenu(menu)
      this.menuOpen = false
    }
  }

  showMenuOnHover(event) {
    if (this.menuOpen) {
      const menu = event.currentTarget.closest("[data-menubar-target='menu']")
      this.closeAllMenus()
      this.openMenu(menu)
    }
  }

  openMenu(menu) {
    const trigger = menu.querySelector("[data-menubar-target='trigger']")
    const content = menu.querySelector("[data-menubar-target='content']")
    content.classList.remove("hidden")
    trigger.setAttribute("data-state", "open")
    this.positionContent(content, trigger)
  }

  positionContent(content, trigger) {
    const triggerRect = trigger.getBoundingClientRect()
    const menubarRect = this.element.getBoundingClientRect()
    
    content.style.top = `${triggerRect.bottom - menubarRect.top}px`
  }

  selectItem(event) {
    const menu = event.target.closest("[data-menubar-target='menu']")
    this.closeMenu(menu)
    this.menuOpen = false
  }

  closeAllMenus() {
    this.menuTargets.forEach(menu => this.closeMenu(menu))
  }

  closeMenu(menu) {
    const trigger = menu.querySelector("[data-menubar-target='trigger']")
    const content = menu.querySelector("[data-menubar-target='content']")
    content.classList.add("hidden")
    trigger.removeAttribute("data-state")
  }
}
