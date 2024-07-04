import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step", "input", "error"]

  connect() {
    this.showCurrentStep()
  }

  showCurrentStep() {
    this.stepTargets.forEach((element, index) => {
      element.classList.toggle("hidden", index !== this.currentStep)
    })
  }

  nextStep(event) {
    event.preventDefault()
    if (this.validateCurrentStep()) {
      this.currentStep++
      this.showCurrentStep()
    }
  }

  previousStep(event) {
    event.preventDefault()
    this.currentStep--
    this.showCurrentStep()
  }

  validateCurrentStep() {
    const currentStepElement = this.stepTargets[this.currentStep]
    const inputElement = currentStepElement.querySelector("input")
    const errorElement = currentStepElement.querySelector(".error-message")

    if (inputElement.value.trim() === "") {
      errorElement.classList.remove('hidden')
      inputElement.classList.add('border-red-500', 'focus:border-red-500')
      return false
    } else {
      errorElement.classList.add('hidden')
      inputElement.classList.remove('border-red-500', 'focus:border-red-500')
      return true
    }
  }

  get currentStep() {
    return parseInt(this.data.get("currentStep")) || 0
  }

  set currentStep(value) {
    this.data.set("currentStep", value)
  }
}
