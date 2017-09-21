// http://cropredysfdc.com/2016/04/30/testing-viewstate-in-apex-testmethods/
@isTest
private class testViewState {

     static testmethod void testViewState() {

          // Mock n Sobjects
          CallExternalWebservice ctlr = new CallExternalWebservice();  // same principle applies for extensions
          // exercise setters, getters, and ajax action methods that process all n records
          Integer ctlrSerializedSize = Integer.valueOf(Json.serialize(ctlr));  // get size of controller, serialized

          // mock another n SObjects so we have 2n total
          ctlr = new CallExternalWebservice();
          // exercise setters, getters, and ajax action methods that process all 2n records
          System.assertEquals(ctlrSerializedSize,Integer.valueOf(Json.serialize(ctlr)),'non transient size of controller should stay flat');
     }

     /*  Original code from web page
     @isTest private static void testViewState() {
          // Mock n Sobjects
          MyController ctlr = new Controller();  // same principle applies for extensions
          // exercise setters, getters, and ajax action methods that process all n records
          Integer ctlrSerializedSize = Json.serialize(ctlr);  // get size of controller, serialized

          // mock another n SObjects so we have 2n total
          ctlr = new Controller();
          // exercise setters, getters, and ajax action methods that process all 2n records
          System.assertEquals(ctlrSerializedSize,Json.serialize(ctlr),'non transient size of controller should stay flat');
     }
     */
}