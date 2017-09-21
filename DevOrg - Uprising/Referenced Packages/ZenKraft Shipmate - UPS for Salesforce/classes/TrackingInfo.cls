/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TrackingInfo {
    global List<zkups.Checkpoint> checkpoints {
        get;
        set;
    }
    global Boolean isDelivered {
        get;
        set;
    }
    global String status {
        get;
        set;
    }
    global String statusCode {
        get;
        set;
    }
    global List<zkups.TrackingInfo.StatusDetailInfo> statusDetailList {
        get;
        set;
    }
    global List<String> statusDetails {
        get;
        set;
    }
    global String trackingNumber {
        get;
        set;
    }
    global TrackingInfo() {

    }
global class StatusDetailInfo {
    global String deliveryLocationDescription {
        get;
        set;
    }
    global String deliverySignatureFormat {
        get;
        set;
    }
    global String deliverySignatureName {
        get;
        set;
    }
    global Datetime estimatedDeliveryTimestamp {
        get;
        set;
    }
    global Date scheduledDeliveryDate {
        get;
        set;
    }
    global String serviceInfo {
        get;
        set;
    }
    global Date shipTimestamp {
        get;
        set;
    }
    global StatusDetailInfo() {

    }
}
}
