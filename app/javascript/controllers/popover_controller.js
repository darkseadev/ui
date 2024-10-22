import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  connect() {
    this.visible = false
    this.clickOutsideHandler = this.hide.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this.clickOutsideHandler)
  }

  toggle() {
    this.visible ? this.hide() : this.show()
  }

  show() {
    this.contentTarget.classList.remove('hidden')
    this.contentTarget.setAttribute("data-state", "open")
    this.visible = true
    document.addEventListener("click", this.clickOutsideHandler)
  }

  hide(event) {
    if (event && (this.element.contains(event.target) || this.contentTarget.contains(event.target))) {
      return
    }
    this.contentTarget.setAttribute("data-state", "closed")
    this.visible = false
    document.removeEventListener("click", this.clickOutsideHandler)
    // Add a delay to add the 'hidden' class after the animation completes
    setTimeout(() => {
      if (!this.visible) {
        this.contentTarget.classList.add('hidden')
      }
    }, 200) // This should match the duration of your fade-out animation
  }
}
