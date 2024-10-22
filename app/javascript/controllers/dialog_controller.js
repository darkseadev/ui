import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['content', 'closeButton'];

  connect() {
    this.contentElement = this.hasContentTarget ? this.contentTarget : this.element;
    this.backdropElement = null;

    if (this.hasCloseButtonTarget) {
      this.closeButtonTarget.addEventListener('click', this.close.bind(this));
    } else {
    }
  }

  disconnect() {
    this.removeBackdrop();
    this.resetContent();
    if (this.hasCloseButtonTarget) {
      this.closeButtonTarget.removeEventListener('click', this.close.bind(this));
    }
  }

  toggle() {
    const isOpen = this.contentElement.dataset.state === 'open';
    if (isOpen) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    this.createBackdrop();
    this.moveContentToBody();
    requestAnimationFrame(() => {
      this.contentElement.dataset.state = 'open';
      if (this.backdropElement) {
        this.backdropElement.dataset.state = 'open';
      }
    });
    document.addEventListener('keydown', this.handleKeydown.bind(this));
  }

  close(event) {
    if (event) event.preventDefault();
    this.contentElement.dataset.state = 'closed';
    if (this.backdropElement) {
      this.backdropElement.dataset.state = 'closed';
    }
    this.animateClose();
  }

  handleKeydown(event) {
    if (event.key === 'Escape') {
      this.close();
    }
  }

  createBackdrop() {
    if (!this.backdropElement) {
      const backdrop = document.createElement('div');
      backdrop.className = this.backdropClasses;
      backdrop.dataset.action = 'click->dialog#close';
      backdrop.dataset.state = 'closed';
      document.body.appendChild(backdrop);
      // Force a reflow to ensure the initial state is applied before changing it
      backdrop.offsetHeight;
      this.backdropElement = backdrop;
    }
  }

  removeBackdrop() {
    if (this.backdropElement && this.backdropElement.parentNode) {
      this.backdropElement.parentNode.removeChild(this.backdropElement);
      this.backdropElement = null;
    }
  }

  moveContentToBody() {
    if (this.contentElement.parentNode !== document.body) {
      document.body.appendChild(this.contentElement);
    }
  }

  resetContent() {
    if (this.contentElement.parentNode === document.body) {
      this.element.appendChild(this.contentElement);
    }
  }

  animateClose() {
    const animationDuration = 200; // Match the duration in tailwind.config.js
    setTimeout(() => {
      this.removeBackdrop();
      this.resetContent();
    }, animationDuration);
    document.removeEventListener('keydown', this.handleKeydown.bind(this));
  }

  get backdropClasses() {
    return 'fixed inset-0 z-[2000] bg-black/50 transition-opacity duration-200 ease-in-out opacity-0 data-[state=open]:opacity-100';
  }
}
