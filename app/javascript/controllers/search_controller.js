import { Controller } from "@hotwired/stimulus"
import debounce from "lodash"

// Connects to data-controller="search"
export default class extends Controller {
  connect() {
    this.search = () => {
      debounce(this.element.requestSubmit(), 200);
    }
  }
}
