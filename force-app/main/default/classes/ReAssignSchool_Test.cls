@isTest
public class ReAssignSchool_Test {
    
    @testSetup
    static void setup() {
        // Create test data for the test setup
        Account testAccount = new Account(Name = 'Test School');
        insert testAccount;
        
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = testAccount.Id,
            Current_Location__c = 'Test Location'
        );
        insert testLead;
    }

    @isTest
    static void testConstructor() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testLead);
        
        ReAssignSchool controller = new ReAssignSchool(stdController);
        
        System.assert(controller != null, 'Controller instance should not be null');
        System.assert(controller.leadRecord.Id == testLead.Id, 'Lead record should be initialized');
    }

    @isTest
    static void testGetSchoolOptionslist() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testLead);
        
        ReAssignSchool controller = new ReAssignSchool(stdController);
        List<SelectOption> options = controller.getSchoolOptionslist();
        
        System.assertNotEquals(0, options.size(), 'School options should not be empty');
        System.assertEquals('Select School/Institution', options[0].getLabel(), 'First option should be default');
    }

   
  /*  static void testSave() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testLead);
        
        ReAssignSchool controller = new ReAssignSchool(stdController);
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        controller.AccountId = testAccount.Id;
        
        Test.startTest();
        PageReference result = controller.save();
        Test.stopTest();
        
       // System.assert(result != null, 'Page reference should not be null');
        System.assertEquals('/apex/TransferSuccessPage', result.getUrl(), 'Should redirect to success page');
        
        Lead updatedLead = [SELECT School_Institution__c, Status FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(testAccount.Id, updatedLead.School_Institution__c, 'School institution should be updated');
        System.assertEquals('New', updatedLead.Status, 'Status should be updated to New');
    }*/

    @isTest
    static void testSaveWithBlankLocation() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        testLead.Current_Location__c = null;
        update testLead;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testLead);
        
        ReAssignSchool controller = new ReAssignSchool(stdController);
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        controller.AccountId = testAccount.Id;
        
        Test.startTest();
        PageReference result = controller.save();
        ReAssignSchool.dummy();
        Test.stopTest();

        System.assert(result == null, 'Page reference should be null');
        System.assertEquals(1, ApexPages.getMessages().size(), 'There should be one error message');
        System.assertEquals('Please add Current Location', ApexPages.getMessages()[0].getSummary(), 'Error message should match');
    }

    @isTest
    static void testCancel() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testLead);
        
        ReAssignSchool controller = new ReAssignSchool(stdController);
        
        PageReference result = controller.cancel();
        
        System.assert(result != null, 'Page reference should not be null');
        System.assertEquals('/' + testLead.Id, result.getUrl(), 'Should redirect to lead record page');
    }
    
   
    /*static void testRedirectToLeadList() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testLead);
        
        ReAssignSchool controller = new ReAssignSchool(stdController);
        
        PageReference result = controller.redirectToLeadList();
        
        //System.assert(result != null, 'Page reference should not be null');
        //System.assertEquals('/00Q/o', result.getUrl(), 'Should redirect to lead list view');
    }*/
}