@IsTest
public class LeadPhoneCleanupBatchTest {

    @IsTest
    static void testCleanupBatch() {

        List<Lead> leads = new List<Lead>();

        leads.add(new Lead(
            LastName = 'Test1',
            Company = 'ABC',
            MobilePhone = '9191919876543210'
        ));

        leads.add(new Lead(
            LastName = 'Test2',
            Company = 'ABC',
            MobilePhone = '+9191919876543210'
        ));

        leads.add(new Lead(
            LastName = 'Test3',
            Company = 'ABC',
            MobilePhone = '919876543210'
        ));

        leads.add(new Lead(
            LastName = 'Test4',
            Company = 'ABC',
            MobilePhone = null
        ));

        insert leads;

        Test.startTest();
        Database.executeBatch(new LeadPhoneCleanupBatch(), 200);
        Test.stopTest();

        Map<Id, Lead> result = new Map<Id, Lead>(
            [SELECT Id, MobilePhone FROM Lead WHERE Id IN :leads]
        );

        System.debug('Lead 1 (9191919876543210) MobilePhone: ' + result.get(leads[0].Id).MobilePhone);
        System.debug('Lead 2 (+9191919876543210) MobilePhone: ' + result.get(leads[1].Id).MobilePhone);
        System.debug('Lead 3 (919876543210) MobilePhone: ' + result.get(leads[2].Id).MobilePhone);
        System.debug('Lead 4 (null) MobilePhone: ' + result.get(leads[3].Id).MobilePhone);
    }
}
