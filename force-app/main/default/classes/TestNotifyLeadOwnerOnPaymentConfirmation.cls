@isTest
public class TestNotifyLeadOwnerOnPaymentConfirmation {
    @isTest
    static void testPaymentConfirmationNotification() {
        // Create a test user
        User testUser = new User(
            Alias = 'testusr',
            Email = 'testuserdaandbcjacc@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuseksbjasbcjacajc123r@example.com'
        );
        insert testUser;
        
        // Create a test Lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            OwnerId = testUser.Id
        );
        insert testLead;
        
        // Retrieve the Custom Notification Type (Ensure it exists in the org)
        CustomNotificationType notificationType = [
            SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'Payment_Received_Notification' LIMIT 1
        ];
        
        // Create a test Admission_Granted__c record with Payment_Confirmed__c = false
        Admission_Granted__c admission = new Admission_Granted__c(
            Lead__c = testLead.Id,
            Payment_Confirmed__c = false
        );
        insert admission;
        
        // Update the record to set Payment_Confirmed__c = true
        Test.startTest();
        admission.Payment_Confirmed__c = true;
        update admission;
        Test.stopTest();
        
        // Add debug log to verify the trigger execution
        System.debug('Trigger executed: Payment confirmed notification should have been sent.');
    }
}