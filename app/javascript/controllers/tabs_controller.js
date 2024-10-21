import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "content"]

  connect() {
    this.selectTab(this.element.dataset.tabsDefaultValue || this.triggerTargets[0].dataset.value)
    this.addKeyboardListeners()
  }

  disconnect() {
    this.removeKeyboardListeners()
  }

  select(event) {
    event.preventDefault()
    this.selectTab(event.currentTarget.dataset.value)
  }

  selectTab(value) {
    const activeIndex = this.triggerTargets.findIndex(trigger => trigger.dataset.value === value)
    
    this.triggerTargets.forEach((trigger, index) => {
      const isActive = trigger.dataset.value === value
      trigger.dataset.state = isActive ? "active" : "inactive"
      trigger.setAttribute("aria-selected", isActive)
      trigger.setAttribute("tabindex", isActive ? 0 : -1)
    })

    this.contentTargets.forEach((content) => {
      const isActive = content.dataset.value === value
      content.dataset.state = isActive ? "active" : "inactive"
      content.hidden = !isActive
    })

    this.activeIndex = activeIndex
  }

  handleKeydown(event) {
    if (!["ArrowLeft", "ArrowRight", "Home", "End"].includes(event.key)) return

    event.preventDefault()
    const triggers = this.triggerTargets
    let newIndex = this.activeIndex

    switch (event.key) {
      case "ArrowLeft":
        newIndex = (this.activeIndex - 1 + triggers.length) % triggers.length
        break
      case "ArrowRight":
        newIndex = (this.activeIndex + 1) % triggers.length
        break
      case "Home":
        newIndex = 0
        break
      case "End":
        newIndex = triggers.length - 1
        break
    }

    this.selectTab(triggers[newIndex].dataset.value)
    triggers[newIndex].focus()
  }

  addKeyboardListeners() {
    this.boundHandleKeydown = this.handleKeydown.bind(this)
    this.element.addEventListener("keydown", this.boundHandleKeydown)
  }

  removeKeyboardListeners() {
    this.element.removeEventListener("keydown", this.boundHandleKeydown)
  }
}
