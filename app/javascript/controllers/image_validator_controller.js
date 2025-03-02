import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input" ]

  validateSize() {
    debugger
    const sizeInMegabytes = this.inputTarget.files[0]?.size / (1024 * 1024)

    if (sizeInMegabytes > 5) {
      alert("Maximum file size is 5MB. Please choose a smaller file.")
      this.inputTarget.value = ""
    }
  }
}
