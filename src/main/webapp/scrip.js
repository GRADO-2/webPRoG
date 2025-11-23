let historyData = JSON.parse(localStorage.getItem("histData")) || [];
let currentR = 5; // Valor inicial de R

// Sincroniza sessionStorage con localStorage al cargar la página
function syncStorage() {
    // Copia los datos de localStorage a sessionStorage para persistencia
    const localStorageData = JSON.parse(localStorage.getItem("histData")) || [];
    sessionStorage.setItem("histData", JSON.stringify(localStorageData));
}

// Almacena los puntos en localStorage y sessionStorage
function savePointToStorage(dot, ans) {
    historyData.push({ dot, ans });
    localStorage.setItem("histData", JSON.stringify(historyData));
    sessionStorage.setItem("histData", JSON.stringify(historyData));
}

// Referencias a elementos clave del DOM
const form = document.getElementById("form");
const rInput = document.getElementById('r_input');
const yInput = document.getElementById('y_input');
const xHiddenInput = document.getElementById('x_hidden_input');
const svg = document.getElementById("miSVG");
const coordPloter = document.getElementById("coordsPloter");

// ===== UTILIDADES =====

function formatForDisplay(str, maxDecimals = 7) {
    if (typeof str !== 'string') str = String(str);
    str = str.trim();
    if (!str) return str;
    const num = Number(str.replace(',', '.'));
    if (isNaN(num) || !isFinite(num)) {
        return str;
    }
    // Usar toFixed o notación científica si es necesario
    if (Math.abs(num) >= 1e6 || Math.abs(num) < 1e-4) {
        return num.toExponential(maxDecimals - 1).replace('+', '');
    }
    return num.toFixed(maxDecimals).replace(/\.?0+$/, ''); // Remueve ceros finales
}

function showError(fieldName, message) {
    if (fieldName === "general") {
        alert(message);
        return;
    }
    const el = document.getElementById(`${fieldName}-error`);
    const input = document.getElementById(`${fieldName}_input`) || document.querySelector(`[name="${fieldName}"]`);
    if (el) el.textContent = message;
    if (input) input.classList.add('error');
}

function clearErrors() {
    document.querySelectorAll('.error-message').forEach(el => el.textContent = '');
    document.querySelectorAll('input').forEach(el => el.classList.remove('error'));
}

// ===== HISTORIAL (Ahora solo maneja localStorage, el JSP maneja la renderización en carga) =====

// Se mantiene esta función por si el requisito dice que la tabla debe actualizarse via JS (aunque el MVC pide recarga)
function renderHistory() {
    // Si se usa MVC puro con JSP, este bloque se vacía o se usa solo para dibujar puntos en SVG.
    // Dejo la lógica de dibujar puntos para el historial.
    const pointsGroup = document.getElementById("pointsGroup");
    if (pointsGroup) pointsGroup.innerHTML = "";

    // Dibuja todos los puntos del historial almacenados en localStorage
    historyData.forEach(({ dot, ans }) => {
         drawPoint(dot.x, dot.y, ans.result);
    });
}

function addRowHist(dot, ans) {
    savePointToStorage(dot, ans);
    // En el MVC tradicional, la tabla se actualiza con la recarga de la página,
    // pero mantenemos el dibujo de puntos en el SVG.
    // drawPoint(dot.x, dot.y, ans.result); // Se llama desde el evento submit/click
}

document.getElementById("flushHist")?.addEventListener("click", () => {
    historyData = [];
    localStorage.removeItem("histData");
    sessionStorage.removeItem("histData");

    // En el contexto de Servlets/JSP, es mejor enviar una petición al servidor para limpiar la SESIÓN/CONTEXTO.
    const clearForm = document.createElement('form');
    clearForm.method = 'POST';
    clearForm.action = 'controllerS';

    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'clear_history';
    input.value = 'true';
    clearForm.appendChild(input);

    document.body.appendChild(clearForm);
    clearForm.submit();
});

// ===== VALIDACIÓN (Mejorada) =====

function validateAndFormat(data) {
    const validX = new Set(["-4", "-3", "-2", "-1", "0", "1", "2", "3", "4"]);
    clearErrors();

    // 1. Validar X - Allow decimal values that come from SVG clicks
    let xValue = data.x;
    if (!xValue) {
        showError("x", "X must be selected or clicked on graph.");
        return null;
    }
    
    // Check if xValue is a decimal (from SVG click) or an integer (from buttons)
    const xNum = parseFloat(xValue);
    if (isNaN(xNum)) {
        showError("x", "X must be a valid number.");
        return null;
    }
    
    // If it's not one of the button values, check if it's a valid decimal
    if (!validX.has(xValue.toString())) {
        // It's from SVG click, allow decimal values but check range
        if (xNum < -4 || xNum > 4) {
            showError("x", "X must be in range [-4, 4].");
            return null;
        }
    }

    // 2. Validar Y
    const yStr = (data.y || "").trim().replace(',', '.');
    const yNum = parseFloat(yStr);

    if (yStr === "" || isNaN(yNum) || yNum < -5 || yNum > 5) {
        showError("y", "Y must be a number in [-5, 5].");
        return null;
    }

    // 3. Validar R
    const rStr = (data.rad || "").trim().replace(',', '.');
    const rNum = parseFloat(rStr);

    if (rStr === "" || isNaN(rNum) || rNum < 2 || rNum > 5) {
        showError("rad", "R must be a number in [2, 5].");
        return null;
    }

    return { x: xNum.toString(), y: yNum.toString(), rad: rNum.toString() };
}

// ===== SVG Y ÁREA =====

function updateArea(r) {
    const areaGroup = document.getElementById("areaGroup");
    if (!areaGroup) return;

    // Escala: 30 px por unidad (150px / 5 = 30)
    const s = 30;
    const rNum = parseFloat(r);

    if (isNaN(rNum) || rNum < 2 || rNum > 5) {
        areaGroup.innerHTML = ""; // Limpiar si R es inválido
        return;
    }

    // Cuadrado en primer cuadrante: x ∈ [0, r], y ∈ [-r/2, 0]
    const rect = `<rect class="area" x="0" y="${-s * (rNum / 2)}" width="${s * rNum}" height="${s * (rNum / 2)}" />`;

    // Triángulo en segundo cuadrante: vértices (0, 0), (0, -r), (-r/2, 0)
    const tri = `<polygon class="area" points="0,0 0,${-s * rNum} ${-s * (rNum / 2)},0" />`;

    // Semicírculo en tercer cuadrante: radio r/2, arco en tercer cuadrante (cuarto de círculo inferior izquierdo)
    const radius = s * (rNum / 2);
    // Dibuja un cuarto de círculo desde (0, -r/2) a (-r/2, 0) pasando por (-r/2, -r/2) - arco en tercer cuadrante
    const arc = `<path class="area" d="M 0,${-radius} A ${radius},${radius} 0 0,1 ${-radius},0 L 0,0 Z" transform="translate(0, 0)"/>`;


    areaGroup.innerHTML = rect + tri + arc;
}

function drawPoint(x, y, result) {
    const s = 30;
    const cx = parseFloat(x) * s;
    const cy = -parseFloat(y) * s; // Y invertido
    const color = result === "IN" ? "green" : "red";
    const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
    circle.setAttribute("cx", cx);
    circle.setAttribute("cy", cy);
    circle.setAttribute("r", 4);
    circle.setAttribute("fill", color);
    circle.setAttribute("stroke", "black");
    circle.setAttribute("stroke-width", "0.5");
    document.getElementById("pointsGroup")?.appendChild(circle);
}

function updateRLabels(r) {
    const rLabels = document.getElementById("rLabels");
    const r2Labels = document.getElementById("r2Labels");
    
    if (!rLabels || !r2Labels) return;
    
    const rNum = parseFloat(r);
    if (isNaN(rNum) || rNum < 2 || rNum > 5) return;
    
    // Update R labels positions
    const rScaled = rNum * 15; // 30px per unit, so r * 30 / 2 = r * 15
    const r2Scaled = rNum * 15 / 2; // (r/2) * 30 / 2 = r * 15 / 2
    
    // Update horizontal R labels
    const rLabelsTexts = rLabels.querySelectorAll('text');
    if (rLabelsTexts.length >= 8) {
        rLabelsTexts[0].setAttribute('x', rScaled); // Right positive
        rLabelsTexts[1].setAttribute('x', -rScaled); // Left negative
        rLabelsTexts[2].setAttribute('x', rScaled); // Right positive
        rLabelsTexts[3].setAttribute('x', -rScaled); // Left negative
        
        // Update vertical R labels
        rLabelsTexts[4].setAttribute('y', rScaled); // Bottom positive
        rLabelsTexts[5].setAttribute('y', -rScaled); // Top negative
        rLabelsTexts[6].setAttribute('y', rScaled); // Bottom positive
        rLabelsTexts[7].setAttribute('y', -rScaled); // Top negative
    }
    
    // Update R/2 labels positions
    const r2LabelsTexts = r2Labels.querySelectorAll('text');
    if (r2LabelsTexts.length >= 8) {
        r2LabelsTexts[0].setAttribute('x', r2Scaled); // Right positive
        r2LabelsTexts[1].setAttribute('x', -r2Scaled); // Left negative
        r2LabelsTexts[2].setAttribute('x', r2Scaled); // Right positive
        r2LabelsTexts[3].setAttribute('x', -r2Scaled); // Left negative
        
        // Update vertical R/2 labels
        r2LabelsTexts[4].setAttribute('y', r2Scaled); // Bottom positive
        r2LabelsTexts[5].setAttribute('y', -r2Scaled); // Top negative
        r2LabelsTexts[6].setAttribute('y', r2Scaled); // Bottom positive
        r2LabelsTexts[7].setAttribute('y', -r2Scaled); // Top negative
    }
}

// Function to redraw points based on current R value
function redrawPointsWithCurrentR() {
    const pointsGroup = document.getElementById("pointsGroup");
    if (pointsGroup) {
        pointsGroup.innerHTML = ""; // Clear existing points
        
        // Redraw all points from history that are within current R
        historyData.forEach(({ dot, ans }) => {
            // Check if the point should be visible based on current R
            // For now, we'll draw all points, but we could add filtering logic here
            drawPoint(dot.x, dot.y, ans.result);
        });
    }
}

// ===== MANEJO DE EVENTOS =====

document.addEventListener("DOMContentLoaded", () => {
    // 1. Inicializar R y el área
    if (rInput) {
        rInput.value = currentR;
        updateArea(currentR);

        rInput.addEventListener('input', () => {
            const val = rInput.value.trim().replace(',', '.');
            const num = parseFloat(val);
            clearErrors();
            if (!isNaN(num) && num >= 2 && num <= 5) {
                currentR = num;
                updateArea(currentR);
                updateRLabels(currentR);
                rInput.classList.remove("error");
            } else {
                showError("rad", "R ∈ [2, 5]");
            }
        });
    }

    // 2. Inicializar botones X
    document.querySelectorAll('.x-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.x-btn').forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');
            xHiddenInput.value = btn.getAttribute('data-x-val');
            clearErrors(); // Limpiar errores de X al seleccionar
        });
    });

    // 3. SVG interacción (Tooltip)
    if (svg && coordPloter) {
        const s = 30; // Escala

        svg.addEventListener("mousemove", function(e){
            const pt = svg.createSVGPoint();
            pt.x = e.clientX;
            pt.y = e.clientY;
            const loc = pt.matrixTransform(svg.getScreenCTM().inverse());
            const realX = (loc.x / s).toFixed(2);
            const realY = (-loc.y / s).toFixed(2);
            coordPloter.textContent = `X: ${realX}, Y: ${realY}`;
            coordPloter.style.left = (e.pageX + 10) + "px";
            coordPloter.style.top = (e.pageY + 10) + "px";
            coordPloter.style.display = "block";
        });

        svg.addEventListener("mouseleave", () => {
            coordPloter.style.display = "none";
        });

        // 4. SVG interacción (Click y Envío)
        svg.addEventListener("click", function(e){
            if (!rInput) {
                alert("R must be set before clicking the graph.");
                return;
            }

            const pt = svg.createSVGPoint();
            pt.x = e.clientX;
            pt.y = e.clientY;
            const loc = pt.matrixTransform(svg.getScreenCTM().inverse());
            let realX = loc.x / s;
            const realY = -loc.y / s;

            // Establecer valores en los inputs del formulario
            xHiddenInput.value = realX.toFixed(2); // X desde el click
            yInput.value = realY.toFixed(2); // Y desde el click

            // Forzar el submit del formulario
            form.method = "GET"; // o POST, según tu ControllerServlet
            form.action = "controllerS?from_graph=true"; // Add parameter to indicate graph click
            form.submit();
        });
    }

    // 5. Envío de Formulario
    if (form) {
        form.addEventListener("submit", (e) => {
            e.preventDefault();

            const formData = new FormData(form);
            const data = Object.fromEntries(formData.entries());
            const selectedX = document.querySelector('.x-btn.selected');

            // Usar X del botón seleccionado o X del campo oculto si viene del click en SVG
            if (selectedX) {
                data.x = selectedX.value;
            } else if (xHiddenInput.value) {
                data.x = xHiddenInput.value;
            } else {
                data.x = null; // Forzar fallo en la validación si no se ha seleccionado X
            }

            const validated = validateAndFormat(data);
            if (!validated) return;

            // Actualizar R global y visual
            currentR = parseFloat(validated.rad);
            if (rInput) {
                rInput.value = validated.rad;
                updateRLabels(currentR);
            }

            // Poner los datos validados de vuelta en el formulario antes de enviar
            xHiddenInput.value = validated.x;
            yInput.value = validated.y;
            rInput.value = validated.rad;

            // ⚠️ Envío FINAL: El navegador navega a controllerS
            form.method = "GET"; // Asegura el método de envío
            form.action = "controllerS?from_graph=false"; // Add parameter to indicate form submission (with validation)
            form.submit();
        });

        form.addEventListener("reset", () => {
            clearErrors();
            document.querySelectorAll('.x-btn').forEach(btn => btn.classList.remove('selected'));
            currentR = 5;
            if (rInput) {
                rInput.value = currentR;
                updateArea(currentR);
                updateRLabels(currentR);
            }
            // Limpiar el campo oculto X
            if (xHiddenInput) xHiddenInput.value = '';
        });
    }


    // Al cargar la página, sincroniza el almacenamiento y dibuja los puntos del historial
    syncStorage();
    renderHistory();
});