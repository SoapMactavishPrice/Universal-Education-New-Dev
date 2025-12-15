@isTest
public class LeadHandlerTest {
    @isTest
    static void testLeadTaskCount() {
        // Create test data
        Lead ld = new Lead();
        ld.WA_Response_1__c = 'Response 1';
        ld.WA_Response_2__c = 'Response 2';
        ld.WA_Star_Response__c = 'Star Response';
        ld.LastName ='Patil';
        ld.Company ='test';
        ld.Task_Count__c = 0;
        ld.Dormant_Count__c = 0;
        ld.Dormant__c = false;
        insert ld;
        
        
         ld.WA_Response_1__c = 'Response 5';    
         ld.WA_Response_2__c = 'Response 6';
         ld.Task_Count__c = 1;
         ld.Dormant_Count__c = 1;
         ld.Dormant__c = false;
         update ld;
        // Call the LeadHandler method
        LeadHandler.LeadTaskCount(new List<Lead>{ld}, new Map<Id, Lead>{ld.Id => ld});

        // Retrieve the updated Lead record
        ld = [SELECT Id, Task_Count__c, Dormant_Count__c, Dormant__c FROM Lead WHERE Id = :ld.Id];

        // Assert that the Task_Count__c and Dormant_Count__c fields are reset
        System.assertEquals(1, ld.Task_Count__c, 'Task_Count__c should not be reset to 0');
        System.assertEquals(0, ld.Dormant_Count__c, 'Dormant_Count__c should be reset to 0');
        System.assertEquals(false, ld.Dormant__c, 'Dormant__c should be false');
	    
		
		
        
    }
	 @isTest
    static void testLeadTaskCount1() {
		Lead ld1 = new Lead();
        ld1.WA_Response_1__c = 'Response 1';
        ld1.WA_Response_2__c = 'Response 2';
        ld1.WA_Star_Response__c = 'Star Response';
        ld1.LastName ='Patil';
        ld1.Company ='test';
        ld1.Task_Count__c = 5;
        ld1.Dormant_Count__c = 5;
        ld1.Dormant__c = True;
        insert ld1;
		
		LeadHandler.LeadTaskCount(new List<Lead>{ld1}, new Map<Id, Lead>{ld1.Id => ld1});

        // Retrieve the updated Lead record
        ld1 = [SELECT Id, Task_Count__c, Dormant_Count__c, Dormant__c FROM Lead WHERE Id = :ld1.Id];
		
		
		
		System.assertEquals(5, ld1.Task_Count__c, 'Task_Count__c should not be reset to 0');
		System.assertEquals(5, ld1.Dormant_Count__c, 'Dormant_Count__c should be reset to 0');
		System.assertEquals(True, ld1.Dormant__c, 'Dormant__c should be false');
		
	}
}