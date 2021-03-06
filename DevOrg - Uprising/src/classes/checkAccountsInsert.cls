@RestResource(urlMapping='/showAccountDetailsInsert/*')
global class checkAccountsInsert {

    @HttpGet
    global static Account doGet() {
    
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastindexOf('/')+1);
        System.debug('Account Id: '+accountId);
        Account result = [Select Id,name,phone,website from Account where Id = :accountId];
        return result;
    }
    
    @HttpPost
    global static String doPost(String name,String phone,String AccountNumber) {
    
        Account acc = new Account();
        acc.name = name;
        acc.phone = phone;
        acc.AccountNumber = AccountNumber;
        insert acc;
        return acc.id;
    }

}