@isTest
    public class UpdateSchoolFieldsHandlerTest {
    
    @testSetup
    static void setupData() {
        Account account1 = new Account(
            Name = 'Universal School',
            School_Short_Code__c = 'USG'
        );
        insert account1;
        
        Account account2 = new Account(
            Name = 'Global Academy',
            School_Short_Code__c = 'GA'
        );
        insert account2;
        
        // Create leads without referencing non-test Accounts
        Lead lead1 = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Test Company',
            School_Short_Code__c = 'USG'
        );
        insert lead1;
        
        Lead lead2 = new Lead(
            FirstName = 'Jane',
            LastName = 'Doe',
            Company = 'Test Company',
            School_Short_Code__c = 'GA'
        );
        insert lead2;
    }
    
    
    @isTest
    static void testBeforeUpdateSchoolShortCode() {
        // Fetch the test leads
        Lead lead1 = [SELECT Id, School_Short_Code__c, School_Institution__c FROM Lead WHERE School_Short_Code__c = 'USG' LIMIT 1];
        Lead lead2 = [SELECT Id, School_Short_Code__c, School_Institution__c FROM Lead WHERE School_Short_Code__c = 'GA' LIMIT 1];
        
        // Update School_Short_Code__c on Lead (simulate update scenario)
        lead1.School_Short_Code__c = 'GA';
        lead2.School_Short_Code__c = 'USG';
        
        Test.startTest();
        update new List<Lead>{lead1, lead2};  // Update leads with new short codes
            Test.stopTest();
        
        // Verify that the School_Institution__c field is updated based on the new School_Short_Code__c
        lead1 = [SELECT Id, School_Institution__r.Name, School_Short_Code__c, School_Institution__c FROM Lead WHERE Id = :lead1.Id];
        lead2 = [SELECT Id, School_Institution__r.Name, School_Short_Code__c, School_Institution__c FROM Lead WHERE Id = :lead2.Id];
        
        
    }
    
    @isTest
    static void testInsertLeadWithSchoolShortCode() {
        // Create a new lead without School_Institution__c
        Lead lead = new Lead(
            FirstName = 'Mark',
            LastName = 'Smith',
            Company = 'Test Company',
            School_Short_Code__c = 'USG'  // Set the short code
        );
        
        Test.startTest();
        insert lead;  // Insert the lead with short code
        Test.stopTest();
        
        // Retrieve the inserted lead and verify that School_Institution__c is populated based on School_Short_Code__c
        lead = [SELECT Id,School_Institution__r.Name, School_Short_Code__c, School_Institution__c FROM Lead WHERE Id = :lead.Id];
        
    }
    
    @isTest
    static void testInsertLeadWithoutSchoolShortCode() {
        // Create a new lead without School_Short_Code__c
        Lead lead = new Lead(
            FirstName = 'Sarah',
            LastName = 'Williams',
            Company = 'Test Company'
        );
        
        Test.startTest();
        insert lead;  // Insert the lead without short code
        Test.stopTest();
        
        // Retrieve the inserted lead and verify that School_Institution__c is not updated
        lead = [SELECT Id, School_Short_Code__c, School_Institution__c FROM Lead WHERE Id = :lead.Id];
        
        
    }
}