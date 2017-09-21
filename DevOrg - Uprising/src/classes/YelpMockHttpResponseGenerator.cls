@isTest
global class YelpMockHttpResponseGenerator implements HttpCalloutMock {

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
    
        // Optionally, only send a mock response for a specific endpoint and method
        System.assertEquals('https://grewis-yelp.herokuapp.com/', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        // Create a fake response
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type','application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }
}