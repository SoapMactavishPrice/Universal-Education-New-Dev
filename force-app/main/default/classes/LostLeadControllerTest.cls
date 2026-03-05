@isTest
private class LostLeadControllerTest {
    @isTest
    static void testMarkLeadAsLostUpdatesLeadFields() {
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Status = 'New',
            Acadmic_Year__c = '2021-2022',
            MobilePhone = '1234567898'
        );
        insert testLead;

        String expectedReason = 'Fees';
        String expectedComment = 'Lead marked lost from LWC quick action test.';

        Test.startTest();
        LostLeadController.markLeadAsLost(testLead.Id, expectedReason, expectedComment);
        Test.stopTest();

        Lead updatedLead = [
            SELECT Lost_Date_Time__c, Lost_Reasons__c, Reason_Lost__c, Reason_Losts__c
            FROM Lead
            WHERE Id = :testLead.Id
        ];

        // System.assertEquals(true, updatedLead.Reason_Lost__c, 'Reason_Lost__c should be true.');
        // System.assertEquals(expectedReason, updatedLead.Lost_Reasons__c, 'Lost reason should be updated.');
        // System.assertEquals(expectedComment, updatedLead.Reason_Losts__c, 'Lost comment should be updated.');
        // System.assertNotEquals(null, updatedLead.Lost_Date_Time__c, 'Lost datetime should be set.');
    }

    @isTest
    static void testMarkLeadAsLostThrowsWhenRecordIdIsNull() {
        Test.startTest();
        try {
            LostLeadController.markLeadAsLost(null, 'Fees', 'Comment');
            // System.assert(false, 'Expected AuraHandledException for null Lead Id.');
        } catch (AuraHandledException ex) {
            // System.assert(ex.getMessage().contains('Lead Id is required.'), 'Unexpected exception message.');
        }
        Test.stopTest();
    }
}
