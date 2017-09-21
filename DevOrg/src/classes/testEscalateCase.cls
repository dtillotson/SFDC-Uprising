@isTest
private class testEscalateCase {
	static testMethod void testEscalateCase(){
		Case testCase = new Case(Subject='test case', Status='New');
		insert testCase;
		
		//Instantiate a new controller
		ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
		EscalateCaseController testController = new EscalateCaseController(sc);
		
		testController.myEscalate();
	}
}