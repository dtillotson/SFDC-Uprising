@isTest
private class testYelp {
	static testMethod void testYelp(){
		List<Restaurant__c> testRestaurants = new List<Restaurant__c>();
		
		//Create restaurants for list
		Restaurant__c testRestaurant = new Restaurant__c(Name='test first', Num_of_Visits__c=2);
		insert testRestaurant;
		
		Integer myCount = 0;
		for(myCount=0; myCount < 2; myCount++){
			Restaurant__c newRestaurant = new Restaurant__c(Name='test new '+myCount, Num_of_Visits__c=myCount);
			testRestaurants.add(newRestaurant);
		}
		insert testRestaurants;
		testRestaurants.add(testRestaurant);
		
		//Instantiate a new controller
		ApexPages.StandardSetController sc = new ApexPages.StandardSetController(testRestaurants);
		yelp testController = new yelp(sc);
		
		//Set page reference
		PageReference pageRef = Page.yelp_standardPage;
		Test.setCurrentPage(pageRef);
		
		//Add parameters to page URL 
        ApexPages.currentPage().getParameters().put('restaurant', testRestaurant.Id);
		testController.increaseVisitCount();
	} 
}