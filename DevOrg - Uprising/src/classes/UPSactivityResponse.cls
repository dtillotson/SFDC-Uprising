public class UPSactivityResponse {

    public Activity Activity;

    public class Activity {
        public ActivityLocation activityLocation;
        public Status Status;
        public String DateStr;
        public String TimeStr;
    }

    public class ActivityLocation {
        public Address address;
    }

    public class Address {
        public String AddressLine;
        public String City;
        public String StateProvinceCode;
        public String PostalCode;
        public String CountryCode;

    }

    public class Status {
        public String Type;
        public String Description;
        public String Code;
    }

    public static UPSactivityResponse parse(String json) {
        return (UPSactivityResponse) System.JSON.deserialize(json, UPSactivityResponse.class);
    }
}