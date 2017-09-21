public without sharing class PartnerLeadConversionActions {
	
	public static void addPartnerSharing (List<Lead> newTrigger) {
		
		List<AccountShare> lAccShare = new List<AccountShare>();
		map<id,set<id>> acctShares = new map<id,set<id>>();
        set<id> acctIds = new set<id>();
		
		for(Lead l1 : newTrigger)
        {
	        if(l1.OwnerId != l1.CreatedById)
	        {
				acctIds.add(l1.ConvertedAccountId);	
				
        		if(!acctShares.containsKey(l1.CreatedById)) acctShares.put(l1.CreatedById,new set<id>());
        		
        		acctShares.get(l1.CreatedById).add(l1.ConvertedAccountId);				 				
	        }
        }
        
        if(!acctIds.isempty())
        {
        	map<id,set<id>> acctOwners = new map<id,set<id>>();
        	for(Account a:[select id,OwnerId from account where id in :acctIds])
        	{
        		if(!acctOwners.containsKey(a.OwnerId)) acctOwners.put(a.OwnerId,new set<id>());
        		
        		acctOwners.get(a.OwnerId).add(a.id);
        	}
        	
        	for(id createdById : acctShares.keyset())
        	{
        		for(id acctId : acctShares.get(createdById))
        		{
        			boolean processLead = true;
        			
        			if(acctOwners.get(createdById)!=null) if(acctOwners.get(createdById).contains(acctId))
        			{
        				processLead = false;
        			}
        			
        			if(processLead)
        			{
        				/*
		            	Record-level sharing settings can only be used to grant more permissive access to records. Record-level sharing settings 
		            	cannot be used to restrict access to records. This also means that sharing settings can only be implemented for objects 
		            	whose object-level sharing defaults are restricted – i.e. either Public Read Only or Private. It is not necessary to grant 
		            	additional permissions on objects that have a default sharing access of Public Read/Write because users already have 
		            	read/write default access.
		            	(Code is commented out below because Account sharing is currently set to "Public Read/Write")
		            	*/
            	
	                    AccountShare acc = new AccountShare();
	                    //acc.UserOrGroupId = createdById; 
	                    //acc.OpportunityAccessLevel = 'None'; 
	                    //acc.CaseAccessLevel = 'None'; 
	                    //acc.AccountId = acctId;
	                    //acc.AccountAccessLevel = 'Read';      
	                    lAccShare.add(acc);        				
        			}
        		}
        	}	         
            //insert lAccShare;
        }        
	}
	
	
	@isTest (SeeAllData=true)
    static public void test_PartnerLeadConversionActions() {
        Test.startTest();
		
		//create a test account
		//Account testAccount = (Account) epTestTools.NewObject(new Account());
		Account testAccount = new Account();
		testAccount.Name = 'TestAcct888444222';
		//testAccount.CurrencyIsoCode = 'USD';
		testAccount.Type = 'Customer';
		//testAccount.Classification__c = 'Independent Practice Association (IPA)';
		//testAccount.RecordTypeId = [Select Id from RecordType where Name = 'Partner' AND Description LIKE '%partner account%'].id;
		insert testAccount;
		

		//now we create a test Lead.
		//Lead testLead = (Lead) epTestTools.NewObject(new Lead());
		Lead testLead = new Lead();
		//testLead.IsConverted = false;
		//In order to convet a lead, it must have an owner.  Find one.
		User u = [SELECT Id, Name FROM User WHERE Name = 'LLC EnablePath' LIMIT 1];
		testLead.OwnerId = u.Id;
		testLead.LeadSource = 'Partner Referral';
		//testLead.Sourced_By_Partner__c = testAccount.Id;
		insert testLead;
		
		Database.Leadconvert lc = new Database.Leadconvert();
		lc.setLeadId(testLead.Id);
		lc.setOwnerId(u.Id);
		lc.setDoNotCreateOpportunity(true);
		LeadStatus ls = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		lc.setConvertedStatus(ls.MasterLabel);
		Database.LeadConvertResult lcr = Database.convertLead(lc);
		
		Test.stopTest();
        
    }
}