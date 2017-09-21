public without sharing class PartnerLeadActions {
	
	public static void addLeadSharingRules(String leadId){
		
		List<LeadShare> sharingRules = new List<LeadShare>();
		
		//Get list of lead ids and creators
        List<Lead> PartnerLeads = [SELECT Id, OwnerId, CreatedById, CreatedBy.UserRoleId FROM Lead WHERE Id = :leadId];
        
        //now lets build out the sharing rules
        for (Lead assign: PartnerLeads)
        {
            if(UserInfo.getUserId() <> assign.OwnerId)
            {
            	/*
            	Record-level sharing settings can only be used to grant more permissive access to records. Record-level sharing settings 
            	cannot be used to restrict access to records. This also means that sharing settings can only be implemented for objects 
            	whose object-level sharing defaults are restricted – i.e. either Public Read Only or Private. It is not necessary to grant 
            	additional permissions on objects that have a default sharing access of Public Read/Write because users already have 
            	read/write default access.
            	(Code is commented out below because Lead sharing is currently set to "Public Read/Write/Transfer")
            	*/
            	
            	//String RoleId = UserInfo.getUserRoleId();
            	//system.debug('RoleId =====> ' + RoleId);
            	//system.debug('RoleId from Query =====> ' + assign.CreatedBy.UserRoleId);
                LeadShare leadshare = new LeadShare();
                //Get the RoleId of the user who created the lead
                String RoleId = assign.CreatedBy.UserRoleId;
                //Need the group ID of the Role in order to set the manual sharing rule correctly
                String GroupId = [SELECT Id FROM Group WHERE RelatedId = :RoleId AND Type = 'Role'].Id;
                //LeadShare.LeadAccessLevel = 'Read';
                //LeadShare.UserOrGroupId = assign.CreatedById;
                //LeadShare.UserOrGroupId = GroupId;
                //LeadShare.LeadId = assign.Id;
                sharingRules.add(LeadShare);
                
            }
        }
            //insert sharingRules;
		
	}
	
	public static void deleteLeadSharingRules(String userId, String leadId){
		
		List<LeadShare> sharingToDelete = [SELECT Id FROM LeadShare WHERE LeadId = :leadId AND UserOrGroupId = :userId AND RowCause = 'Manual'];
        //delete sharingToDelete;
		
	}
	
	
	@isTest
    static public void testLeadSharing() {
        //Create test Partner Account
    	Account testAccount = new Account();
    	testAccount.Name = 'TestPartner9999';
    	testAccount.Type = 'Partner';
    	//testAccount.Sub_Type__c = 'Gold';
    	insert testAccount;
    	
    	//Create Contact to use with Portal User
    	Contact testContact = new Contact();
    	testContact.LastName = 'Test' + Datetime.now().format('MMddyyyy-HHmmssSSS');
    	testContact.AccountId = testAccount.Id;
    	//testContact.CurrencyIsoCode = 'USD';
    	//testContact.Status__c = 'Marketing Qualified';
    	testContact.LeadSource = 'Email';
    	insert testContact;
    	    	
        //Create User to share records with     
        User testUser = new User();
        testUser.LastName = testContact.LastName;
        testUser.Alias = testUser.LastName.right(8);
        testUser.LocaleSidKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/New_York';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.Username = testUser.LastName + '@test.com';
        testUser.Email = testUser.Username;
        testUser.ContactId = testContact.Id;
        testUser.ProfileId = [SELECT Id FROM Profile Where name = 'Partner Portal Community User'].Id;
        insert testUser;
        
        Lead newLead = new Lead();
        newLead.OwnerId = testUser.id;
        newLead.LastName = 'LastNameTest';
        newLead.company = 'TestCompany';
        insert newLead;
        
        addLeadSharingRules(newLead.id);
        
        newLead.OwnerId = UserInfo.getUserId();
        update newLead;
        
        deleteLeadSharingRules(testUser.Id, newLead.Id);
        
    }

}