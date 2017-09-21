public class UPSfaultResponse {

    public Fault Fault;

    public class Fault {
        public String faultcode;
        public String faultstring;
        public Detail detail;
    }

    public class Detail{
        public Errors errors;
    }

    public class Errors {
        public ErrorDetail ErrorDetail;

    }

    public class ErrorDetail {
        public String Severity;
        public PrimaryErrorCode PrimaryErrorCode;
    }
    
    public class PrimaryErrorCode {
        public String Code;
        public String Description;
    }

    public static UPSfaultResponse parse(String json) {
        return (UPSfaultResponse) System.JSON.deserialize(json, UPSfaultResponse.class);
    }
}