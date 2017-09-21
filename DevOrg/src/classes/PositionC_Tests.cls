@isTest
private class PositionC_Tests {
	
	@isTest private static void testAssignRecruiterRegion1() {
		// Initialize the Test Data - Step 1
		//passing a 0 indicates you only want one testUser created
		User testUser = TestFactory.buildTestUser (0, 'Recruiter');
		insert testUser;
		
		//passing a 0 indicates you only want one testPosition created
		Position__c testPosition = TestFactory.buildTestPosition(0, testUser.Id);
		
		// Execute the Business Logic - Step 2
		Test.startTest();
			insert testPosition;
		Test.stopTest();
		
		// Verify the Results - Step 3
		Position__c dbPosition = [SELECT Region__c FROM Position__c WHERE Id = :testPosition.Id];
		system.debug('dbPosition.Region__c ---->'+dbPosition.Region__c);
		System.assertEquals(dbPosition.Region__c,testUser.Region__c);
	}

}