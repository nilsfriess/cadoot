import {escape} from '../helpers'

export default () => {
  let timeout = null

  const codeInput = document.querySelector('.edit-container textarea')
  const codeBlock = document.querySelector('.modal .code')
  codeInput.addEventListener('keyup', () => {
    clearTimeout(timeout)

    timeout = setTimeout(() => {
      codeBlock.innerHTML = escape(codeInput.value)
      hljs.highlightBlock(codeBlock)
    }, 400)
  })
}
