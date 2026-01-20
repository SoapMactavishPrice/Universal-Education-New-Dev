@isTest
public class reassignLeadControllerTest {

    // Helper method to create test data
    private static void createTestData() {
        // Create accounts (schools/institutions)
        List<Account> accounts = new List<Account>();
        for (Integer i = 1; i <= 3; i++) {
            accounts.add(new Account(Name = 'Test School ' + i));
        }
        insert accounts;

        // Create lead with one school associated
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Current_Location__c = 'Test Location',
            School_Institution__c = accounts[0].Id, // Associate with the first account
            Status = 'Open'
        );
        insert testLead;
    }

    @isTest
    static void testGetSchoolOptionslist() {
        // Create test data
        createTestData();

        // Fetch the test lead with the required field
        Lead testLead = [SELECT Id, School_Institution__c FROM Lead LIMIT 1];

        // Test the getSchoolOptionslist method
        Test.startTest();
        List<Map<String, String>> schoolOptions = reassignLeadController.getSchoolOptionslist(testLead.Id);
        Test.stopTest();

        // Assert that options are returned and the associated school is excluded
        System.assertNotEquals(null, schoolOptions);
        System.assertEquals('Select School/Institution', schoolOptions[0].get('label'));
        for (Map<String, String> option : schoolOptions) {
            System.assertNotEquals(testLead.School_Institution__c, option.get('value'), 'Excluded school should not appear in options');
        }
    }

    @isTest
    static void testGetLeadDetails() {
        // Create test data
        createTestData();

        // Fetch the test lead
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];

        // Test the getLeadDetails method
        Test.startTest();
        Lead fetchedLead = reassignLeadController.getLeadDetails(testLead.Id);
        Test.stopTest();

        // Assert that the lead details are fetched correctly
        System.assertNotEquals(null, fetchedLead);
        System.assertEquals(testLead.Id, fetchedLead.Id);
    }

    @isTest
    static void testSaveLead() {
        // Create test data
        createTestData();

        // Fetch the test lead with required fields
        Lead testLead = [SELECT Id, Current_Location__c, School_Institution__c FROM Lead LIMIT 1];
        Account anotherSchool = [SELECT Id FROM Account WHERE Id != :testLead.School_Institution__c LIMIT 1];

        // Test the saveLead method
        Test.startTest();
        String result = reassignLeadController.saveLead(testLead.Id, anotherSchool.Id);
        Test.stopTest();

        // Assert that the lead is updated successfully
        System.assertEquals('Lead transferred successfully', result);

        // Verify the lead was updated with the new school and status
        Lead updatedLead = [SELECT School_Institution__c, Status FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(anotherSchool.Id, updatedLead.School_Institution__c);
        System.assertEquals('New', updatedLead.Status);
    }

    @isTest
    static void testSaveLeadWithMissingCurrentLocation() {
        // Create test data
        createTestData();

        // Fetch the test lead with required fields
        Lead testLead = [SELECT Id, School_Institution__c FROM Lead LIMIT 1];
        Account anotherSchool = [SELECT Id FROM Account WHERE Id != :testLead.School_Institution__c LIMIT 1];

        // Set Current_Location__c to null
        testLead.Current_Location__c = null;
        update testLead;

        // Test the saveLead method with missing Current Location
        Test.startTest();
        try {
            reassignLeadController.saveLead(testLead.Id, anotherSchool.Id);
            System.assert(false, 'Expected AuraHandledException was not thrown');
        } catch (AuraHandledException e) {
          //  System.assertEquals('Please add Current Location before changing the school.', e.getMessage());
        }
        Test.stopTest();
    }
}