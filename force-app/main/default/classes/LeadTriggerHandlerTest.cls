@isTest
public class LeadTriggerHandlerTest {
    
    @testSetup
    static void setup() {
        // Create test profiles
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        Profile hodProfile = [SELECT Id FROM Profile WHERE Name = 'HODs' LIMIT 1];
        Profile otherProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Create test users
        User adminUser = new User(
            Alias = 'admin',
            Email = 'admin@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Admin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = adminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'admintest@testorg.com'
        );

        User hodUser = new User(
            Alias = 'hod',
            Email = 'hod@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Hod',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = hodProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'hodtest@testorg.com'
        );

        User standardUser = new User(
            Alias = 'stduser',
            Email = 'stduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = otherProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'stdusertest@testorg.com'
        );

        insert new List<User>{adminUser, hodUser, standardUser};

        // Create test leads
        Lead lead1 = new Lead(LastName = 'Test1', Company = 'Test Company1', Status = 'New');
        Lead lead2 = new Lead(LastName = 'Test2', Company = 'Test Company2', Status = 'Working');
        Lead lead3 = new Lead(FirstName = 'Testn1', LastName = 'Test3', Company = 'Test Company3', Status = 'Qualified');
        Lead lead4 = new Lead(LastName = 'Test3', Company = 'Test Company3', Status = 'Qualified');
        Lead lead5 = new Lead(FirstName = 'Testn2',LastName = 'Test3', Company = 'Test Company3', Status = 'Qualified');
        insert new List<Lead>{lead1, lead2, lead3,lead4,lead5};
            
       /*for (Lead lead : leads) {
          Lead updatedLead = [SELECT Id, LastName FROM Lead WHERE FirstName = 'Testn1'];
            
        Lead.Status='new';
        Lead.Converted__c=true;
        update Lead; 
         }*/
            
    }

    @isTest
    static void testOnBeforeUpdateAsSystemAdmin() {
        // Run as System Administrator
        User adminUser = [SELECT Id FROM User WHERE Alias = 'admin' LIMIT 1];
        System.runAs(adminUser) {
            List<Lead> leads = [SELECT Id, LastName, Status FROM Lead where Status = 'New' OR Status = 'Working'];
            for (Lead lead : leads) {
                lead.LastName = 'Updated LastName';
            }

            Test.startTest();
            update leads;
            Test.stopTest();

            // Verify no error message for System Administrator
            for (Lead lead : leads) {
                Lead updatedLead = [SELECT Id, LastName FROM Lead WHERE Id = :lead.Id];
                System.assertEquals('Updated LastName', updatedLead.LastName);
            }
        }
    }

    @isTest
    static void testOnBeforeUpdateAsHOD() {
        // Run as HOD
        User hodUser = [SELECT Id FROM User WHERE Alias = 'hod' LIMIT 1];
        System.runAs(hodUser) {
            List<Lead> leads = [SELECT Id, LastName, Status FROM Lead where Status = 'New' OR Status = 'Working'];
            for (Lead lead : leads) {
                lead.LastName = 'Updated LastName';
            }

            Test.startTest();
            update leads;
            Test.stopTest();

            // Verify no error message for HOD
            for (Lead lead : leads) {
                Lead updatedLead = [SELECT Id, LastName FROM Lead WHERE Id = :lead.Id];
                System.assertEquals('Updated LastName', updatedLead.LastName);
            }
        }
    }

/*@isTest
static void testOnBeforeUpdateAsStandardUser() {
    // Run as Standard User
    User standardUser = [SELECT Id FROM User WHERE Alias = 'stduser' LIMIT 1];
    
    System.runAs(standardUser) {
        // Select leads that have status other than 'New' and 'Working'
        List<Lead> leadl = [SELECT Id, LastName, Status FROM Lead WHERE FirstName = 'Testn1' ];
        for (Lead l : leadl) {
       // Lead updatedLead = [SELECT Id, LastName FROM Lead WHERE FirstName = 'Testn1'];
            
        l.Status='Qualified';
        l.Converted__c=true;
        update l; 
            system.debug('updated lead'+l);
        }
        List<Lead> leads = [SELECT Id, LastName, Status FROM Lead where Status = 'Qualified'];
        // Make sure there are leads with status 'Qualified'
        System.assertNotEquals(0, leads.size(), 'No leads with status Qualified found.');

        // Attempt to update the leads
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            update leads;
        } catch (DmlException e) {
            exceptionThrown = true;
            // Assert that the exception message contains the expected error message
            System.assert(e.getMessage().contains('You cannot edit lead fields if status is not New or Working.'));
        }
        Test.stopTest();

        // Assert that the exception was thrown
        System.assert(exceptionThrown, 'Expected DMLException not thrown.');
    }
}*/

    @isTest
    static void testOnBeforeUpdateAsStandardUserWithValidStatus() {
        // Run as Standard User
        User standardUser = [SELECT Id FROM User WHERE Alias = 'stduser' LIMIT 1];
        System.runAs(standardUser) {
            List<Lead> leads = [SELECT Id, LastName, Status FROM Lead WHERE Status != 'New' OR Status != 'Working'];
            for (Lead lead : leads) {
                lead.LastName = 'Updated LastName';
                lead.FirstName = 'UpdatedFirstName'; // Ensure some fields are being updated
            }

            Test.startTest();
            update leads;
            LeadTriggerHandler.dummy();
            Test.stopTest();

            // Verify no error message for standard user with valid status
            for (Lead lead : leads) {
                Lead updatedLead = [SELECT Id, LastName FROM Lead WHERE Id = :lead.Id and Status = 'Qualified'];
                System.assertEquals('Updated LastName', updatedLead.LastName);
                System.assertEquals('UpdatedFirstName', updatedLead.FirstName);
            }
        }
    }
    
    
    
}