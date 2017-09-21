public class TestFactory {
	
	/* Returns a valid mock user.
	*  Update to pass all validation rule and field requirements.
	*  i: an integer to make each mock user unique.
	*  profilename: the name of the profile to assign the user.
	*/
	public static User buildTestUser (Integer i, String profilename) {
		User newUser = new User();
		newUser.LastName = profilename + i;
		newUser.Alias = 'user' + i;
		newUser.Email = 'fatjoe@test.com';
		newUser.Username = 'test' + i + '@testco.com';
		newUser.CommunityNickname = 'test' + i + '@testco.com';
		newUser.ProfileId = [SELECT Id FROM Profile WHERE name = :profilename].id;
		newUser.TimeZoneSidKey = 'America/New_York';
		newUser.LocaleSidKey = 'en_US';
		newUser.EmailEncodingKey = 'UTF-8';
		newUser.LanguageLocaleKey = 'en_US';
		newUser.IsActive = true;
		newUser.People_Manager__c = true;
		newUser.Region__c = 'East';
		return newUser;
	}
	
	/* Returns a valid mock Position__c.
	*  Update to pass all validation rule and field requirements.
	*  i: an integer to make each mock position unique.
	*  testUserId: is used for both the hiring manager and owner.
	*			   might want to separate those two Ids in the future.
	*/
	public static Position__c buildTestPosition (Integer i,Id testUserId) {
		Position__c newPosition = new Position__c();
		newPosition.Name = 'Test Position ' + i;
		newPosition.Status__c = 'New';
		newPosition.Job_Description__c = 'Does Stuff.';
		newPosition.Hiring_Manager__c = testUserId;
		newPosition.OwnerId = testUserId;
		return newPosition;
	}

}