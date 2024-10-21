import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "triggerText", "item"]

  connect() {
    this.open = false
    document.addEventListener("click", this.outsideClick.bind(this))
    this.updateUI()
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClick.bind(this))
  }

  toggle(event) {
    event.preventDefault()
    this.open = !this.open
    this.updateUI()
  }

  select(event) {
    event.preventDefault()
    event.stopPropagation()
    const selectedValue = event.currentTarget.dataset.value
    if (this.hasTriggerTextTarget) {
      this.triggerTextTarget.textContent = event.currentTarget.textContent
    }
    this.element.setAttribute("data-value", selectedValue)
    
    const hiddenInput = this.element.querySelector('input[type="hidden"]')
    if (hiddenInput) {
      hiddenInput.value = selectedValue
    }
    
    this.updateSelectedItem(selectedValue)
    
    this.open = false
    this.updateUI()
  }

  updateUI() {
    if (this.open) {
      this.contentTarget.classList.remove('hidden')
    } else {
      this.contentTarget.classList.add('hidden')
    }
  }

  updateSelectedItem(selectedValue) {
    this.itemTargets.forEach(item => {
      const checkIcon = item.querySelector('svg')
      if (item.dataset.value === selectedValue) {
        checkIcon.classList.remove('hidden')
      } else {
        checkIcon.classList.add('hidden')
      }
    })
  }

  outsideClick(event) {
    if (!this.element.contains(event.target) && this.open) {
      this.open = false
      this.updateUI()
    }
  }
}
