<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
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
            <!-- R boundaries -->
            <text x="100" y="-10" font-size="10" fill="blue">R</text>
            <text x="100" y="10" font-size="10" fill="blue">R</text>
            <text x="-110" y="-10" font-size="10" fill="blue">R</text>
            <text x="-110" y="10" font-size="10" fill="blue">R</text>
            
            <text x="10" y="110" font-size="10" fill="blue">R</text>
            <text x="10" y="-110" font-size="10" fill="blue">R</text>
            <text x="-15" y="110" font-size="10" fill="blue">R</text>
            <text x="-15" y="-110" font-size="10" fill="blue">R</text>
            
            <!-- R/2 boundaries -->
            <text x="50" y="-10" font-size="10" fill="red">R/2</text>
            <text x="50" y="10" font-size="10" fill="red">R/2</text>
            <text x="-60" y="-10" font-size="10" fill="red">R/2</text>
            <text x="-60" y="10" font-size="10" fill="red">R/2</text>
            
            <text x="10" y="60" font-size="10" fill="red">R/2</text>
            <text x="10" y="-60" font-size="10" fill="red">R/2</text>
            <text x="-15" y="60" font-size="10" fill="red">R/2</text>
            <text x="-15" y="-60" font-size="10" fill="red">R/2</text>
            
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
                        
                        // Sector circular: x ≥ 0, y ≤ 0, x² + y² ≤ (r/2)² (cuarto de círculo en cuadrante 4)
                        double radius = s * (rVal / 2);
                        String arc = "<path class=\"area\" d=\"M "+radius+",0 A "+radius+","+radius+" 0 0,1 0,"+radius+" L 0,0 Z\" transform=\"translate(0, "+(-radius)+")\"/>";
                        
                        out.print(rect + tri + arc);
                    }
                } %>
            </g>
            <g id="pointsGroup"></g>
            
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

</body>
</html>
