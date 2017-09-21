public with sharing class LeadConvertController {
    
    public lead oLead {get;set;}
    public Task tsk {get;set;}
    public boolean sendEmailToOwner{get;set;}
    public boolean sendNotificationEmail{get;set;}
    public boolean donotCreateNewOpty{get;set;}
    public boolean createNewAccount{get;set;}
    public Contact dummyContact {get;set;}
    public String convertedStatus {get;set;}
    public String OpportunityName {get;set;}
    public list<SelectOption> lstConvertedStatus {get;set;}
    public Boolean subjectEntered {get;set;}
    
    private Id leadId;
    private String profileName;
    private String defaultRecordTypeName;
    private map<String,String> mapConvertStatus = new map<String,String>();
    private map<String,String> mapProfileWiseRecordType = new map<String,String>();
    private map<String,list<String>> mapRecordTypeWiseLeadStatus = new map<String,list<String>>();
  
    public LeadConvertController (ApexPages.StandardController stdController)  {
        System.debug('gcaLeadConvertController --> Constructor');
        leadId = ApexPages.currentPage().getParameters().get('id');
        oLead = [SELECT Id,OwnerId,Company,Name,FirstName,LastName,Status,country,street,
                 city,postalcode,state,Website,Phone,Fax,Email 
                 FROM Lead WHERE id = :leadid];
        /*
        oLead = [SELECT Id,OwnerId,Company,Name,FirstName,LastName,Status,country,street,
                 city,postalcode,state,Website,Phone,Fax,Email,RecordtypeId,Recordtype.Name 
                 FROM Lead WHERE id = :leadid];
        */
        sendEmailToOwner = false;
        dummyContact = new Contact();
        tsk = new Task();
        tsk.IsReminderSet = true;
        tsk.ReminderDateTime = System.now();
        donotCreateNewOpty = false;
        createNewAccount = true;
        subjectEntered = false;
        convertedStatus = '';
        OpportunityName = oLead.Company + '-';
        lstConvertedStatus = new list<SelectOption>();
        
        for(LeadStatus convertStatus :[Select Id, MasterLabel,IsDefault from LeadStatus where IsConverted=true order by MasterLabel]){
           if(convertStatus.IsDefault){
            lstConvertedStatus.add(0,new SelectOption(convertStatus.Id,convertStatus.MasterLabel));
           }
           else{
             lstConvertedStatus.add(new SelectOption(convertStatus.Id,convertStatus.MasterLabel));
           }
           mapConvertStatus.put(convertStatus.Id,convertStatus.MasterLabel);
        }
    }
    
    public PageReference DoConvert()  {
        System.debug('EnablePath --> DoConvert Entered.');
        boolean validated = true;
        boolean isLeadUpdateRequired = false;
        
        if(createNewAccount){
            Account acc = new Account();
              acc.Type = null;
              acc.name = oLead.company;
              
              acc.ShippingStreet = null;
              acc.ShippingCity = null;
              acc.ShippingPostalCode = null;
              acc.ShippingState = null;
              //acc.Shipping_County__c = null;
              
              if(!test.isRunningTest()){
                acc.shippingcountry = null;
              }
              else{
                acc.shippingcountry = oLead.country;
              }
              
              acc.BillingCountry = oLead.country;
              acc.BillingStreet = oLead.street;
              acc.BillingCity = oLead.city;
              acc.BillingPostalCode = oLead.postalcode;
              acc.BillingState = oLead.state;
              acc.Website = oLead.Website;
              acc.Phone = oLead.Phone;
              acc.Fax = oLead.Fax;
              //acc.RecordTypeId = '01200000000DFyX';
        }
        return null;
    }

}