document.addEventListener("DOMContentLoaded", () => {
    const formulaDisplay = document.getElementById("formulaDisplay");
    const formulaInput = document.getElementById("formulaInput");
    const autocompleteBox = document.getElementById("autocompleteBox");

    if (!formulaDisplay || !formulaInput) return;

    document.querySelectorAll(".formula-btn").forEach((btn) => {
        btn.addEventListener("click", () => {
            const symbol = btn.innerText;
            formulaDisplay.innerText += ` ${symbol} `;
        });
    });

    document.querySelector("form").addEventListener("submit", () => {
        formulaInput.value = formulaDisplay.innerText.trim();
    });

    formulaDisplay.addEventListener("keydown", (event) => {
        const selection = window.getSelection();
        const node = selection.anchorNode;
        if (!node || node.nodeType !== Node.TEXT_NODE) return;

        const text = node.textContent;
        const offset = selection.anchorOffset;
        const match = text.match(/\b\w+\b/g);
        if (!match) return;

        const caretWord = match.find(word => {
            const index = text.indexOf(word);
            return offset >= index && offset <= index + word.length;
        });

        if (caretWord && (event.key === "Backspace" || event.key === "Delete")) {
            const newText = text.replace(caretWord, "").replace(/\s{2,}/g, " ").trim();
            node.textContent = newText;
            selection.collapse(node, newText.length);
            event.preventDefault();
        }
    });

    formulaDisplay.addEventListener("keyup", (event) => {
        const text = formulaDisplay.innerText;
        const words = text.split(/\s+/);
        const lastWord = words[words.length - 1];

        if (!lastWord || lastWord.length < 1) {
            autocompleteBox.style.display = "none";
            return;
        }

        const matches = window.availableParams.filter(param =>
            param.toLowerCase().startsWith(lastWord.toLowerCase())
        );

        if (matches.length === 0) {
            autocompleteBox.style.display = "none";
            return;
        }

        autocompleteBox.innerHTML = "";
        matches.forEach((match) => {
            const div = document.createElement("div");
            div.className = "autocomplete-option";
            div.innerText = match;
            div.onclick = () => {
                words[words.length - 1] = match;
                formulaDisplay.innerText = words.join(" ") + " ";

                autocompleteBox.style.display = "none";
                const range = document.createRange();
                const sel = window.getSelection();
                range.selectNodeContents(formulaDisplay);
                range.collapse(false);
                sel.removeAllRanges();
                sel.addRange(range);
            };
            autocompleteBox.appendChild(div);
        });

        const rect = formulaDisplay.getBoundingClientRect();
        autocompleteBox.style.position = "absolute";
        autocompleteBox.style.top = `${rect.bottom + window.scrollY}px`;
        autocompleteBox.style.left = `${rect.left + window.scrollX}px`;
        autocompleteBox.style.display = "block";
    });
});
