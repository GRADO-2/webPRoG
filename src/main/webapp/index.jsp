<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, org.example.utilities.PointResult" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Check the position of your point</title>
    <link rel="stylesheet" type="text/css" href="css/index.css">
</head>
<body>

    <div id="student-header">
        <p>Кантунья Жан Карло Саласар | P3120 | 2012</p>
    </div>

    <div class="header">
        <h1 id="title">Check the position of your point</h1>
    </div>

    <div class="content">

        <div class="image-container">
            <div id="coordsPloter"></div>
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
                    <g id="areaGroup"></g>
                    <g id="pointsGroup"></g>
                </svg>
        </div>

        <div id="histContainer" class="hist-container">
            <div class="hist-header-bar">
                <span>History</span>
                <button type="button" id="flushHist" class="hist-flush-btn" onclick="clearHistory()">Clear History</button>
            </div>
            <table name="histTable" class="history-table">
                <thead>
                    <tr class="hist-header">
                        <th>X</th>
                        <th>Y</th>
                        <th>R</th>
                        <th>Result</th>
                        <th>Date</th>
                        <th>Exec Time (ms)</th>
                    </tr>
                </thead>
                <tbody>
                    <%--
                        Lógica JSP para iterar sobre el historial
                        (Asumiendo que el historial se guarda en la SESIÓN con la clave "history")
                    --%>
                    <%
                        List<PointResult> history = (List<PointResult>) session.getAttribute("history");
                        if (history != null) {
                            for (PointResult result : history) {
                    %>
                                <tr>
                                    <td><%= result.getX() %></td>
                                    <td><%= result.getY() %></td>
                                    <td><%= result.getR() %></td>
                                    <td><%= result.isHit() ? "Hit" : "Miss" %></td>
                                    <td><%= result.getAttemptTime() %></td>
                                    <td><%= result.getExecutionTime() %></td>
                                </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <form id="form" class="form-group" method="GET" action="controllerS">

        <input type="hidden" name="x" id="x_hidden_input">

        <div name="x-selector">
            <h3>Select X</h3>
            <div class="buttons_group">
                <%
                    String[] xValues = {"-4", "-3", "-2", "-1", "0", "1", "2", "3", "4"};
                    for (String val : xValues) {
                %>
                        <label>
                            <input type="button" class="x-btn" data-x-val="<%= val %>" value="<%= val %>">
                        </label>
                <%
                    }
                %>
            </div>
            <span class="error-message" id="x-error"></span>
        </div>

        <div class="input-group">
            <h3>Select Y</h3>
            <label class="input-label">

                <input type="text" name="y" id="y_input" placeholder="Enter Y value (-5 to 5)">
                <span class="error-message" id="y-error"></span>
            </label>
        </div>

        <div class="input-group">
            <h3>R</h3>
            <label class="input-label">

                <input type="text" name="rad" id="r_input" placeholder="Enter R value (2 to 5)">
                <span class="error-message" id="rad-error"></span>
            </label>
        </div>

        <div class="button-group">
            <button type="submit" class="form-button">Send</button>
            <button type="reset" class="form-button">Clear</button>
        </div>
    </form>

    <script src="./scrip.js"></script>
</body>
</html>