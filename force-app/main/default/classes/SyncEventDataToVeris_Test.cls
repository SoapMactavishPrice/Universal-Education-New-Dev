@isTest
public class SyncEventDataToVeris_Test {

    @isTest
    static void syncDataTest() {
        // Create test data
        // 
         Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.MobilePhone='9123445678';
        con.Email='himanshunimje@live.com';
        con.Type__c='Admission Enquiry';
        con.Enquiry_Link_Sent__c=false;
        con.Contact_Status__c='Qualified';
        con.Contact_Reasons__c='N/A';
        insert con;
        
        Event testEvent = new Event(
            Subject = 'Test Event',
            DurationInMinutes = 5,
            ActivityDateTime = Datetime.newInstance(2024, 01, 12, 06, 06, 00),
            WhoId = con.Id
            // Set other required fields
        );
        insert testEvent;

        // Call the syncData method
        Test.startTest();
        SyncEventDataToVeris.syncData('{"EventId":"' + testEvent.Id + '"}', 'TestClass');
        Test.stopTest();
        
        // Add assertions or queries to verify the behavior if needed
        // For example, you can query the API_log__c object to check if a record was inserted.

        // Note: The current test is minimal, and you might need to enhance it based on your requirements.
    }
}