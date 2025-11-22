package org.example.utilities;

public class PointResult {
    private String x;
    private String y;
    private String r;
    private boolean hit;
    private String attemptTime;
    private double executionTime;

    public PointResult(String x, String y, String r, boolean hit, String attemptTime, double executionTime) {
        this.x = x;
        this.y = y;
        this.r = r;
        this.hit = hit;
        this.attemptTime = attemptTime;
        this.executionTime = executionTime;
    }

    public String getX() {
        return x;
    }

    public String getY() {
        return y;
    }

    public String getR() {
        return r;
    }

    public boolean isHit() {
        return hit;
    }

    public String getHitResult() {
        return hit ? "IN" : "OUT";
    }

    public String getAttemptTime() {
        return attemptTime;
    }

    public double getExecutionTime() {
        return executionTime;
    }


}