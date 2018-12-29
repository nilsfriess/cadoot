import {countdownTime} from '../helpers'

let questionCount = 0

const selectedAnswers = Array.from({length: 4}).fill(false)

let answer1Card
let answer2Card
let answer3Card
let answer4Card
let answerCards = []

let answer1CardTitle
let answer2CardTitle
let answer3CardTitle
let answer4CardTitle

let isShowingSolution = false

let channel

export default _channel => {
  channel = _channel
  answer1Card = document.querySelector('.answers .answer1')
  answer2Card = document.querySelector('.answers .answer2')
  answer3Card = document.querySelector('.answers .answer3')
  answer4Card = document.querySelector('.answers .answer4')
  answerCards = [answer1Card, answer2Card, answer3Card, answer4Card]

  answer1CardTitle = answer1Card.querySelector('span')
  answer2CardTitle = answer2Card.querySelector('span')
  answer3CardTitle = answer3Card.querySelector('span')
  answer4CardTitle = answer4Card.querySelector('span')
}

export const beforeStart = () => {
  const loaderElement = document.querySelector('.loader')
  loaderElement.innerHTML = '<h1><h1>'
  const timerElement = document.querySelector('.loader h1')

  timerElement.innerHTML = countdownTime

  let counter = 1
  const interval = setInterval(() => {
    timerElement.innerHTML = countdownTime - counter++

    if (counter == 6) clearInterval(interval)
  }, 1000)

  document.querySelector('.waiting-msg').innerHTML = 'Quiz is about to start!'
}

export const renderOnlineUsers = count => {
  document.querySelector('#online_count').innerHTML =
    count == 1 ? 'one user waiting' : count + ' users waiting'
}

export const onStart = questions => {
  questionCount = questions
  document.querySelector('#online_count').innerHTML = '1 / ' + questionCount
  document.querySelector('.loader').style.display = 'none'
  document.querySelector('.waiting-msg').style.display = 'none'
  document.querySelector('.description').innerHTML =
    'Tap on an answer to mark it as correct'
  document.querySelector('.answers').style.display = 'block'
  initAnswerCards()
}

export const updateAnswers = ({
  answer1,
  answer2,
  answer3,
  answer4,
  questionNumber,
}) => {
  console.log('updating answers')
  let currentQuestionNumber = questionNumber
  updateQuestionCounter(currentQuestionNumber)

  document.querySelector('.answers .answer1 p').innerHTML = answer1
  document.querySelector('.answers .answer2 p').innerHTML = answer2
  document.querySelector('.answers .answer3 p').innerHTML = answer3
  document.querySelector('.answers .answer4 p').innerHTML = answer4

  _.each(answerCards, card => {
    card.style.outline = 'none'
    card.parentElement.style.transform = 'scale(1)'
  })

  isShowingSolution = false
}

const updateQuestionCounter = currentQuestionNumber => {
  document.querySelector('#online_count').innerHTML =
    currentQuestionNumber + 1 + ' / ' + questionCount
}

const initAnswerCards = () => {
  _.each(answerCards, (answer, index) => {
    answer.addEventListener('click', () => {
      if (isShowingSolution) return
      selectedAnswers[index] = !selectedAnswers[index]
      if (selectedAnswers[index]) {
        answer.style.outline = '2px solid #388E3C'
        answer.parentElement.style.transform = 'scale(0.95)'
      } else {
        answer.style.outline = 'none'
        answer.parentElement.style.transform = 'scale(1)'
      }
    })
  })
}

export const showSolution = payload => {
  let correctAnswers = Object.values(payload)
  _.each(correctAnswers, (ans, index) => {
    if (ans == selectedAnswers[index]) {
      answerCards[index].style.outline = '2px solid green'
    } else {
      answerCards[index].style.outline = '2px solid red'
    }
  })

  channel.push('answers:' + localStorage.getItem('PHOENIX_UUID'), {
    answers: selectedAnswers,
  })

  isShowingSolution = true
}
