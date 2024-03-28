import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    this.hideAfterDelay()
  }

  hideAfterDelay() {
    setTimeout(() => {
      this.element.remove()
    }, 3000) 
  }
}
