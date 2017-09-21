/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ValidateAddressResult {
    global zkups.ValidateAddressResult.AddressClassification classification {
        get;
        set;
    }
    global String message {
        get;
        set;
    }
    global List<zkups.ValidateAddressResult.AddressValidationResult> results {
        get;
        set;
    }
    global Boolean success {
        get;
        set;
    }
    global ValidateAddressResult() {

    }
global class AddressClassification {
    global String code {
        get;
        set;
    }
    global String description {
        get;
        set;
    }
    global AddressClassification() {

    }
}
global class AddressValidationResult {
    global String addressLine1 {
        get;
        set;
    }
    global String addressLine2 {
        get;
        set;
    }
    global String city {
        get;
        set;
    }
    global String country {
        get;
        set;
    }
    global String description {
        get;
        set;
    }
    global String postalCode {
        get;
        set;
    }
    global String state {
        get;
        set;
    }
    global AddressValidationResult() {

    }
}
}
