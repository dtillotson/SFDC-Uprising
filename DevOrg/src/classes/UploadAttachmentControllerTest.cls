@isTest
private class UploadAttachmentControllerTest {

	static testMethod void test_method_one() {

          Account testAccount = new Account();
          testAccount.Name = 'Test Account';
          insert testAccount;

          Contact testContact = new Contact();
          testContact.AccountId = testAccount.Id;
          testContact.LastName = 'Doe';
          testContact.FirstName = 'John';
          testContact.email = 'john.doe@test.com';
          insert testContact;

          UploadAttachmentController con = new UploadAttachmentController(new ApexPages.StandardController(testContact));

          List<SelectOption> attTypes = con.getAttachmentTypes();

          con.fileName = 'Test Attachment';
          con.fileBody = Blob.valueOf('Test Attachment Body');
          con.selectedType = 'Organizational chart';
          con.description = 'Org Chart in support of Test Account';
          con.publishToCommunity = true;

          PageReference pageRef = con.processUpload();

          PageReference pageRef2 = con.back();
     }
}