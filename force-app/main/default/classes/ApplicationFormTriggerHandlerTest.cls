@isTest
private class ApplicationFormTriggerHandlerTest {

    @isTest
    static void testUpdateAddressFields() {
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

         Lead lead = new Lead(
            FirstName = 'Jane',
            LastName = 'Doe',
            Company = 'Test Company'
        );
        insert lead;
        
        // Create test data: one record with Full_Address__c populated and one without
        Application_Form__c formWithAddress = new Application_Form__c(
            Name = 'Form A',
            Lead__c = lead.Id
        );

        Application_Form__c formWithoutAddress = new Application_Form__c(
            Name = 'Form B',
            Lead__c = lead.Id
        );

        // If callouts are triggered on insert, move Test.startTest here and add mocks
        Test.startTest();
        insert new List<Application_Form__c>{formWithAddress, formWithoutAddress};

        List<Application_Form__c> appForms = [
            SELECT Id, Full_Address__c, Address__c, Residential_Address__c
            FROM Application_Form__c
            WHERE Id IN :new List<Id>{formWithAddress.Id, formWithoutAddress.Id}
        ];

        ApplicationFormTriggerHandler.updateAddressFields(appForms);
        Test.stopTest();

        // Re-query to verify updates
        Application_Form__c updatedForm = [SELECT Address__c, Residential_Address__c FROM Application_Form__c WHERE Id = :formWithAddress.Id];
        Application_Form__c untouchedForm = [SELECT Address__c, Residential_Address__c FROM Application_Form__c WHERE Id = :formWithoutAddress.Id];

       
    }

	 class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }
}