package org.example.utilities;

public class Result {
        String result;
        String contentType;
        String x;
        String y;
        String r;
        String date;
        String timeExecution;

        public Result (String result) {
            this.result = result;
        }
        public  Result (){

        }
        public void setResult(String result){
            this.result = result;
        }
        public void setR(String r){
            this.r = r;
        }
        public void setDate(String date){
            this.date = date;
        }
        public void setTimeExecution(String timeExecution){
            this.timeExecution = timeExecution;
        }
        public void setX(String x){
            this.x =  x;
        }

        public void setY(String y){
            this.y = y;
        }
        public void setContentType(String contentType){
            this.contentType = contentType;
        }

        public String getAnswer() {
            return String.format("{\"result\":\"%s\", \"contentType\":\"%s\", \"x\":\"%s\", \"y\":\"%s\", \"r\":\"%s\", \"date\":\"%s\", \"timeExecution\":\"%s\"}",
                    result != null ? result : "",
                    contentType != null ? contentType : "",
                    x != null ? x : "",
                    y != null ? y : "",
                    r != null ? r : "",
                    date != null ? date : "",
                    timeExecution != null ? timeExecution : "");
        }

        public String getErrorAnswer(String error) {
            return String.format("{\"error\":\"%s\"}", error != null ? error : "");
        }
}
