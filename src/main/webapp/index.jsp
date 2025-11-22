<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, org.example.utilities.PointResult" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Check the position of your point</title>
    <link rel="stylesheet" href="./css/index.css">
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
                    <line x1="-150" y1="0" x2="150" y2="0" stroke="black" stroke-width="1"/>
                    <line x1="0" y1="-150" x2="0" y2="150" stroke="black" stroke-width="1"/>
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