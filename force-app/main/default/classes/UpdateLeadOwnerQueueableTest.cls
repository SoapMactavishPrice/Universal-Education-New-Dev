@isTest
public class UpdateLeadOwnerQueueableTest {

    @TestSetup
    static void setupData() {
        Lead lead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Phone = '1234567890'
        );
        insert lead;
    }

    // UpdateLeadOwnerQueueable - Missed Call Status (notification path)
    @isTest
    static void testUpdateLeadOwner_MissedCallNotification() {
        Lead lead = [SELECT Id, OwnerId FROM Lead LIMIT 1];

        Task t = new Task(
            WhoId = lead.Id,
            OwnerId = lead.OwnerId,
            Subject = 'CTI Test',
            Call_Status__c = 'Missed'
        );
        insert t;

        t = [SELECT Id, WhoId, OwnerId, Subject, Call_Status__c FROM Task WHERE Id = :t.Id];

        Test.startTest();
        System.enqueueJob(new UpdateLeadOwnerQueueable(t));
        Test.stopTest();
    }

    // UpdateLeadOwnerQueueable - Null task
    @isTest
    static void testUpdateLeadOwner_NullTask() {
        Test.startTest();
        System.enqueueJob(new UpdateLeadOwnerQueueable(null));
        Test.stopTest();
    }

    // UpdateLeadOwnerQueueable - Non-CTI subject (early return)
    @isTest
    static void testUpdateLeadOwner_NonCTISubject() {
        Lead lead = [SELECT Id, OwnerId FROM Lead LIMIT 1];

        Task t = new Task(
            WhoId = lead.Id,
            OwnerId = lead.OwnerId,
            Subject = 'Non CTI Task',
            Call_Status__c = 'Connected'
        );
        insert t;

        t = [SELECT Id, WhoId, OwnerId, Subject, Call_Status__c FROM Task WHERE Id = :t.Id];

        Test.startTest();
        System.enqueueJob(new UpdateLeadOwnerQueueable(t));
        Test.stopTest();
    }

    // UpdateLeadOwnerQueueable - CTI subject, valid lead, owner differs
    @isTest
    static void testUpdateLeadOwner_CTIOwnerUpdate() {
        Lead lead = [SELECT Id, OwnerId FROM Lead LIMIT 1];

        User anotherUser = [SELECT Id FROM User WHERE Id != :lead.OwnerId AND IsActive = true LIMIT 1];

        Task t = new Task(
            WhoId = lead.Id,
            OwnerId = anotherUser.Id,
            Subject = 'CTI Test Call',
            Call_Status__c = 'Connected'
        );
        insert t;

        t = [SELECT Id, WhoId, OwnerId, Subject, Call_Status__c FROM Task WHERE Id = :t.Id];

        Test.startTest();
        System.enqueueJob(new UpdateLeadOwnerQueueable(t));
        Test.stopTest();
    }

    // UpdateLeadOwnerQueueable - CTI subject, more than 1 related task (size > 1 return)
    @isTest
    static void testUpdateLeadOwner_MultipleRelatedTasks() {
        Lead lead = [SELECT Id, OwnerId FROM Lead LIMIT 1];

        Task t1 = new Task(
            WhoId = lead.Id,
            OwnerId = lead.OwnerId,
            Subject = 'CTI Call 1',
            Call_Status__c = 'Connected'
        );
        insert t1;

        Task t2 = new Task(
            WhoId = lead.Id,
            OwnerId = lead.OwnerId,
            Subject = 'CTI Call 2',
            Call_Status__c = 'Connected'
        );
        insert t2;

        t2 = [SELECT Id, WhoId, OwnerId, Subject, Call_Status__c FROM Task WHERE Id = :t2.Id];

        Test.startTest();
        System.enqueueJob(new UpdateLeadOwnerQueueable(t2));
        Test.stopTest();
    }

    // DeleteDuplicateUcidTasksQueueable - Null task
    @isTest
    static void testDeleteDuplicateUcid_NullTask() {
        Test.startTest();
        System.enqueueJob(new DeleteDuplicateUcidTasksQueueable(null));
        Test.stopTest();
    }

    // DeleteDuplicateUcidTasksQueueable - Blank MonitorUcid
    @isTest
    static void testDeleteDuplicateUcid_BlankUcid() {
        Lead lead = [SELECT Id, OwnerId FROM Lead LIMIT 1];

        Task t = new Task(
            WhoId = lead.Id,
            OwnerId = lead.OwnerId,
            Subject = 'CTI Test',
            Call_Status__c = 'Connected'
        );
        insert t;

        t = [SELECT Id, WhoId, OwnerId, Subject, Call_Status__c, MonitorUcid__c FROM Task WHERE Id = :t.Id];

        Test.startTest();
        System.enqueueJob(new DeleteDuplicateUcidTasksQueueable(t));
        Test.stopTest();
    }


    // DeleteDuplicateUcidTasksQueueable - Duplicates exist and get deleted
    @isTest
    static void testDeleteDuplicateUcid_DeletesDuplicates() {
        Lead lead = [SELECT Id, OwnerId FROM Lead LIMIT 1];

        Task t1 = new Task(
            WhoId = lead.Id,
            OwnerId = lead.OwnerId,
            Subject = 'CTI Duplicate 1',
            MonitorUcid__c = 'UCID-TEST-001',
            Call_Status__c = 'Connected'
        );
        insert t1;

        Task t2 = new Task(
            WhoId = lead.Id,
            OwnerId = lead.OwnerId,
            Subject = 'CTI Duplicate 2',
            MonitorUcid__c = 'UCID-TEST-001',
            Call_Status__c = 'Connected'
        );
        insert t2;

        t2 = [SELECT Id, WhoId, OwnerId, Subject, MonitorUcid__c, Call_Status__c FROM Task WHERE Id = :t2.Id];

        Test.startTest();
        System.enqueueJob(new DeleteDuplicateUcidTasksQueueable(t2));
        Test.stopTest();
    }
}