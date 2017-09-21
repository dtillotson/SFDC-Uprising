public with sharing class PositionC_Utilities {
	
	// This method assigns a region to a position based on the
	// region assigned to the position owner, who is the recruiter
	public static void assignRegion1(Position__c position) {
		// get the recruiter's region from the database
		User recruiter = [SELECT Region__c FROM User WHERE Id = :position.ownerId];
		system.debug('Recruiter Region ---->'+recruiter.Region__c);
		
		// copy to the position
		position.Region__c = recruiter.Region__c;
		system.debug('Position Region ---->'+position.Region__c);	
	}

}