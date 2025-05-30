function toFormulaName(text) {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, '')
    .trim()
    .replace(/\s+/g, '_')
}

function insertSymbol(symbol) {
  const selection = window.getSelection()

  let range

  // Make selection within formulaDisplay field
  if (selection.rangeCount > 0 && formulaDisplay.contains(selection.anchorNode)) {
    range = selection.getRangeAt(0)
  } else {
    // Otherwise insert at the end of formulaDisplay
    range = document.createRange()
    range.selectNodeContents(formulaDisplay)
    range.collapse(false) // move to end
  }

  range.deleteContents()

  const spaceBefore = document.createTextNode(' ')
  const symbolNode = document.createTextNode(symbol)
  const spaceAfter = document.createTextNode(' ')

  range.insertNode(spaceAfter)
  range.insertNode(symbolNode)
  range.insertNode(spaceBefore)

  // Move caret to after the inserted symbol
  range.setStartAfter(spaceAfter)
  range.collapse(true)
  selection.removeAllRanges()
  selection.addRange(range)
}

function placeCaretAtEnd(element) {
  if (!element) return

  const range = document.createRange()
  range.selectNodeContents(element)
  range.collapse(false)

  const sel = window.getSelection()
  sel.removeAllRanges()
  sel.addRange(range)
}

document.addEventListener('DOMContentLoaded', () => {
  const formulaDisplay = document.getElementById('formulaDisplay')
  const formulaInput = document.getElementById('formulaInput')
  const autocompleteBox = document.getElementById('autocompleteBox')

  if (!formulaDisplay || !formulaInput) return

  formulaDisplay.focus()
  placeCaretAtEnd(formulaDisplay)

  document.querySelectorAll('.formula-btn.operator-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
      insertSymbol(btn.innerText)
    })
  })

  document.querySelectorAll('.formula-btn.param-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
      const symbol = toFormulaName(btn.innerText)
      insertSymbol(symbol)
    })
  })

  document.querySelector('form').addEventListener('submit', () => {
    let formula = formulaDisplay.innerText.trim()

    // Add spaces around math operators
    formula = formula.replace(/([+\-*/()=<>])/g, ' $1 ')

    // Remove extra spaces
    formula = formula.replace(/\s+/g, ' ').trim()

    formula = formula.replace(',', '.')
    formulaInput.value = formula
  })

  formulaDisplay.addEventListener('keydown', (event) => {
    const selection = window.getSelection()
    const node = selection.anchorNode
    if (!node || node.nodeType !== Node.TEXT_NODE) return

    const text = node.textContent
    const offset = selection.anchorOffset
    const match = text.match(/\b\w+\b/g)
    if (!match) return

    const caretWord = match.find((word) => {
      const index = text.indexOf(word)
      return offset >= index && offset <= index + word.length
    })

    if (caretWord && (event.key === 'Backspace' || event.key === 'Delete')) {
      const newText = text
        .replace(caretWord, '')
        .replace(/\s{2,}/g, ' ')
        .trim()
      node.textContent = newText
      selection.collapse(node, newText.length)
      event.preventDefault()
    }
  })

  formulaDisplay.addEventListener('keyup', (event) => {
    const text = formulaDisplay.innerText
    const words = text.split(/\s+/)
    const lastWord = words[words.length - 1]

    if (!lastWord || lastWord.length < 1) {
      autocompleteBox.style.display = 'none'
      return
    }

    const matches = window.availableParams.filter((param) => param.toLowerCase().startsWith(lastWord.toLowerCase()))

    if (matches.length === 0) {
      autocompleteBox.style.display = 'none'
      return
    }

    autocompleteBox.innerHTML = ''
    matches.forEach((match) => {
      const div = document.createElement('div')
      div.className = 'autocomplete-option'
      div.innerText = match
      div.onclick = () => {
        words[words.length - 1] = match
        formulaDisplay.innerText = words.join(' ') + ' '

        autocompleteBox.style.display = 'none'
        placeCaretAtEnd(formulaDisplay)
      }
      autocompleteBox.appendChild(div)
    })

    const rect = formulaDisplay.getBoundingClientRect()
    autocompleteBox.style.position = 'absolute'
    autocompleteBox.style.top = `${rect.bottom + window.scrollY}px`
    autocompleteBox.style.left = `${rect.left + window.scrollX}px`
    autocompleteBox.style.display = 'block'
  })
})
