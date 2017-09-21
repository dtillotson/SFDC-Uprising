public with sharing class EscalateCaseController {
    public Case theCase {get;set;}
    public List<EntitySubscription> CaseTeamMembers = new List<EntitySubscription>();
    
    public EscalateCaseController(ApexPages.StandardController controller){
        theCase = (Case)controller.getRecord();
    }
    
    public PageReference myEscalate(){
        theCase.Status = 'Escalated';
        update theCase;
        
        EntitySubscription member1 = new EntitySubscription();
        member1.ParentId = theCase.Id;
        member1.SubscriberId = '005E0000002XBgz'; //Case Manager:User
        CaseTeamMembers.add(member1);
        
        EntitySubscription member2 = new EntitySubscription();
        member2.ParentId = theCase.Id;
        member2.SubscriberId = '005E0000002XBn6'; //Case Member: User
        CaseTeamMembers.add(member2);
        
        EntitySubscription member3 = new EntitySubscription();
        member3.ParentId = theCase.Id;
        member3.SubscriberId = UserInfo.GetUserId();
        CaseTeamMembers.add(member3);
        
        insert CaseTeamMembers;
        return new PageReference('/'+ theCase.Id);
        
    }
}