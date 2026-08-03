(function () {
  "use strict";

  const display = document.getElementById("display");

  let currentInput = "0";
  let previousValue = null;
  let operator = null;
  let waitingForOperand = false;

  function updateDisplay() {
    display.textContent = currentInput;
  }

  function formatNumber(num) {
    if (!isFinite(num)) {
      return "Erro";
    }

    if (Object.is(num, -0)) {
      num = 0;
    }

    const absNum = Math.abs(num);

    // Resultado muito grande/pequeno: notação científica.
    // Precisa vir ANTES do arredondamento anti-ruído abaixo, pois multiplicar
    // um número já enorme por 1e10 estoura a precisão do double e distorce o valor.
    if (absNum !== 0 && (absNum >= 1e15 || absNum < 1e-9)) {
      return num.toExponential(6);
    }

    // Elimina ruído de ponto flutuante (ex.: 0.1 + 0.2)
    let rounded = Math.round(num * 1e10) / 1e10;
    let str = rounded.toString();

    // Limita a quantidade de dígitos exibidos, sem perder precisão desnecessária
    if (str.replace("-", "").replace(".", "").length > 14) {
      str = parseFloat(rounded.toPrecision(12)).toString();
    }

    return str;
  }

  function performCalculation(op, a, b) {
    switch (op) {
      case "+":
        return a + b;
      case "-":
        return a - b;
      case "*":
        return a * b;
      case "/":
        if (b === 0) {
          return null; // sinaliza erro (divisão por zero)
        }
        return a / b;
      default:
        return b;
    }
  }

  function resetState() {
    currentInput = "0";
    previousValue = null;
    operator = null;
    waitingForOperand = false;
  }

  function inputDigit(digit) {
    if (currentInput === "Erro") {
      resetState();
    }

    if (waitingForOperand) {
      currentInput = digit;
      waitingForOperand = false;
    } else {
      currentInput = currentInput === "0" ? digit : currentInput + digit;
    }
    updateDisplay();
  }

  function inputDecimal() {
    if (currentInput === "Erro") {
      resetState();
      currentInput = "0.";
      waitingForOperand = false;
      updateDisplay();
      return;
    }

    if (waitingForOperand) {
      currentInput = "0.";
      waitingForOperand = false;
    } else if (currentInput.indexOf(".") === -1) {
      currentInput += ".";
    }
    updateDisplay();
  }

  function handleOperator(nextOperator) {
    if (currentInput === "Erro") {
      return; // precisa limpar (C) antes de continuar
    }

    const inputValue = parseFloat(currentInput);

    // Cliques seguidos em operadores sem digitar número: só troca o operador
    if (operator && waitingForOperand) {
      operator = nextOperator;
      return;
    }

    if (previousValue === null) {
      previousValue = inputValue;
    } else if (operator) {
      const result = performCalculation(operator, previousValue, inputValue);
      if (result === null) {
        currentInput = "Erro";
        previousValue = null;
        operator = null;
        waitingForOperand = false;
        updateDisplay();
        return;
      }
      currentInput = formatNumber(result);
      previousValue = parseFloat(currentInput);
      updateDisplay();
    }

    waitingForOperand = true;
    operator = nextOperator;
  }

  function handleEquals() {
    if (currentInput === "Erro" || operator === null || previousValue === null) {
      return;
    }

    const inputValue = parseFloat(currentInput);
    const result = performCalculation(operator, previousValue, inputValue);

    if (result === null) {
      currentInput = "Erro";
    } else {
      currentInput = formatNumber(result);
    }

    previousValue = null;
    operator = null;
    waitingForOperand = true;
    updateDisplay();
  }

  // ---- Ligação dos botões da calculadora ----
  document.querySelectorAll(".tecla.num").forEach(function (btn) {
    btn.addEventListener("click", function () {
      inputDigit(btn.dataset.num);
    });
  });

  document.querySelectorAll(".tecla.op").forEach(function (btn) {
    btn.addEventListener("click", function () {
      handleOperator(btn.dataset.op);
    });
  });

  document.getElementById("btn-decimal").addEventListener("click", inputDecimal);
  document.getElementById("btn-igual").addEventListener("click", handleEquals);
  document.getElementById("btn-limpar").addEventListener("click", function () {
    resetState();
    updateDisplay();
  });

  // ---- Painel de customização ----
  const corBotaoInput = document.getElementById("cor-botao");
  corBotaoInput.addEventListener("input", function (e) {
    document.documentElement.style.setProperty("--cor-botao", e.target.value);
  });

  const fonteSelect = document.getElementById("fonte-select");
  fonteSelect.addEventListener("change", function (e) {
    document.documentElement.style.setProperty("--fonte-calculadora", e.target.value);
  });

  updateDisplay();
})();
