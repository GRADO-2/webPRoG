package org.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.utilities.VerifyHit;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


@WebServlet("/areaCheckerS")
public class AreaChecker extends HttpServlet {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    protected void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long time_start = System.nanoTime();

        if ("true".equals(req.getParameter("clear_history"))) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("history");
            }

            resp.sendRedirect(req.getContextPath() + "/controllerS");
            return;
        }

        String xParam = req.getParameter("x");
        String yParam = req.getParameter("y");
        String rParam = req.getParameter("rad");

        try {
            if (xParam == null || yParam == null || rParam == null || xParam.isEmpty() || yParam.isEmpty() || rParam.isEmpty()) {
                throw new IllegalArgumentException("Missing coordinates (X, Y, R).");
            }

            BigDecimal x = new BigDecimal(xParam);
            BigDecimal y = new BigDecimal(yParam);
            BigDecimal r = new BigDecimal(rParam);

            VerifyHit verifyHit = new VerifyHit();
            verifyHit.validate(x, y, r);
            long time_end = System.nanoTime();
            String execTime = String.format("%.3f", (time_end - time_start) / 1_000_000.0);
            boolean hit = verifyHit.pointchecker(x, y, r);
            String resultText = hit ? "IN" : "OUT";

            req.setAttribute("x", x.toString());
            req.setAttribute("y", y.toString());
            req.setAttribute("r", r.toString());
            req.setAttribute("hit", resultText);
            req.setAttribute("date", LocalDateTime.now().format(DATE_FORMATTER));
            req.setAttribute("execTime", execTime);

            // Create PointResult and store in session
            org.example.utilities.PointResult pointResult = new org.example.utilities.PointResult(
                x.toString(), 
                y.toString(), 
                r.toString(), 
                hit, 
                LocalDateTime.now().format(DATE_FORMATTER), 
                (time_end - time_start) / 1_000_000.0
            );

            HttpSession session = req.getSession(true);
            java.util.List<org.example.utilities.PointResult> history = 
                (java.util.List<org.example.utilities.PointResult>) session.getAttribute("history");
            
            if (history == null) {
                history = new java.util.ArrayList<>();
            }
            
            history.add(pointResult);
            session.setAttribute("history", history);

            req.getRequestDispatcher("/result.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error_message", "ERROR: " + e.getMessage());

            req.setAttribute("x", xParam != null ? xParam : "N/A");
            req.setAttribute("y", yParam != null ? yParam : "N/A");
            req.setAttribute("r", rParam != null ? rParam : "N/A");
            req.setAttribute("hit", "FAILED");

            req.getRequestDispatcher("/result.jsp").forward(req, resp);
        }
    }
}