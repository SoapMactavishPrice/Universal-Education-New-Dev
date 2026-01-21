@isTest
public class LeadStageAndStatusHandlerTest {
    @isTest
    static void testUpdateLeadStagesAndStatus() {
        // Mock callouts to avoid errors
        Test.setMock(HttpCalloutMock.class, new LeadStageAndStatusHandlerTest.MockHttpResponseGenerator());

        // Create a Lead
        Lead l = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert l;

        // Create related Enquiry__c
        Enquiry__c enq = new Enquiry__c(
            Lead__c = l.Id,
            School_Tour_Scheduled__c = true,
            Meet_Done__c = true,
            Interaction_Online_Scheduled__c = true,
            Interaction_Done__c = true,
            Application_Link_Sent__c = true
        );
        insert enq;

        // Create related Admission_Form__c
        Admission_Form__c admForm = new Admission_Form__c(
            Lead__c = l.Id,
            Document_Received__c = true
        );
        insert admForm;

        // Create related Application_Form__c
        Application_Form__c appForm = new Application_Form__c(
            Lead__c = l.Id,
            Print_Copy_Submitted__c = true,
            Application_Accepted__c = true,
            Application_Rejected__c = true,
            Document_Verified__c = true
        );
        insert appForm;

        // Create related Admission_Granted__c
        Admission_Granted__c admGranted = new Admission_Granted__c(
            Lead__c = l.Id,
            Payment_Confirmed__c = true,
            Status__c = 'Admission Process Completed'
        );
        insert admGranted;

        // Re-query lead to simulate trigger.new
        Lead leadToUpdate = [SELECT Id, Converted__c, Lead_Stage__c, Lead_Status__c FROM Lead WHERE Id = :l.Id LIMIT 1];
        leadToUpdate.Converted__c = true;

        Test.startTest();
        LeadStageAndStatusHandler.updateLeadStages(new List<Lead>{ leadToUpdate });
        LeadStageAndStatusHandler.updateLeadStatusFromRelatedRecords(new List<Lead>{ leadToUpdate });
        Test.stopTest();
    }

    // Dummy mock class to bypass callouts
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{}');
            res.setStatusCode(200);
            return res;
        }
    }
}