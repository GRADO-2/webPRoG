package org.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.ServletException;
import java.io.IOException;

@WebServlet(name = "ControllerServlet", value = "/controllerS")
public class ControllerServlet extends HttpServlet {

    private void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String clearHistory = req.getParameter("clear_history");
        if ("true".equals(clearHistory)) {
            req.getRequestDispatcher("/areaCheckerS").forward(req, resp);
            return;
        }

        String x = req.getParameter("x");
        String y = req.getParameter("y");
        String r = req.getParameter("rad");

        if (x == null || y == null || r == null || x.isEmpty() || y.isEmpty() || r.isEmpty()) {
            req.getRequestDispatcher("/index.jsp").forward(req, resp);

        } else {

            req.getRequestDispatcher("/areaCheckerS").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        processRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        processRequest(req, resp);
    }
}