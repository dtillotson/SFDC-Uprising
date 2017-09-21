@RestResource(urlMapping='/showAccountDetails2/*')
global class checkAccounts2 {

    @HttpGet
    global static Account doGet() {
    
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastindexOf('/')+1);
        System.debug('Account Id: '+accountId);
        Account result = [Select Id,name,phone,website from Account where Id = :accountId];
        return result;
    }

}