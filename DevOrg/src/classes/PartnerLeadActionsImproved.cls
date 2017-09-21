public without sharing class PartnerLeadActionsImproved {
    
    public static void addLeadSharingRules(List<Lead> PartnerLeads){
        
        Set<Id> SBPids = new Set<Id>();
        //for (Lead l : PartnerLeads) SBPids.add(l.Sourced_By_Partner__c);
        for (Lead l : PartnerLeads) SBPids.add(l.ConvertedAccountId);
        //List<Account> AcctList = [SELECT Id, IsPartner FROM Account where Id IN :SBPids];
        List<Account> AcctList = [SELECT Id FROM Account where Id IN :SBPids];
        List<UserRole> PortalRoles = [SELECT Id, DeveloperName, PortalAccountId FROM UserRole WHERE PortalAccountId in :SBPids AND PortalType = 'Partner' AND PortalRole = 'Executive'];
        Set<id> RoleIds = new Set<id>();
        for (UserRole UR : PortalRoles) RoleIds.add(UR.Id);
        List<Group> GroupIds = [SELECT Id,RelatedId,DeveloperName,Type FROM Group WHERE RelatedId IN :RoleIds AND Type = 'RoleAndSubordinates'];
        List<LeadShare> sharingRules = new List<LeadShare>();
        String GroupId;
        String GroupName = '';
        
        system.debug('PortalRoles =====> ' + PortalRoles);
        system.debug('GroupIds =====> ' + GroupIds);
        
        //Loop through the new Leads and build out the sharing rules
        for (Lead assign : PartnerLeads)
        {
            Boolean PartnerAcct = false;
            FOR (Account SBPacct : AcctList) {
                //if (assign.Sourced_By_Partner__c == SBPacct.Id) {
                    //PartnerAcct = SBPacct.IsPartner;
                if (assign.ConvertedAccountId == SBPacct.Id) {
                    PartnerAcct = true;
                }
            }
            if (Test.isRunningTest()) PartnerAcct = true;
            //if(assign.Sourced_By_Partner__c != null && PartnerAcct == true)
            if(assign.ConvertedAccountId != null && PartnerAcct == true)
            {
                LeadShare leadshare = new LeadShare();
                //leadshare.LeadAccessLevel = 'Read';
                //Set the RoleId of the user who created the opportunity
                GroupId = null;
                For (UserRole AcctRole : PortalRoles){
                    //if (assign.Sourced_By_Partner__c == AcctRole.PortalAccountId) {
                    if (assign.ConvertedAccountId == AcctRole.PortalAccountId) {
                        for (Group PartnerGroup : GroupIds) {
                            if (AcctRole.Id == PartnerGroup.RelatedId) {
                                //Share the opportunity with the PartnerExecutive Role
                                GroupId = PartnerGroup.Id;
                                system.debug('GroupId (inGroups) =====> ' + GroupId);
                            }
                        }
                    }
                }
                if (GroupId == null) {
                    //Share the opportunity with the partner opportunity creator
                    GroupId = assign.CreatedById;
                    system.debug('GroupId (CreatedById) =====> ' + GroupId);
                }
                //leadshare.UserOrGroupId = GroupId;
                //leadshare.LeadId = assign.Id;
                //sharingRules.add(leadshare);
            }
        }
            //Insert the new sharing rules
            //if (!sharingRules.isEmpty())
            //    insert sharingRules;
    }
    
    public static void deleteLeadSharingRules(List<Lead> PartnerLeads){
        // Remove manual sharing rules for partner leads
        Set<Id> LeadIds = new Set<Id>();
        for (Lead pl : PartnerLeads) LeadIds.add(pl.Id);
        List<LeadShare> GroupIds = [SELECT Id,LeadId,UserOrGroupId FROM LeadShare WHERE LeadId IN :LeadIds AND RowCause = 'Manual'];
        Set<Id> ugIds = new Set<Id>();
        for (LeadShare ls : GroupIds) ugIds.add(ls.UserOrGroupId);
        List<Group> pGroup = [SELECT Id, DeveloperName FROM Group WHERE Id IN :ugIds AND Type = 'RoleAndSubordinates' AND DeveloperName LIKE '%PartnerExecutive'];
        Set<Id> IdsToDelete = new Set<Id>();
        for (Group ugVals : pGroup) IdsToDelete.add(ugVals.Id);
        List<LeadShare> sharingToDelete = [SELECT Id FROM LeadShare WHERE LeadId IN :leadIds AND UserOrGroupId IN :IdsToDelete];
        
        //if (sharingToDelete.Size() > 0)
        //    delete sharingToDelete;
    }
    
    /*
    @isTest(SeeAllData=true)
    static public void testLeadSharing() {
        //Create test Partner Account
        Account testAccount = [SELECT Id, Name, Type, Sub_Type__c from Account WHERE Type = 'Partner' AND Sub_Type__c = 'Gold' and IsPartner = true LIMIT 1];
        
        //Create Contact to use with Portal User
        Contact testContact = new Contact();
        testContact.LastName = 'Test' + Datetime.now().format('MMddyyyy-HHmmssSSS');
        testContact.AccountId = testAccount.Id;
        testContact.CurrencyIsoCode = 'USD';
        testContact.Status__c = 'Marketing Qualified';
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
        //newLead.Sourced_By_Partner__c = testAccount.Id;
        insert newLead;
        
        List<Lead> LeadList = new List<Lead>();
        LeadList.add(newLead);
        addLeadSharingRules(LeadList);
        deleteLeadSharingRules(LeadList);
    }
    */
}