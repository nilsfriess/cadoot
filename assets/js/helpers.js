export const escape = str => {
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;')
}

export const countdownTime = 5
