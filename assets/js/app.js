import css from '../css/app.scss'

import 'phoenix_html'

import {setup} from './socket'

import host from './pages/host'
import landing from './pages/landing'
import start from './pages/start'
import editQuiz from './pages/editQuiz'

document.addEventListener('DOMContentLoaded', () => {
  hljs.initHighlightingOnLoad()

  let collapisibles = document.querySelectorAll('.collapsible')
  M.Collapsible.init(collapisibles)

  let modals = document.querySelectorAll('.modal')
  let instances = M.Modal.init(modals)

  let channel = setup()

  if (window.onLandingPage) landing()
  if (window.onStartPage) start(channel)
  if (window.onEditQuizPage) editQuiz()
  if (window.onHostPage) host(channel)
})
