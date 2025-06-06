function insertAtCaret(html) {
  const sel = window.getSelection()
  if (!sel || sel.rangeCount === 0) return

  const range = sel.getRangeAt(0)
  range.deleteContents() // Removes selected content

  // Create a fragment with the new content
  const temp = document.createElement('div')
  temp.innerHTML = html

  const frag = document.createDocumentFragment()
  let node, lastNode

  while ((node = temp.firstChild)) {
    lastNode = frag.appendChild(node)
  }

  // Insert the fragment at the range
  range.insertNode(frag)

  // Move caret after inserted content
  if (lastNode) {
    range.setStartAfter(lastNode)
    range.collapse(true)
    sel.removeAllRanges()
    sel.addRange(range)
  }
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

  if (!formulaDisplay || !formulaInput) return
  let lastRange = null;

  formulaDisplay.addEventListener('blur', () => {
    const sel = window.getSelection()
    if (sel.rangeCount > 0) {
      lastRange = sel.getRangeAt(0).cloneRange()
    }
  })

  formulaDisplay.focus()
  placeCaretAtEnd(formulaDisplay)

  document.querySelectorAll('.formula-btn.operator-btn, .formula-btn.param-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
      formulaDisplay.focus()

      if (lastRange) {
        const sel = window.getSelection()
        sel.removeAllRanges()
        sel.addRange(lastRange)
      } else {
        placeCaretAtEnd(formulaDisplay)
      }

      insertAtCaret(` ${btn.dataset.template} `)

      // Save updated range after insertion
      const sel = window.getSelection()
      if (sel.rangeCount > 0) {
        lastRange = sel.getRangeAt(0).cloneRange()
      }
    })
  })

  document.querySelector('form#formulaForm').addEventListener('submit', (e) => {
    // Clone the editor
    const clone = formulaDisplay.cloneNode(true)

    // Replace each bubble span with its paramId text node
    clone.querySelectorAll('.formula-bubble').forEach(bubble => {
      const textNode = document.createTextNode(bubble.dataset.paramId)
      bubble.replaceWith(textNode)
    })

    // Get the plain text after replacements
    let formula = clone.innerText.trim()

    // Replace non-breaking spaces (if any) with normal space
    formula = formula.replace(/\u00A0/g, ' ')

    // Add spaces around operators
    formula = formula.replace(/([+\-*/()])/g, ' $1 ')

    // Normalize whitespace
    formula = formula.replace(/\s+/g, ' ')

    // Replace commas with dots
    formula = formula.replace(/,/g, '.')

    formulaInput.value = formula.trim()
  })

  formulaDisplay.addEventListener('input', () => {
    const textContent = formulaDisplay.textContent.trim()
    const htmlContent = formulaDisplay.innerHTML.trim()

    if (textContent === '' && htmlContent === '') {
      // Remove all lingering tags
      formulaDisplay.innerHTML = ''
    }
  })

  formulaDisplay.addEventListener('keydown', (e) => {
    if (e.key !== 'Backspace') return

    const sel = window.getSelection()
    if (!sel.rangeCount) return

    const range = sel.getRangeAt(0)

    // CASE 1: Only a non-editable span exists in the editor
    if (
      formulaDisplay.childNodes.length === 1 &&
      formulaDisplay.firstChild.nodeType === 1 &&
      formulaDisplay.firstChild.contentEditable === 'false'
    ) {
      e.preventDefault()
      formulaDisplay.innerHTML = ''
      return
    }

    // CASE 2: Caret is at start of a text node, just after a non-editable span
    const node = range.startContainer
    if (node.nodeType === Node.TEXT_NODE && range.startOffset === 0) {
      const prev = node.previousSibling

      if (prev && prev.nodeType === 1 && prev.contentEditable === 'false') {
        e.preventDefault()
        prev.remove()
        return
      }
    }

    // CASE 3: Caret is directly inside the editor (not in a text node), and after a span
    if (
      node === formulaDisplay &&
      range.startOffset > 0 &&
      formulaDisplay.childNodes[range.startOffset - 1]?.contentEditable === 'false'
    ) {
      e.preventDefault()
      formulaDisplay.childNodes[range.startOffset - 1].remove()
    }
  })
})
