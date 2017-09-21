public with sharing class UPScalloutViewer_Controller {
    
    public String requestEndpoint {get;set;}
    public String requestMethod {get;set;}
    public String requestBody {get;set;}
    public String responseStatus {get;set;}
    public Integer responseStatusCode {get;set;}
    public String responseBody {get;set;}
    public stackExchangeAPI.responseResource response {get;set;}
    public List<stackExchangeAPI.questionResource> deserializedQuestions {get;set;}
    
    public UPScalloutViewer_Controller(){
        requestEndpoint = 'https://wwwcie.ups.com/rest/Track';
        //requestEndpoint = 'https://th-apex-http-callout.herokuapp.com/animals';
        requestMethod = 'GET';
        requestBody = '';
    }

    public void callout(){
        httpResponse res = new httpResponse();
        if (requestMethod == 'GET') res = makeGetCallout(requestEndpoint);
        if (requestMethod == 'POST') res = makePostCallout(requestEndpoint,requestBody);
        responseStatus = res.getStatus();
        responseStatusCode = res.getStatusCode();
        responseBody = res.getBody();
    }
    
    public void deserializeQuestions(){
        if (string.isNotBlank(responseBody) ){
            response = (stackExchangeAPI.responseResource)JSON.deserialize(responseBody,stackExchangeAPI.responseResource.class);
            deserializedQuestions = response.items;
        }   
    }
    
    public void deserializeData(){
        if (string.isNotBlank(responseBody) ){
            response = (stackExchangeAPI.responseResource)JSON.deserialize(responseBody,stackExchangeAPI.responseResource.class);
            deserializedQuestions = response.items;
        }   
    }
    
    public List<SelectOption> getMethodOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('GET','GET'));
        options.add(new SelectOption('POST','POST'));
        options.add(new SelectOption('PUT','PUT'));
        options.add(new SelectOption('DELETE','DELETE'));
        options.add(new SelectOption('HEAD','HEAD'));
        return options;
    }
    
    public static HttpResponse makeGetCallout(String requestEndpoint) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestEndpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            system.debug('results =====> '+results);
        }
        return response;
    }
    
    public static HttpResponse makePostCallout(String requestEndpoint,String requestBody) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestEndpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(requestBody);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        return response;
    }
}