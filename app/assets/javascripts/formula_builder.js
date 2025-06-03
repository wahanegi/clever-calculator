function insertSymbol(htmlData, type) {
  const element = document.createElement('div')
  const controls = document.createElement('div')
  const buttonX = document.createElement('button')
  const buttonMoveRight = document.createElement('button')
  const buttonMoveLeft = document.createElement('button')

  buttonX.innerText = 'x'
  buttonX.classList.add('formula-display-controls-remove-button')
  buttonX.addEventListener('click', () => {
    element.remove()
  })

  buttonMoveLeft.innerText = '<'
  buttonMoveLeft.classList.add('formula-display-controls-move-left-button')
  buttonMoveLeft.addEventListener('click', () => {
    const prev = element.previousElementSibling
    if (prev) {
      formulaDisplay.insertBefore(element, prev)
    }
  })

  buttonMoveRight.innerText = '>'
  buttonMoveRight.classList.add('formula-display-controls-move-right-button')
  buttonMoveRight.addEventListener('click', () => {
    const next = element.nextElementSibling
    if (next) {
      formulaDisplay.insertBefore(next, element)
    }
  })

  controls.classList.add('formula-display-controls')
  controls.appendChild(buttonMoveLeft)
  controls.appendChild(buttonX)
  controls.appendChild(buttonMoveRight)

  element.innerHTML = htmlData
  element.dataset.type = type
  element.classList.add('formula-display-bubble')
  element.classList.add(`formula-display-${type}`)
  element.appendChild(controls)

  formulaDisplay.insertAdjacentElement('beforeend', element)
}

document.addEventListener('DOMContentLoaded', () => {
  const formulaDisplay = document.getElementById('formulaDisplay')
  const formulaInput = document.getElementById('formulaInput')

  if (!formulaDisplay || !formulaInput) return

  document.querySelectorAll('.formula-btn.operator-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
      insertSymbol(btn.dataset.operator, 'operator')
    })
  })

  document.querySelectorAll('.formula-btn.param-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
      insertSymbol(btn.dataset.param, 'param')
    })
  })

  document.querySelectorAll('.formula-btn.custom-value-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
      insertSymbol(btn.dataset.customValue, 'custom-value')
    })
  })

  document.querySelectorAll('.formula-display-bubble').forEach(bubble => {
    bubble.querySelectorAll('.formula-display-controls').forEach(controls => {

      controls.querySelector('.formula-display-controls-remove-button')
        .addEventListener('click', () => {
          bubble.remove()
        })

      controls.querySelector('.formula-display-controls-move-left-button')
        .addEventListener('click', () => {
          const prev = bubble.previousElementSibling
          if (prev) {
            formulaDisplay.insertBefore(bubble, prev)
          }
        })

      controls.querySelector('.formula-display-controls-move-right-button')
        .addEventListener('click', () => {
          const next = bubble.nextElementSibling
          if (next) {
            formulaDisplay.insertBefore(next, bubble)
          }
        })

    })
  })

  document.querySelector('form#formulaForm').addEventListener('submit', () => {
    let formula = ''

    const bubbles = formulaDisplay.querySelectorAll('.formula-display-bubble')

    bubbles.forEach(bubble => {
      const span = bubble.querySelector('span')

      switch (bubble.dataset.type) {
        case 'operator':
          if (span?.dataset.operator) {
            formula += `${span.dataset.operator} `
          }
          break

        case 'param':
          if (span?.dataset.param) {
            formula += `${span.dataset.param} `
          }
          break

        case 'custom-value':
          const input = bubble.querySelector('input[name="custom_value"]')
          if (input?.value) {
            formula += `${input.value.trim()} `
          }
          break

        default:
          console.error('Unknown bubble type:', bubble.dataset.type)
          break
      }
    })

    formulaInput.value = formula.trim()
  })

})
