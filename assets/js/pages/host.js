let currentQuestionNumber = 0
let showingQuestion = false

let answer1correct = false
let answer2correct = false
let answer3correct = false
let answer4correct = false

export default channel => {
  const timerElement = document.querySelector('.counter')
  timerElement.innerHTML = 5

  let counter = 1
  const interval = setInterval(() => {
    timerElement.innerHTML = 5 - counter++

    if (counter == 6) clearInterval(interval)
  }, 1000)

  let nextQuestionButton = document.querySelector('.next-question')
  nextQuestionButton.addEventListener('click', () => {
    if (showingQuestion) {
      showSolution()
      channel.push('show_solution', {
        answer1correct,
        answer2correct,
        answer3correct,
        answer4correct,
      })
    } else {
      channel.push('next_question_host', {
        questionNumber: currentQuestionNumber + 1,
        quizPin: quizPin,
      })
    }
  })
}

export const onStartHost = () => {
  document.querySelector('.host-container').style.display = 'block'
  document.querySelector('.loader').style.display = 'none'
  document.querySelector('.content').style.display = 'flex'
}

export const onNextQuestion = payload => {
  currentQuestionNumber = payload.questionNumber

  answer1correct = payload.answer1correct
  answer2correct = payload.answer2correct
  answer3correct = payload.answer3correct
  answer4correct = payload.answer4correct

  document.querySelector('.question-title').innerHTML = payload.question

  let cards = document.querySelectorAll('.answers .card')
  _.each(cards, card => (card.style.opacity = '1'))

  document.querySelector('.answers .answer1 h3').innerHTML = payload.answer1
  document.querySelector('.answers .answer2 h3').innerHTML = payload.answer2
  document.querySelector('.answers .answer3 h3').innerHTML = payload.answer3
  document.querySelector('.answers .answer4 h3').innerHTML = payload.answer4

  if (payload.code === '')
    document.querySelector('.code').style.display = 'none'
  else {
    document.querySelector('.code').style.display = 'block'
    document.querySelector('.code').innerHTML = payload.code
    hljs.highlightBlock(document.querySelector('.code'))
  }

  showingQuestion = true
  document.querySelector('.next-question').innerHTML = 'Show solution'
}
const showSolution = () => {
  showingQuestion = false
  document.querySelector('.next-question').innerHTML = 'next question'

  let cards = document.querySelectorAll('.answers .card')

  if (!answer1correct) cards[0].style.opacity = '0.2'

  if (!answer2correct) cards[1].style.opacity = '0.2'

  if (!answer3correct) cards[2].style.opacity = '0.2'

  if (!answer4correct) cards[3].style.opacity = '0.2'
}
