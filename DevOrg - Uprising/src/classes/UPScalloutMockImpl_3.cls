global class UPScalloutMockImpl_3 implements HttpCalloutMock
{
    global HTTPResponse respond(HTTPRequest req)
    {
        HttpResponse res = new HttpResponse();
        res.setHeader('content-type','application/json');
        res.setStatusCode(200);
        String json = '{"Fault":{"faultcode":"Client", "faultstring":"An exception has been raised as a result of client data.", "detail":{"Errors":{"ErrorDetail":{"Severity":"Hard", "PrimaryErrorCode":{"Code":"9150002", "Description":"Invalid or missing inquiry number - TrackingNumber, ShipmentIdentificationNumber, or ReferenceNumber"}}}}}}';
        res.setBody(json);
        return res;
    }
}