<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Result</title>
    <style>
        /* --- Estilos Globales y de Fondo (Tomados del CSS Principal) --- */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        body {
            background: #121212; /* Fondo Oscuro */
            color: #e0e0e0; /* Color de texto claro */
            line-height: 1.6;
            padding: 40px; /* Más padding para que no esté pegado a los bordes */
        }

        /* --- Estilo del Encabezado (H2) --- */
        h2 {
            color: #7a5cf0; /* Morado para títulos */
            font-weight: 500;
            text-align: center;
            margin-bottom: 25px;
            font-size: 1.8em;
        }

        /* --- Estilo de la Tabla de Resultados --- */
        table {
            width: 50%; /* Ancho fijo para la tabla */
            margin: 0 auto 30px auto; /* Centrar y añadir margen inferior */
            border-collapse: collapse;
            border: 1px solid rgba(255,255,255,0.1); /* Borde suave */
            background: #1e1e1e; /* Fondo oscuro sutil */
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
            border-radius: 8px;
            overflow: hidden; /* Para que border-radius funcione en el borde */
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #333; /* Separador de filas */
        }

        th {
            background: #121212; /* Fondo más oscuro para encabezados de columna */
            color: #aaa; /* Color tenue para las etiquetas */
            font-weight: 400;
            width: 35%; /* Ancho de la columna de la etiqueta */
        }

        td {
            color: #fff; /* Blanco brillante para los valores */
            background: #1e1e1e;
            font-weight: 500;
        }

        /* --- Estilo de la Caja de Error --- */
        .error-box {
            border: 1px solid #ff4757; /* Borde rojo del error */
            padding: 15px;
            background-color: rgba(255, 71, 87, 0.15); /* Fondo rojo claro */
            color: #ff4757; /* Texto rojo */
            margin: 0 auto 20px auto;
            width: 50%;
            border-radius: 6px;
        }

        .error-box h3 {
            color: #ff4757;
            margin-bottom: 5px;
            font-weight: 600;
        }

        /* --- Estilo del Enlace "Back to form" --- */
        a {
            display: block;
            width: 250px;
            margin: 30px auto 0 auto;
            text-align: center;
            padding: 10px 20px;
            border-radius: 6px;
            background: #7a5cf0; /* Morado principal */
            color: #fff;
            text-decoration: none;
            font-weight: 500;
            transition: background 0.2s;
        }

        a:hover {
            background: #6a4ce0;
        }
    </style>
</head>
<body>

<%
    // Captura el mensaje de error si existe para la lógica condicional
    String errorMessage = (String) request.getAttribute("error_message");
%>

<h2>Resultados de la Verificación de Área</h2>

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
