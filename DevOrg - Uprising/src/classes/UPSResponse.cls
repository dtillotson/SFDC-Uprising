public class UPSResponse {

    public TrackResponse TrackResponse;

    public class TrackResponse {
        public Response response;
        public Shipment shipment;
        public String Disclaimer;
    }

    public class Response {
        public ResponseStatus responseStatus;
        public TransactionReference transactionReference;
    }

    public class ResponseStatus {
        public String Code;
        public String Description;
    }

    public class TransactionReference {
        public String CustomerContext;
    }

    public class Shipment {
        public InquiryNumber inquiryNumber;
        //public ShipmentType shipmentType;
        public String ShipperNumber;
        //public List<ShipmentAddress> shipmentAddress;
        public ShipmentWeight shipmentWeight;
        public Service service;
        //public ReferenceNumber referenceNumber;
        public String PickupDate;
        //public List<Package1> package1;
    }

    public class InquiryNumber {
        public String Code;
        public String Description;
        public String Value;
    }

    public class ShipmentAddress {
        public Type type;
        public Address address;
    }

    public class Type {
        public String Code;
        public String Description;
    }

    public class Address {
        public String AddressLine;
        public String City;
        public String StateProvinceCode;
        public String PostalCode;
        public String CountryCode;

    }

    public class ShipmentType {
        public String Code;
        public String Description;
    }

    public class ShipmentWeight {
        public UnitOfMeasurement unitOfMeasurement;
        public String Weight;
    }

    public class UnitOfMeasurement {
        public String Code;
    }

    public class Service {
        public String Code;
        public String Description;
    }

    public Class Package1 {
        public String TrackingNumber;
        public List<Activity> activity;
        public PackageWeight packageWeight;
        public List<ReferenceNumber> referenceNumber;
    }

    public class Activity {
        public ActivityLocation activityLocation;
        public Status status;
        public String DateStr;
        public String TimeStr;
    }

    public class ActivityLocation {
        public Address address;
    }

    public class Status {
        public String Type;
        public String Description;
        public String Code;
    }

    public class PackageWeight {
        public UnitOfMeasurement UnitOfMeasurement;
        public String Weight;
    }

    public class ReferenceNumber {
        public String Code;
        public String Value;
    }


    public static UPSResponse parse(String json) {
        return (UPSResponse) System.JSON.deserialize(json, UPSResponse.class);
    }
}