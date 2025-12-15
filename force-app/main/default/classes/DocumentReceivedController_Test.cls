@isTest
public class DocumentReceivedController_Test {
    @testSetup
    static void setupTestData() {
        // Insert test Admission_Form__c record
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        
        Admission_Form__c testAdmissionForm = new Admission_Form__c(
            Name = 'Test Admission Form',
            Lead__c=testLead.Id,
            Document_Received__c = false
        );
        insert testAdmissionForm;
    }

    @isTest
    static void testUpdateDocumentReceived_FirstTime() {
        // Fetch the test Admission_Form__c record
        Admission_Form__c testAdmissionForm = [SELECT Id, Document_Received__c FROM Admission_Form__c LIMIT 1];
        
        // Call the @RemoteAction method
        Boolean result;
        Test.startTest();
        result = DocumentReceivedController.updateDocumentReceived(testAdmissionForm.Id);
        Test.stopTest();

        // Assert the result
        System.assertEquals(true, result, 'The result should be true when updating Document_Received__c for the first time.');

        // Verify the field update
        Admission_Form__c updatedAdmissionForm = [SELECT Document_Received__c FROM Admission_Form__c WHERE Id = :testAdmissionForm.Id];
        System.assertEquals(true, updatedAdmissionForm.Document_Received__c, 'Document_Received__c should be updated to true.');
    }

    @isTest
    static void testUpdateDocumentReceived_AlreadyReceived() {
        // Fetch the test Admission_Form__c record and update it to mark Document_Received__c as true
        Admission_Form__c testAdmissionForm = [SELECT Id FROM Admission_Form__c LIMIT 1];
        testAdmissionForm.Document_Received__c = true;
        update testAdmissionForm;

        // Call the @RemoteAction method
        Boolean result;
        Test.startTest();
        result = DocumentReceivedController.updateDocumentReceived(testAdmissionForm.Id);
        Test.stopTest();

        // Assert the result
        System.assertEquals(true, result, 'The result should be true if Document_Received__c is already true.');

        // Verify no change in the field value
        Admission_Form__c updatedAdmissionForm = [SELECT Document_Received__c FROM Admission_Form__c WHERE Id = :testAdmissionForm.Id];
        System.assertEquals(true, updatedAdmissionForm.Document_Received__c, 'Document_Received__c should remain true.');
    }

    @isTest
    static void testUpdateDocumentReceived_InvalidId() {
        // Call the @RemoteAction method with an invalid ID
        Boolean result;
        Test.startTest();
        result = DocumentReceivedController.updateDocumentReceived('invalidRecordId');
        Test.stopTest();

        // Assert the result
        System.assertEquals(false, result, 'The result should be false if an invalid record ID is provided.');
    }
}