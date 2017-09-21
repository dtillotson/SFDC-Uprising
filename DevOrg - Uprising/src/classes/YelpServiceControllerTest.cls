@isTest
private class YelpServiceControllerTest {
    
    static testmethod void test1() {
    
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String searchTerm = 'Restaurant';
        String latLon = '37.7935226, -122.3966302';
        YelpServiceController.getListByLatLon(latLon, searchTerm);
        
        String address = '136 Brecon Court, Redwood City, CA 94062';
        YelpServiceController.getListByAddress(address, searchTerm);
    
    }

}