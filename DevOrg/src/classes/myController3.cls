public with sharing class myController3 {

    private final Id accountId ;
    transient public final String accountName {get; set; }
    
    public myController3() {
        Account account = [select Id, Name from Account where id = :ApexPages.currentPage().getParameters().get('id')];
        accountId = account.Id ;
        accountName = account.Name ;
    }
    
    public PageReference save() {
        Account myAccount = [select name from Account where id = :accountId];
        myAccount.name = accountName ;
        update myAccount;
        return null;
    }

}