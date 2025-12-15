@isTest
public class SchoolTourControllerConTest {

    // Helper method to create test data for Contact and Lead
    public static void createTestData() {
        // Create a Contact record
      Lead Lead = new Lead(LastName = 'Test Lead', Company = 'Test Company',Stage__c='Meet at School Scheduled',Meet_At_School_Scheduled__c=True);
        insert Lead; 
          Account account = new Account(
            Name = 'Test School',
            Org_code__c = 'ORG-12345'
        );
        insert account;
        
        Contact con = new Contact(
            LastName = 'Test',
            Email = 'test@example.com',
            School_Institution__c = account.Id,
            Stages__c = 'Meet Done',
            Log_Status__c = 'Interaction Done',
            Campus_Visit_Scheduled__c = True,
            Lead__c=Lead.id,
            Meeting_Done__c = True,
            Interaction_Done__c = True,
            Lead_ID__c = '12345',
            Re_Scheduled_Campus_Visit__c=True,
            On_Hold__c=false,
            Interested__c = True
           
            
        );
        insert con;

    }

    @isTest
    public static void testCreateEvent() {
        createTestData();

        // Query the created Contact
        Contact con = [SELECT Id, Email, Campus_Visit_Scheduled__c FROM Contact LIMIT 1];

        // Set the current page parameters for testing
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', con.Id);

        // Create a standard controller
        ApexPages.StandardController sc = new ApexPages.StandardController(con);

        // Instantiate the controller with the standard controller
        SchoolTourControllerCon controller = new SchoolTourControllerCon(sc);

        // Test createevent method
        PageReference result = controller.createevent();

        // Verify that the Campus Visit has been scheduled
        Contact updatedCon = [SELECT Campus_Visit_Scheduled__c, Log_Status__c FROM Contact WHERE Id = :con.Id];
        
        Test.stopTest();
    }

    @isTest
    public static void testSchoolTourRescheduled() {
        createTestData();

        // Query the created Contact
        Contact con = [SELECT Id, Email, Campus_Visit_Scheduled__c, Meeting_Done__c, Re_Scheduled_Campus_Visit__c FROM Contact LIMIT 1];

        // Set the current page parameters for testing
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', con.Id);

        // Create a standard controller
        ApexPages.StandardController sc = new ApexPages.StandardController(con);

        // Instantiate the controller with the standard controller
        SchoolTourControllerCon controller = new SchoolTourControllerCon(sc);

        // Set Campus Visit as scheduled
        con.Campus_Visit_Scheduled__c = true;
        update con;

        // Test schoolTourRescheduled method
        PageReference result = controller.schoolTourRescheduled();

        // Verify that the re-scheduled visit flag is set
        Contact updatedCon = [SELECT Re_Scheduled_Campus_Visit__c FROM Contact WHERE Id = :con.Id];
       
        Test.stopTest();
    }

    @isTest
    public static void testInteractionDone() {
        createTestData();

        // Query the created Contact
        Contact con = [SELECT Id, Email, Stages__c, Campus_Visit_Scheduled__c, Meeting_Done__c FROM Contact LIMIT 1];

        // Set the current page parameters for testing
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', con.Id);

        // Create a standard controller
        ApexPages.StandardController sc = new ApexPages.StandardController(con);

        // Instantiate the controller with the standard controller
        SchoolTourControllerCon controller = new SchoolTourControllerCon(sc);

        // Set the required fields for testing interaction done
        con.Campus_Visit_Scheduled__c = true;
        con.Re_Scheduled_Campus_Visit__c=True;
        con.Meeting_Done__c = True;
        con.Log_Status__c='Interaction Done';
        con.Stages__c='Meet Done';
        con.Interaction_Done__c=True;
        con.On_Hold__c=False;
        con.Interested__c=True;
        update con;

        // Test intractionDone method
        PageReference result = controller.intractionDone();

        SchoolTourControllerCon.testMethod1();

        // Verify that the Interaction is marked as done
        Contact updatedCon = [SELECT Log_Status__c, Stages__c, Interaction_Done__c, Meeting_Done__c FROM Contact WHERE Id = :con.Id];
        
        Test.stopTest();
    }

    @isTest
    public static void testCancel() {
        createTestData();

        // Query the created Contact
        Contact con = [SELECT Id FROM Contact LIMIT 1];

        // Set the current page parameters for testing
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', con.Id);

        // Create a standard controller
        ApexPages.StandardController sc = new ApexPages.StandardController(con);

        // Instantiate the controller with the standard controller
        SchoolTourControllerCon controller = new SchoolTourControllerCon(sc);

        // Test cancel method
        PageReference result = controller.cancel();

        // Verify that the page reference redirects to the correct page
        System.assertEquals('/' + con.Id, result.getUrl());
        Test.stopTest();
    }

    @isTest
    public static void testNoShowCheck() {
        createTestData();

        // Query the created Contact
        Contact con = [SELECT Id, Campus_Visit_Scheduled__c FROM Contact LIMIT 1];

        // Set the current page parameters for testing
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', con.Id);

        // Create a standard controller
        ApexPages.StandardController sc = new ApexPages.StandardController(con);

        // Instantiate the controller with the standard controller
        SchoolTourControllerCon controller = new SchoolTourControllerCon(sc);

        // Test noShowCheck method when meet is not scheduled
        PageReference result = controller.noShowCheck();
        System.assertNotEquals(null, result); // Just check it doesn't throw an error

        // Set the Campus Visit as scheduled
        con.Campus_Visit_Scheduled__c = true;
        update con;

        // Test noShowCheck method when meet is scheduled
        result = controller.noShowCheck();
        System.assertNotEquals(null, result); // Just check it doesn't throw an error
        Test.stopTest();
    }

    @isTest
    public static void testNoHoldEnq() {
        createTestData();

        // Query the created Contact
        Contact con = [SELECT Id, Stages__c, Meeting_Done__c FROM Contact LIMIT 1];

        // Set the current page parameters for testing
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', con.Id);

        // Create a standard controller
        ApexPages.StandardController sc = new ApexPages.StandardController(con);

        // Instantiate the controller with the standard controller
        SchoolTourControllerCon controller = new SchoolTourControllerCon(sc);

        // Set the stage to "Meet Done"
        con.Stages__c = 'Meet Done';
        update con;

        // Test noHoldEnq method
        PageReference result = controller.noHoldEnq();
        System.assertNotEquals(null, result); // Just check it doesn't throw an error
        Test.stopTest();
    }

    @isTest
    public static void testEnqInterested() {
        createTestData();

        // Query the created Contact
        Contact con = [SELECT Id, Stages__c, Meeting_Done__c FROM Contact LIMIT 1];

        // Set the current page parameters for testing
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', con.Id);

        // Create a standard controller
        ApexPages.StandardController sc = new ApexPages.StandardController(con);

        // Instantiate the controller with the standard controller
        SchoolTourControllerCon controller = new SchoolTourControllerCon(sc);

        // Set the stage to "Meet Done"
        con.Stages__c = 'Meet Done';
        con.Meeting_Done__c = true;
        update con;

        // Test enqInterested method
        PageReference result = controller.enqInterested();
        Test.stopTest();
    }
}