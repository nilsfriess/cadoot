export const renderWaitingUsers = presence => {
  let onlineCount = 0
  presence.list((id, {metas}) => {
    onlineCount = metas.length
  })

  document.querySelector('#online-count').innerHTML =
    onlineCount == 1 ? 'one user waiting' : onlineCount + ' users waiting'
}
