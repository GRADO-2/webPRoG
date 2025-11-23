<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // Prevent caching to avoid page reload when going back
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<html>
<head>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>Result</title>
    <link rel="stylesheet" type="text/css" href="css/result.css">
</head>
<body>

<%
    // Captura el mensaje de error si existe para la lógica condicional
    String errorMessage = (String) request.getAttribute("error_message");
%>

<div style="display: flex; justify-content: space-between;">
    <div style="flex: 1;">
        <h2>Resultados de la Verificación de Área</h2>
    </div>
    <div style="flex: 1; text-align: center;">
        <svg id="miSVG" width="300" height="300" viewBox="-150 -150 300 300">
            <!-- Axes -->
            <line x1="-150" y1="0" x2="150" y2="0" stroke="black" stroke-width="1"/>
            <line x1="0" y1="-150" x2="0" y2="150" stroke="black" stroke-width="1"/>

            <!-- Axis labels -->
            <text x="140" y="15" font-size="12" fill="black">X</text>
            <text x="5" y="-140" font-size="12" fill="black">Y</text>

            <!-- Quadrant labels and boundaries -->
            <!-- R boundaries - dynamically positioned based on current R value -->
            <g id="rLabels">
                <!-- Horizontal R labels -->
                <text x="75" y="-5" font-size="10" fill="blue" text-anchor="middle">R</text>
                <text x="-75" y="-5" font-size="10" fill="blue" text-anchor="middle">R</text>
                <text x="75" y="15" font-size="10" fill="blue" text-anchor="middle">R</text>
                <text x="-75" y="15" font-size="10" fill="blue" text-anchor="middle">R</text>
                <!-- Vertical R labels -->
                <text x="5" y="75" font-size="10" fill="blue" text-anchor="middle">R</text>
                <text x="5" y="-75" font-size="10" fill="blue" text-anchor="middle">R</text>
                <text x="-5" y="75" font-size="10" fill="blue" text-anchor="middle">R</text>
                <text x="-5" y="-75" font-size="10" fill="blue" text-anchor="middle">R</text>
            </g>

            <!-- R/2 boundaries -->
            <g id="r2Labels">
                <!-- Horizontal R/2 labels -->
                <text x="37.5" y="-5" font-size="10" fill="red" text-anchor="middle">R/2</text>
                <text x="-37.5" y="-5" font-size="10" fill="red" text-anchor="middle">R/2</text>
                <text x="37.5" y="15" font-size="10" fill="red" text-anchor="middle">R/2</text>
                <text x="-37.5" y="15" font-size="10" fill="red" text-anchor="middle">R/2</text>
                <!-- Vertical R/2 labels -->
                <text x="5" y="37.5" font-size="10" fill="red" text-anchor="middle">R/2</text>
                <text x="5" y="-37.5" font-size="10" fill="red" text-anchor="middle">R/2</text>
                <text x="-5" y="37.5" font-size="10" fill="red" text-anchor="middle">R/2</text>
                <text x="-5" y="-37.5" font-size="10" fill="red" text-anchor="middle">R/2</text>
            </g>

            <!-- Grid lines at R and R/2 positions -->
            <!-- For R=5: lines at ±5 and ±2.5 (R/2) -->
            <!-- Horizontal lines -->
            <line x1="-150" y1="75" x2="150" y2="75" stroke="#ccc" stroke-dasharray="2,2" stroke-width="0.5"/>
            <line x1="-150" y1="-75" x2="150" y2="-75" stroke="#ccc" stroke-dasharray="2,2" stroke-width="0.5"/>
            <line x1="-150" y1="37.5" x2="150" y2="37.5" stroke="#ccc" stroke-dasharray="2,2" stroke-width="0.5"/>
            <line x1="-150" y1="-37.5" x2="150" y2="-37.5" stroke="#ccc" stroke-dasharray="2,2" stroke-width="0.5"/>

            <!-- Vertical lines -->
            <line x1="75" y1="-150" x2="75" y2="150" stroke="#ccc" stroke-dasharray="2,2" stroke-width="0.5"/>
            <line x1="-75" y1="-150" x2="-75" y2="150" stroke="#ccc" stroke-dasharray="2,2" stroke-width="0.5"/>
            <line x1="37.5" y1="-150" x2="37.5" y2="150" stroke="#ccc" stroke-dasharray="2,2" stroke-width="0.5"/>
            <line x1="-37.5" y1="-150" x2="-37.5" y2="150" stroke="#ccc" stroke-dasharray="2,2" stroke-width="0.5"/>

            <!-- Area shapes will be drawn here -->
            <g id="areaGroup">
                <% if (errorMessage == null) {
                    String r = (String) request.getAttribute("r");
                    if (r != null) {
                        double rVal = Double.parseDouble(r);
                        double s = 30; // scale

                        // Rectángulo: x ≥ 0, y ≤ 0, ancho = r, alto = r/2
                        String rect = "<rect class=\"area\" x=\"0\" y=\"0\" width=\""+(s * rVal)+"\" height=\""+(s * (rVal / 2))+"\" transform=\"translate(0, "+(-s * (rVal / 2))+")\"/>";

                        // Triángulo: x ≤ 0, y ≥ 0, y ≤ r + 2x. Vértices: (-r/2, 0), (0, 0), (0, r)
                        // En coordenadas SVG (Y invertida): (-r/2, 0), (0, 0), (0, -r)
                        String tri = "<polygon class=\"area\" points=\""+(-s * (rVal / 2))+",0 0,0 0,"+(-s * rVal)+"\"/>";

                        // Sector circular: x ≤ 0, y ≤ 0, x² + y² ≤ (r/2)² (cuarto de círculo en cuadrante 3)
                        double radius = s * (rVal / 2);
                        String arc = "<path class=\"area\" d=\"M 0,0 A "+radius+","+radius+" 0 0,1 "+(-radius)+",0 L 0,0 Z\"/>";

                        out.print(rect + tri + arc);
                    }
                } %>
            </g>
            <g id="pointsGroup"></g>

            <!-- Draw all historical points using scrip.js functions -->
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    // Usar la misma lógica de renderizado de scrip.js
                    renderHistoryFromStorage();
                });

                // Función para renderizar puntos desde almacenamiento
                function renderHistoryFromStorage() {
                    const pointsGroup = document.getElementById('pointsGroup');
                    if (pointsGroup) {
                        pointsGroup.innerHTML = '';

                        // Intenta obtener datos de sessionStorage, si no de localStorage
                        let histData = sessionStorage.getItem('histData');
                        if (!histData) {
                            histData = localStorage.getItem('histData');
                        }

                        if (histData) {
                            const history = JSON.parse(histData);
                            const scale = 30; // 30px por unidad

                            history.forEach(function(item) {
                                const dot = item.dot;
                                const ans = item.ans;

                                const xVal = parseFloat(dot.x);
                                const yVal = parseFloat(dot.y);
                                const cx = xVal * scale;
                                const cy = -yVal * scale; // Y está invertido en SVG
                                const color = ans.result === 'IN' ? 'green' : 'red';

                                const circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
                                circle.setAttribute('cx', cx);
                                circle.setAttribute('cy', cy);
                                circle.setAttribute('r', 4);
                                circle.setAttribute('fill', color);
                                circle.setAttribute('stroke', 'black');
                                circle.setAttribute('stroke-width', '0.5');

                                pointsGroup.appendChild(circle);
                            });
                        }
                    }
                }
            </script>

            <!-- Draw the result point -->
            <% if (errorMessage == null) {
                String x = (String) request.getAttribute("x");
                String y = (String) request.getAttribute("y");
                String r = (String) request.getAttribute("r");
                if (x != null && y != null && r != null) {
                    double xVal = Double.parseDouble(x);
                    double yVal = Double.parseDouble(y);
                    double rVal = Double.parseDouble(r);
                    double scale = 30; // 30px per unit
                    double cx = xVal * scale;
                    double cy = -yVal * scale; // Y is inverted in SVG
                    String hitResult = (String) request.getAttribute("hit");
                    String color = "IN".equals(hitResult) ? "green" : "red";
            %>
                <circle cx="<%= cx %>" cy="<%= cy %>" r="4" fill="<%= color %>" stroke="black" stroke-width="0.5"/>
            <%
                }
            } %>
        </svg>
    </div>
</div>

<% if (errorMessage != null) { %>
    <div class="error-box">
        <h3>Processing Failed!</h3>
        <p>⚠️ <%= errorMessage %></p>
    </div>
<% } %>

<table>
    <tr><th>X Coordinate</th><td><%= request.getAttribute("x") %></td></tr>
    <tr><th>Y Coordinate</th><td><%= request.getAttribute("y") %></td></tr>
    <tr><th>R Parameter</th><td><%= request.getAttribute("r") %></td></tr>

    <tr><th>Hit Result</th>
        <td>
            <% if (errorMessage != null) { %>
                <span style="color: #ff4757;">FAILED/N/A</span>
            <% } else {
                String hitResult = (String) request.getAttribute("hit");
                String color = "IN".equals(hitResult) ? "#50fa7b" : "#ffb86c";
            %>
                <span style="color: <%= color %>; font-weight: 700;"><%= hitResult %></span>
            <% } %>
        </td>
    </tr>

    <tr><th>Attempt Date</th>
        <td>
            <%
                String date = (String) request.getAttribute("date");
                out.print(date == null ? "N/A" : date);
            %>
        </td>
    </tr>

    <tr><th>Execution Time</th>
        <td>
            <%
                String execTime = (String) request.getAttribute("execTime");
                out.print(execTime == null ? "N/A" : execTime + " ms");
            %>
        </td>
    </tr>
</table>

<br>
<a href="controllerS">Back to form</a>

<script src="./scrip.js"></script>
</body>
</html>