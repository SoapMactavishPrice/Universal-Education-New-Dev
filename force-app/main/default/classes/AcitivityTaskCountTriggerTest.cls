@isTest
public class AcitivityTaskCountTriggerTest {
    
    // ===== Test Data Setup =====
    @testSetup
    static void setupData() {
        // Create a Lead that Tasks can relate to
        Lead ld = new Lead(
            LastName = 'Trigger Lead',
            Company  = 'Trigger Co',
            Stage__c = 'New' // adjust if required picklist
        );
        insert ld;
        
        // Task A: Will become "Missed" to drive Lead update logic
        Task t1 = new Task(
            Subject     = 'Call Prospect',
            Status      = 'Completed',
            Priority    = 'Normal',
            WhoId       = ld.Id,
            Call_Status__c = 'Missed', // drives the Lead update path in trigger
            ActivityDate = Date.today()
        );
        
        // Task B: No WhoId; exercises the branch where leads list stays empty
        Task t2 = new Task(
            Subject      = 'Internal Follow‑up',
            Status       = 'Completed',
            Priority     = 'Normal',
            ActivityDate = Date.today()
        );
        
        insert new List<Task>{ t1, t2 };
    }
    
    
    // ===== Main Test =====
    @isTest
    static void testInsertAndUpdatePaths() {
        // Fetch our records
        Lead ld = [SELECT Id, Call_Status__c FROM Lead LIMIT 1];
        List<Task> tasks = [
            SELECT Id, WhoId, Call_Status__c, TaskSubtype
            FROM Task
            ORDER BY CreatedDate ASC
        ];
        
        Task taskWithLead   = tasks[0];
        Task taskWithoutLead = tasks[1];
        
       
        ld = [SELECT Id, Call_Status__c FROM Lead WHERE Id = :ld.Id];
        
        
        
       
        taskWithLead.Call_Status__c = 'Connected';
        taskWithoutLead.Call_Status__c = 'Left VM';
        update new List<Task>{ taskWithLead, taskWithoutLead };
        
        
        ld = [SELECT Id, Call_Status__c FROM Lead WHERE Id = :ld.Id];
        
        
        // Now set back to Missed on Task A; this should try to update Lead again (idempotent)
        taskWithLead.Call_Status__c = 'Missed';
        update taskWithLead;
        
        // Confirm still Missed
        ld = [SELECT Id, Call_Status__c FROM Lead WHERE Id = :ld.Id];
        System.assertEquals('Missed', ld.Call_Status__c,
            'Lead Call_Status__c should still be Missed after re-update.');
    }
    
    
   
    @isTest
    static void testHandlerSideEffects_underGovernorFlush() {
        // Requery one of the existing Tasks
        Task t = [SELECT Id, WhoId, Call_Status__c FROM Task LIMIT 1];
        
        Test.startTest();
        // Force an update to fire trigger again
        t.Subject = 'Re-Fire Trigger';
        update t;
        Test.stopTest();
        
        
    }
}