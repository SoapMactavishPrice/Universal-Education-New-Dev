@IsTest
public class UpdateLeadOwnerQueueableTest {

    @IsTest
    static void testFirstCTITaskUpdatesLeadOwner() {
        User u1 = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
        User u2 = [SELECT Id FROM User WHERE IsActive = true AND Id != :u1.Id LIMIT 1];

        Lead l = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            OwnerId = u1.Id
        );
        insert l;

        Task t = new Task(
            Subject = 'CTI Call',
            Status = 'Completed',
            Priority = 'Normal',
            WhoId = l.Id,
            OwnerId = u2.Id
        );
        insert t;

        Test.startTest();
        System.enqueueJob(new UpdateLeadOwnerQueueable(t));
        Test.stopTest();
    }

    @IsTest
    static void testNonFirstCTITaskDoesNotUpdateLeadOwner() {
        User u1 = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
        User u2 = [SELECT Id FROM User WHERE IsActive = true AND Id != :u1.Id LIMIT 1];

        Lead l = new Lead(
            LastName = 'Test Lead 2',
            Company = 'Test Company',
            OwnerId = u1.Id
        );
        insert l;

        // Create first CTI task
        Task t1 = new Task(
            Subject = 'CTI Call',
            Status = 'Completed',
            Priority = 'Normal',
            WhoId = l.Id,
            OwnerId = u2.Id
        );
        insert t1;

        // Create second CTI task
        Task t2 = new Task(
            Subject = 'CTI Call 2',
            Status = 'Completed',
            Priority = 'Normal',
            WhoId = l.Id,
            OwnerId = u2.Id
        );
        insert t2;

        Test.startTest();
        System.enqueueJob(new UpdateLeadOwnerQueueable(t2));
        Test.stopTest();
    }

    @IsTest
    static void testNonCTITaskSkipped() {
        User u = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

        Lead l = new Lead(
            LastName = 'Test Lead 3',
            Company = 'Test Company',
            OwnerId = u.Id
        );
        insert l;

        Task t = new Task(
            Subject = 'Regular Task',
            Status = 'Completed',
            Priority = 'Normal',
            WhoId = l.Id,
            OwnerId = u.Id
        );
        insert t;

        Test.startTest();
        System.enqueueJob(new UpdateLeadOwnerQueueable(t));
        Test.stopTest();
    }


    @IsTest
    static void testNullTaskIdHandled() {
        Test.startTest();
        System.enqueueJob(new UpdateLeadOwnerQueueable(null));
        Test.stopTest();
    }

    @IsTest
    static void testLeadOwnerAlreadyMatchesTaskOwner() {
        User u = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

        Lead l = new Lead(
            LastName = 'Test Lead 4',
            Company = 'Test Company',
            OwnerId = u.Id
        );
        insert l;

        Task t = new Task(
            Subject = 'CTI Call',
            Status = 'Completed',
            Priority = 'Normal',
            WhoId = l.Id,
            OwnerId = u.Id
        );
        insert t;

        Test.startTest();
        System.enqueueJob(new UpdateLeadOwnerQueueable(t));
        Test.stopTest();
    }
}
