global class CallExternalWebservice
{
     webservice static void submitMoranOrder(String OrderId, String ExtURL)
     {

          // create the http request and http object variables
          HttpRequest req = new HttpRequest();
          Http http = new Http();
          // set the method
          req.setMethod('GET');
          // generate the url for the request
          String url = ExtURL+OrderId;
          system.debug('url ====> '+url);

          // add the endpoint to the request
          req.setEndpoint(url);
          // create the response object
          HTTPResponse resp = http.send(req);
          // get the resulting status and status code from the http response
          String respStatus = resp.getStatus();
          Integer respStatusCode = resp.getStatusCode();

          system.debug('response ====> '+resp);
          system.debug('Status ====> '+respStatus);
          system.debug('StatusCode ====> '+respStatusCode);

          //get the list of header names (keys)
          string[] headerkeys = resp.getHeaderKeys();
          //system.debug('headerkeys =====> '+headerkeys);

          //create an object to store your header key-value pairs
          Map<string, string> headers = new map<string, string>();

          //iterate through they keys, and populate your map
          for(string s : headerkeys){
               if (s != null) {
                    headers.put(s,resp.getHeader(s));
                    //system.debug('header: ' + s + ' value: ' + resp.getHeader(s));
               }
          }

          // call method to update the order status if response was clean (Status Code = 204)
          if (respStatusCode == 204) updateOrder(OrderId);
     }

     public static void updateOrder(String OrderId) {
          // Update the corresponding Order record to indicate successful transfer to Moran Printing
          Order orderToUpdate = new Order();
          orderToUpdate.Id = OrderId;
          orderToUpdate.Order_Status__c = 'Sent To Moran';
          update orderToUpdate;
     }
}