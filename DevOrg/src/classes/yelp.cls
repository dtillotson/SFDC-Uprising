public with sharing class yelp {
    List<Restaurant__c> restaurants;
    
    public yelp(ApexPages.StandardSetController controller) {
        this.restaurants = (List<Restaurant__c>)controller.getRecords();
    }

    public pageReference increaseVisitCount(){
        List<Restaurant__c> restaurantsToUpdate = new List<Restaurant__c>();
        
        String restaurantId = ApexPages.currentPage().getParameters().get('restaurant');
        for (Restaurant__c r : this.restaurants) {
            if (r.Id == restaurantId) {
                r.Num_of_Visits__c++;
                restaurantsToUpdate.add(r);
            }
        }
          
        update restaurantsToUpdate;      
        return null;
    }
}