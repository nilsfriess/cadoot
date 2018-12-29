export default () => {
  const pinInput = document.querySelector('#pin_input')
  const pinInputButton = document.querySelector('#pin_input_button')

  pinInput.addEventListener('keyup', input => {
    if (pinInput.value) pinInputButton.classList.remove('disabled')
    else pinInputButton.classList.add('disabled')
  })
}
