import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['menu', 'content', 'trigger', 'sub', 'subContent', 'subTrigger'];

  connect() {
    this.closeAllMenus();
    this.menuOpen = false;
    this.boundClickOutside = this.clickOutside.bind(this);
    this.boundKeyDown = this.handleKeyDown.bind(this);
    document.addEventListener('click', this.boundClickOutside);
    document.addEventListener('keydown', this.boundKeyDown);
  }

  disconnect() {
    document.removeEventListener('click', this.boundClickOutside);
    document.removeEventListener('keydown', this.boundKeyDown);
  }

  clickOutside(event) {
    if (!this.element.contains(event.target) && this.menuOpen) {
      this.closeAllMenus();
    }
  }

  handleKeyDown(event) {
    if (!this.menuOpen) return;

    const currentTrigger = this.element.querySelector(
      '[data-menubar-target="trigger"][data-state="open"]',
    );
    if (!currentTrigger) return;

    const currentFocused = this.element.querySelector(':focus');
    const isInSubmenu = currentFocused.closest('[data-menubar-target="subContent"][data-state="open"]');
    const isSubTrigger = currentFocused.getAttribute('data-menubar-target') === 'subTrigger';

    console.log('Key pressed:', event.key);
    console.log('Current focused element:', currentFocused);
    console.log('Is in submenu:', isInSubmenu);
    console.log('Is subtrigger:', isSubTrigger);

    switch (event.key) {
      case 'ArrowLeft':
        event.preventDefault();
        if (isInSubmenu) {
          const subMenu = currentFocused.closest('[data-menubar-target="sub"]');
          this.closeSubMenu(subMenu);
          const parentTrigger = subMenu.querySelector('[data-menubar-target="subTrigger"]');
          parentTrigger.focus();
        } else {
          this.navigateTrigger(currentTrigger, 'previous');
        }
        break;
      case 'ArrowRight':
        event.preventDefault();
        if (currentFocused.getAttribute('data-menubar-target') === 'trigger') {
          this.navigateTrigger(currentTrigger, 'next');
        } else if (isSubTrigger) {
          this.openSubMenu(currentFocused.closest('[data-menubar-target="sub"]'));
          this.focusFirstSubmenuItem(currentFocused.closest('[data-menubar-target="sub"]'));
        } else if (!isInSubmenu) {
          // If we're in the main menu and not on a subtrigger, move to the next main trigger
          this.navigateTrigger(currentTrigger, 'next');
        }
        break;
      case 'ArrowDown':
      case 'ArrowUp':
        event.preventDefault();
        console.log('Arrow key pressed:', event.key);
        if (isInSubmenu) {
          console.log('Navigating within submenu');
          this.navigateSubmenu(
            currentFocused.closest('[data-menubar-target="subContent"]'),
            event.key === 'ArrowDown' ? 'next' : 'previous'
          );
        } else {
          console.log('Navigating main menu');
          this.navigateMenu(currentTrigger, event.key === 'ArrowDown' ? 'next' : 'previous');
        }
        break;
      case 'Escape':
        event.preventDefault();
        if (isInSubmenu) {
          this.closeSubMenu(currentFocused.closest('[data-menubar-target="sub"]'));
          currentFocused.closest('[data-menubar-target="subTrigger"]').focus();
        } else {
          this.closeAllMenus();
          currentTrigger.focus();
        }
        break;
    }
  }

  navigateMenu(trigger, direction) {
    const menu = trigger.closest('[data-menubar-target="menu"]');
    const content = menu.querySelector('[data-menubar-target="content"]');
    const items = Array.from(
      content.querySelectorAll(
        '[role="menuitem"], [role="menuitemradio"], [role="menuitemcheckbox"], [data-menubar-target="subTrigger"]',
      ),
    ).filter(item => !item.closest('[data-menubar-target="subContent"]'));

    console.log('All menu items:', items.map(item => item.textContent || item.innerText));

    const currentItem = content.querySelector(':focus') || trigger;
    let index = items.indexOf(currentItem);
    let startIndex = index;

    console.log('Current item:', currentItem.textContent || currentItem.innerText);
    console.log('Current index:', index);
    console.log('Navigation direction:', direction);

    do {
      if (direction === 'next') {
        index = (index + 1) % items.length;
      } else {
        index = (index - 1 + items.length) % items.length;
      }

      const item = items[index];
      console.log('Checking item:', item.textContent || item.innerText);

      // Skip disabled or hidden items
      if (item.hasAttribute('disabled') || item.classList.contains('hidden')) {
        console.log('Item is disabled or hidden, skipping');
        continue;
      }

      console.log('Focusing on item:', item.textContent || item.innerText);
      item.focus();
      return;

    } while (index !== startIndex);

    console.log('Looped through all items, focusing on trigger');
    trigger.focus();
  }

  navigateSubmenu(subContent, direction) {
    const items = Array.from(
      subContent.querySelectorAll(
        '[role="menuitem"], [role="menuitemradio"], [role="menuitemcheckbox"]',
      ),
    );

    const currentItem = subContent.querySelector(':focus');
    let index = items.indexOf(currentItem);

    if (index === -1) {
      index = direction === 'next' ? 0 : items.length - 1;
    } else {
      index =
        direction === 'next'
          ? (index + 1) % items.length
          : (index - 1 + items.length) % items.length;
    }

    items[index].focus();
  }

  openSubMenu(subMenu) {
    const subTrigger = subMenu.querySelector("[data-menubar-target='subTrigger']");
    const subContent = subMenu.querySelector("[data-menubar-target='subContent']");

    subContent.classList.remove('hidden');
    subContent.setAttribute('data-state', 'open');
    subTrigger.setAttribute('data-state', 'open');

    this.positionSubContent(subContent, subTrigger);

    this.focusFirstSubmenuItem(subMenu);
  }

  closeSubMenu(subMenu) {
    const subTrigger = subMenu.querySelector("[data-menubar-target='subTrigger']");
    const subContent = subMenu.querySelector("[data-menubar-target='subContent']");

    if (subContent) {
      subContent.setAttribute('data-state', 'closed');
      subContent.classList.add('hidden');
    }

    if (subTrigger) {
      subTrigger.removeAttribute('data-state');
    }
  }

  focusFirstSubmenuItem(subMenu) {
    const subContent = subMenu.querySelector('[data-menubar-target="subContent"]');
    const firstItem = subContent.querySelector(
      '[role="menuitem"], [role="menuitemradio"], [role="menuitemcheckbox"]',
    );
    if (firstItem) {
      firstItem.focus();
    }
  }

  navigateTrigger(currentTrigger, direction) {
    const triggers = Array.from(this.triggerTargets);
    const currentIndex = triggers.indexOf(currentTrigger);
    let newIndex;

    if (direction === 'next') {
      newIndex = (currentIndex + 1) % triggers.length;
    } else {
      newIndex = (currentIndex - 1 + triggers.length) % triggers.length;
    }

    const newTrigger = triggers[newIndex];
    this.openMenu(newTrigger.closest('[data-menubar-target="menu"]'));
    newTrigger.focus();
  }

  toggleMenu(event) {
    event.preventDefault();
    event.stopPropagation();
    const menu = event.currentTarget.closest("[data-menubar-target='menu']");
    const content = menu.querySelector("[data-menubar-target='content']");

    if (content.getAttribute('data-state') !== 'open') {
      this.openMenu(menu);
    } else {
      this.closeAllMenus();
    }
  }

  showMenuOnHover(event) {
    if (this.menuOpen) {
      const newMenu = event.currentTarget.closest("[data-menubar-target='menu']");
      const currentOpenTrigger = this.element.querySelector(
        '[data-menubar-target="trigger"][data-state="open"]',
      );

      if (currentOpenTrigger && currentOpenTrigger !== event.currentTarget) {
        currentOpenTrigger.removeAttribute('data-state');
        currentOpenTrigger.blur(); // Remove focus from the current open trigger
      }

      this.openMenu(newMenu);
      event.currentTarget.focus(); // Set focus to the new trigger
    }
  }

  openMenu(menu) {
    this.closeAllMenus();
    const trigger = menu.querySelector("[data-menubar-target='trigger']");
    const content = menu.querySelector("[data-menubar-target='content']");

    this.positionContent(content, trigger);

    content.classList.remove('hidden');
    content.setAttribute('data-state', 'open');
    trigger.setAttribute('data-state', 'open');
    this.menuOpen = true;
  }

  closeMenu(menu) {
    const trigger = menu.querySelector("[data-menubar-target='trigger']");
    const content = menu.querySelector("[data-menubar-target='content']");

    content.setAttribute('data-state', 'closed');
    trigger.removeAttribute('data-state');

    setTimeout(() => {
      if (content.getAttribute('data-state') === 'closed') {
        content.classList.add('hidden');
        content.removeAttribute('data-state');
      }
    }, 100);
  }

  positionContent(content, trigger) {
    const triggerRect = trigger.getBoundingClientRect();
    const menubarRect = this.element.getBoundingClientRect();

    let top = triggerRect.bottom - menubarRect.top;

    if (triggerRect.bottom + content.offsetHeight > window.innerHeight) {
      top = triggerRect.top - content.offsetHeight - menubarRect.top;
      content.setAttribute('data-side', 'top');
    } else {
      content.setAttribute('data-side', 'bottom');
    }

    content.style.top = `${top}px`;
    content.style.left = null;
  }

  selectItem(event) {
    event.preventDefault();
    event.stopPropagation();
    this.closeAllMenus();
  }

  closeAllMenus() {
    this.triggerTargets.forEach(trigger => trigger.removeAttribute('data-state'));
    this.menuTargets.forEach(menu => {
      const content = menu.querySelector("[data-menubar-target='content']");
      content.setAttribute('data-state', 'closed');
      content.classList.add('hidden');
      content.removeAttribute('data-state');
    });

    if (this.hasSubTarget) {
      this.subTargets.forEach(sub => {
        this.closeSubMenu(sub);
      });
    } else {
      console.warn('No sub targets found');
    }

    this.menuOpen = false;
  }

  toggleSubMenu(event) {
    event.preventDefault();
    event.stopPropagation();
    const subMenu = event.currentTarget.closest("[data-menubar-target='sub']");
    const subContent = subMenu.querySelector("[data-menubar-target='subContent']");

    if (subContent.getAttribute('data-state') !== 'open') {
      this.openSubMenu(subMenu);
    } else {
      this.closeSubMenu(subMenu);
    }
  }

  showSubMenuOnHover(event) {
    if (this.menuOpen) {
      const newSubMenu = event.currentTarget.closest("[data-menubar-target='sub']");
      const currentOpenSubTrigger = this.element.querySelector(
        '[data-menubar-target="subTrigger"][data-state="open"]',
      );

      if (currentOpenSubTrigger && currentOpenSubTrigger !== event.currentTarget) {
        this.closeSubMenu(currentOpenSubTrigger.closest("[data-menubar-target='sub']"));
      }

      this.openSubMenu(newSubMenu);
    }
  }

  positionSubContent(subContent, subTrigger) {
    const triggerRect = subTrigger.getBoundingClientRect();
    const menubarRect = this.element.getBoundingClientRect();
    const viewportWidth = window.innerWidth;

    const contentWidth = subContent.offsetWidth;

    // Always set top to 0 to align with the trigger
    let top = 0;
    
    // Calculate left position
    let left = triggerRect.width; // Position right next to the trigger

    // Check if submenu extends beyond the right edge of the viewport
    if (triggerRect.right + contentWidth > viewportWidth) {
      left = -contentWidth; // Position to the left of the trigger
      subContent.setAttribute('data-side', 'left');
    } else {
      subContent.setAttribute('data-side', 'right');
    }

    subContent.style.left = `${left}px`;
    subContent.style.top = `${top}px`;
  }

  toggleCheckboxItem(event) {
    const checkboxItem = event.currentTarget;
    const checkIcon = checkboxItem.querySelector('.absolute');
    checkIcon.classList.toggle('hidden');
  }

  selectRadioItem(event) {
    const radioItem = event.currentTarget;
    const radioGroup = radioItem.closest('[role="group"]');
    const allRadioItems = radioGroup.querySelectorAll('[role="menuitemradio"]');

    allRadioItems.forEach(item => {
      item.querySelector('.absolute').classList.add('hidden');
    });

    radioItem.querySelector('.absolute').classList.remove('hidden');
  }
}
