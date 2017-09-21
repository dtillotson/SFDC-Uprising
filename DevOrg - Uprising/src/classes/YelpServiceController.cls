public class YelpServiceController {

    @AuraEnabled
    public static String getListByLatLon(String latLon, String searchTerm) {
        String url = 'https://grewis-yelp.herokuapp.com/search?address='+ latLon +'&term='+ EncodingUtil.urlEncode(searchTerm, 'UTF-8');
        
        String resultList = getHttp(url);
        return resultList;
    }
    
    @AuraEnabled
    public static String getListByAddress(String address, String searchTerm) {
    
        try{
            String url = 'https://grewis-yelp.herokuapp.com/search?address='+ EncodingUtil.urlEncode(address, 'UTF-8') +'&term='+ EncodingUtil.urlEncode(searchTerm, 'UTF-8');
        
            String resultList = getHttp(url);
            return resultList;
        }
        catch (exception ex) {
            return '{"error": "'+ ex.getMessage() +'"}';
        }
    }
    
    private static String getHttp (String url) {
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(url);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res.getBody();
    }

}