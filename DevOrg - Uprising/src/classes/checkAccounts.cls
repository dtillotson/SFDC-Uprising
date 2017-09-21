@RestResource(urlMapping='/showAccountDetails/*')
global class checkAccounts {

    @HttpGet
    global static List<Account> getAccount() {
    
        List<Account> accts;
        try {
            accts=[select name,phone from Account];
            return accts;
        }
        catch (Exception ex) {
            system.debug('Error '+ex.getMessage());
        }
        return accts;
    }

}