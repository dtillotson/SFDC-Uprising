public class myController5 {

    transient DateTime currentDateTime;

    public String getCurrentDateTime() {
        if (currentDateTime == null) currentDateTime = System.now();
        return '' + currentDateTime;
    }
}