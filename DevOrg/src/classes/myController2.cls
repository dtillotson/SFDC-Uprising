public with sharing class myController2 {
   public final Account account {get; set;}

   public myController2() {
        account = [select name from Account where id = :ApexPages.currentPage().getParameters().get('id')];
    }
    public PageReference save() {
        update account;
        return null;
    }
}