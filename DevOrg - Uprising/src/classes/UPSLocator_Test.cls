@isTest
private class UPSLocator_Test {

    static testMethod void TestMethod1() {

        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.BillingStreet = 'One Hammock Beach Pkwy';
        testAcct.BillingCity = 'Palm Coast';
        testAcct.BillingState = 'FL';
        testAcct.BillingPostalCode = '32137';
        testAcct.BillingCountry = 'USA';
        insert testAcct;

        Order testOrder = new Order();
        testOrder.AccountId = testAcct.Id;
        testOrder.Status = 'Draft';
        testOrder.EffectiveDate = date.today();
        insert testOrder;

        Shipment__c testShipment = new Shipment__c();
        testShipment.Name = 'Test Shipment';
        testShipment.Order__c = testOrder.Id;
        testShipment.trackingnumber__c = '1Z5R14790300009295';
        insert testShipment;

        Test.setMock(HttpCalloutMock.class, new UPScalloutMockImpl());
        Test.startTest();
        UPSLocator.getTrackingDataById(testShipment.trackingnumber__c, testShipment.Id);
        Test.stopTest();
    }

    static testMethod void TestMethod2() {

        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.BillingStreet = 'One Hammock Beach Pkwy';
        testAcct.BillingCity = 'Palm Coast';
        testAcct.BillingState = 'FL';
        testAcct.BillingPostalCode = '32137';
        testAcct.BillingCountry = 'USA';
        insert testAcct;

        Order testOrder = new Order();
        testOrder.AccountId = testAcct.Id;
        testOrder.Status = 'Draft';
        testOrder.EffectiveDate = date.today();
        insert testOrder;

        Shipment__c testShipment = new Shipment__c();
        testShipment.Name = 'Test Shipment';
        testShipment.Order__c = testOrder.Id;
        testShipment.trackingnumber__c = '1Z5R14790300009295';
        insert testShipment;

        Test.setMock(HttpCalloutMock.class, new UPScalloutMockImpl_2());
        Test.startTest();
        UPSLocator.getTrackingDataById(testShipment.trackingnumber__c, testShipment.Id);
        Test.stopTest();
    }

    static testMethod void TestMethod3() {

        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.BillingStreet = 'One Hammock Beach Pkwy';
        testAcct.BillingCity = 'Palm Coast';
        testAcct.BillingState = 'FL';
        testAcct.BillingPostalCode = '32137';
        testAcct.BillingCountry = 'USA';
        insert testAcct;

        Order testOrder = new Order();
        testOrder.AccountId = testAcct.Id;
        testOrder.Status = 'Draft';
        testOrder.EffectiveDate = date.today();
        insert testOrder;

        Shipment__c testShipment = new Shipment__c();
        testShipment.Name = 'Test Shipment';
        testShipment.Order__c = testOrder.Id;
        testShipment.trackingnumber__c = '1Z5R14790300009295';
        insert testShipment;

        Test.setMock(HttpCalloutMock.class, new UPScalloutMockImpl_3());
        Test.startTest();
        UPSLocator.getTrackingDataById(testShipment.trackingnumber__c, testShipment.Id);
        Test.stopTest();
    }

}