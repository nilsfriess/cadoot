import {Socket} from 'phoenix'
import {
  beforeStart,
  onStart,
  renderOnlineUsers,
  updateAnswers,
  showSolution,
} from './pages/start'

import {renderWaitingUsers} from './pages/info'

import {onNextQuestion, onStartHost} from './pages/host'

let currentQuestionNumber = 0
let questionCount = 0

let userCount = 0
export const setup = () => {
  let socket = new Socket('/socket')
  const quizPin = window.quizPin

  const channel = socket.channel('quiz:' + quizPin, {})
  socket.connect()

  channel
    .join()
    .receive('ok', resp => {
      console.log('Joined successfully', resp)
    })
    .receive('error', resp => {
      console.log('Unable to join', resp)
    })

  channel.on('presence_state', setPresence)
  channel.on('presence_diff', diffPresence)

  channel.on('before_start', beforeStartCallback)
  channel.on('start', onStartCallback)
  channel.on('next_question', nextQuestionCallback)
  channel.on('show_solution', showSolutionCallback)

  if (window.onStartPage) setupStartPage(channel)
  if (window.onHostInfoPage) setupHostInfoPage(socket)

  return channel
}

const setPresence = payload => {
  userCount = payload.users.count
  renderOnlineUsers(userCount)
}

const diffPresence = payload => {
  console.log('Diff', payload)
  const leaves = payload.leaves.users.count
  const joins = payload.joins.users.count

  userCount = userCount + joins - leaves

  renderOnlineUsers(userCount)
}

const setupStartPage = channel => {
  channel.push('request:uuid').receive('ok', ({uuid}) => {
    localStorage.setItem('PHOENIX_UUID', uuid)
    console.log('UUID', localStorage.getItem('PHOENIX_UUID'))
  })
}

const setupHostInfoPage = (socket, presence) => {}
// not executed on the host because he's sending the message
const beforeStartCallback = payload => {
  beforeStart() // setup start page
}

const onStartCallback = payload => {
  if (window.onStartPage) onStart(payload.questionCount)
  if (window.onHostPage) onStartHost()
}

const nextQuestionCallback = payload => {
  console.log('Next Question', payload)
  if (window.onStartPage) updateAnswers(payload)
  if (window.onHostPage) onNextQuestion(payload)
}

const showSolutionCallback = payload => {
  if (window.onStartPage) showSolution(payload)
}
