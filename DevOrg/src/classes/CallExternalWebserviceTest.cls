@isTest
private class CallExternalWebserviceTest {
	
	static testMethod void UnitTest1() {

          Account testAcct = new Account();
          testAcct.Name = 'Test Account';
          insert testAcct;

          Order testOrder = new Order();
          testOrder.AccountId = testAcct.Id;
          testOrder.Status = 'Draft';
          testOrder.EffectiveDate = date.today();
          insert testOrder;

          String url = 'https://api-staging.emprint.com:9000/api/ordersalesforce/';

          SingleRequestMock fakeResponse = new SingleRequestMock(200,'Complete','[{"Name": "sForceTest1"}]',null);
          Test.startTest();
          Test.setMock(HttpCalloutMock.class, fakeResponse);
          CallExternalWebservice.submitMoranOrder(testOrder.Id, url);
          CallExternalWebservice.updateOrder(testOrder.Id);
          Test.stopTest();
     }
    
}