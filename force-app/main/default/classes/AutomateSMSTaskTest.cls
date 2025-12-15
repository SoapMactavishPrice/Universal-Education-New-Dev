@isTest
public class AutomateSMSTaskTest {
    
    static TestMethod void automatetask() {
        List<Task> TaskList = new List<Task>();
        
        // Create Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        // Create Lead (required for Contact)
        Lead ld = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Status = 'Open - Not Contacted'
        );
        insert ld;
        
        // Create Contact with required Lead__c
        Contact con = new Contact(
            LastName = 'Test Last Name',
            FirstName = 'Test First Name',
            Phone = '9617904978',
            AccountId = acc.Id,
            Lead__c = ld.Id // REQUIRED to pass validation
        );
        insert con;
        
        // Create Task
        Task t = new Task(
            WhoId = con.Id,
            Subject = 'Test Task',
            knowlarity_cti__Call_Disposition__c = 'Test Description'
        );
        TaskList.add(t);
        insert TaskList;
        
        // Create SMS Template
        smsgupshupTemplate__c smtemplate = new smsgupshupTemplate__c(
            Name__c = 'Test Template',
            Description__c = 'success'
        );
        insert smtemplate;
        
        // Create SMS Record
        smsgupshup__c smsgupshup = new smsgupshup__c(
            Contact_ID__c = con.Id,
            Contact_Name_Number__c = con.Name,
            Message__c = smtemplate.Description__c,
            Sender_Number__c = con.Phone
        );
        insert smsgupshup;   
        
        // Call the methods
        EnquirySendSmSCallout.sendgupshupsms(
            smsgupshup.Message__c,
            smsgupshup.Sender_Number__c,
            '2000045203',
            'universalgoogle'
        );
        EnquirySendSmSCallout.sendsms();    
    }
}