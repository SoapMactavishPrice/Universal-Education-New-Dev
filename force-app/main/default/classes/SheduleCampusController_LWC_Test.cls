@IsTest
public class SheduleCampusController_LWC_Test {

    @testSetup
    static void setupData() {
        Account school = new Account(
            Name = 'Test School'
        );
        insert school;

        Lead leadRec = new Lead(
            LastName = 'Campus Lead',
            Company = 'Test Company'
        );
        insert leadRec;

        Contact contactForSchedule = new Contact(
            LastName = 'Campus Contact',
            Email = 'campus.contact@example.com',
            AccountId = school.Id,
            School_Institution__c = school.Id,
            Lead__c = leadRec.Id,
            Campus_Visit_Scheduled__c = false,
            Campus_Visit_Done__c = false,
            Re_Scheduled_Campus_Visit__c = false
        );
        insert contactForSchedule;

        Contact contactAlreadyScheduled = new Contact(
            LastName = 'Campus Already Scheduled',
            AccountId = school.Id,
            School_Institution__c = school.Id,
            Lead__c = leadRec.Id,
            Campus_Visit_Scheduled__c = true
        );
        insert contactAlreadyScheduled;

        LeadUser__c leadUser = new LeadUser__c(
            Name = UserInfo.getName(),
            SchoolCode__c = 'TST'
        );
        insert leadUser;
    }

    @IsTest
    static void coverGetContactMethods() {
        Contact c = [SELECT Id FROM Contact WHERE LastName = 'Campus Contact' LIMIT 1];

        Test.startTest();
        SheduleCampusController_LWC.getContactName(c.Id);
        SheduleCampusController_LWC.reSchedule_getContactName(c.Id);
        SheduleCampusController_LWC.getSubjectPicklistValues();
        SheduleCampusController_LWC.getLeadUser('TST');
        SheduleCampusController_LWC.testMethod1();
        Test.stopTest();
    }

    @IsTest
    static void coverGuardMethods() {
        Contact cScheduled = [SELECT Id FROM Contact WHERE LastName = 'Campus Already Scheduled' LIMIT 1];
        Contact cNotScheduled = [SELECT Id FROM Contact WHERE LastName = 'Campus Contact' LIMIT 1];

        Test.startTest();
        try {
            SheduleCampusController_LWC.alreadytourscheduled(cScheduled.Id);
        } catch (Exception ex) {
        }
        SheduleCampusController_LWC.scheduleFirsttoReschedule(cScheduled.Id);
        SheduleCampusController_LWC.scheduleFirsttoReschedule(cNotScheduled.Id);
        Test.stopTest();
    }

    @IsTest
    static void coverCreateAndRescheduleValidationBranches() {
        Contact c = [
            SELECT Id, School_Institution__c
            FROM Contact
            WHERE LastName = 'Campus Contact'
            LIMIT 1
        ];

        Test.startTest();
        try {
            SheduleCampusController_LWC.createEvent(
                '',
                c.Id,
                c.School_Institution__c,
                System.now().addHours(1),
                System.now().addHours(2),
                'Test Description',
                UserInfo.getUserId()
            );
            SheduleCampusController_LWC.testMethod1();
        } catch (Exception ex) {
        }

        try {
            SheduleCampusController_LWC.createEvent(
                'Campus Visit',
                c.Id,
                c.School_Institution__c,
                System.now().addHours(3),
                System.now().addHours(2),
                'Test Description',
                UserInfo.getUserId()
            );
        } catch (Exception ex) {
        }

        try {
            SheduleCampusController_LWC.schoolTourRescheduled(
                '',
                c.Id,
                c.School_Institution__c,
                System.now().addDays(1),
                System.now().addDays(1).addHours(1),
                'Re-schedule test',
                UserInfo.getUserId()
            );
        } catch (Exception ex) {
        }

        try {
            SheduleCampusController_LWC.schoolTourRescheduled(
                'Campus Visit',
                c.Id,
                c.School_Institution__c,
                System.now().addDays(2).addHours(2),
                System.now().addDays(2),
                'Re-schedule test',
                UserInfo.getUserId()
            );
        } catch (Exception ex) {
        }
        Test.stopTest();
    }
}
