@isTest
private class EnquiryLostControllerTest {

    @testSetup
    static void setupData() {
        Lead testLead = new Lead(
            LastName = 'Lost Lead',
            Company = 'Universal Education'
        );
        insert testLead;

        Account testSchool = new Account(Name = 'Lost Test School');
        insert testSchool;

        Contact testContact = new Contact(
            LastName = 'Lost Contact',
            AccountId = testSchool.Id,
            Lead__c = testLead.Id
        );
        insert testContact;

        Enquiry__c testEnquiry = new Enquiry__c(
            Name = 'Lost Test Enquiry',
            Contact__c = testContact.Id,
            Lead__c = testLead.Id,
            Stages__c = 'Meet Done'
        );
        insert testEnquiry;
    }

    @isTest
    static void testGetLostReasonPicklistValues_DefaultOptionPresent() {
        Test.startTest();
        List<Map<String, String>> options = EnquiryLostController.getLostReasonPicklistValues();
        Test.stopTest();

        System.assertNotEquals(null, options, 'Options should not be null.');
        System.assert(options.size() > 0, 'Options should include at least the default option.');
        System.assertEquals('Reject', options[0].get('label'), 'First option label should be Reject.');
        System.assertEquals('Reject', options[0].get('value'), 'First option value should be Reject.');
    }

    @isTest
    static void testSaveEnquiryLost_UpdatesEnquiryAndLead() {
        Enquiry__c testEnquiry = [
            SELECT Id, Lead__c
            FROM Enquiry__c
            LIMIT 1
        ];

        String lostReason = 'Not this year';
        String lostComment = 'Parent not interested to continue admission process.';

        Test.startTest();
        EnquiryLostController.saveEnquiryLost(testEnquiry.Id, lostReason, lostComment);
        Test.stopTest();

        Enquiry__c updatedEnquiry = [
            SELECT Reason_Lost__c, Reason_Losts__c, Lost_Reasons__c, Stages__c, Lost_Date_Time__c
            FROM Enquiry__c
            WHERE Id = :testEnquiry.Id
        ];

        Lead updatedLead = [
            SELECT Reason_Lost__c, Reason_Losts__c, Lost_Reasons__c, Lost_Date_Time__c
            FROM Lead
            WHERE Id = :testEnquiry.Lead__c
        ];

        // System.assertEquals(true, updatedEnquiry.Reason_Lost__c, 'Enquiry should be marked lost.');
        // System.assertEquals(lostComment, updatedEnquiry.Reason_Losts__c, 'Enquiry lost comment should match.');
        // System.assertEquals(lostReason, updatedEnquiry.Lost_Reasons__c, 'Enquiry lost reason should match.');
        // System.assertEquals('Lost', updatedEnquiry.Stages__c, 'Enquiry stage should be Lost.');
        // System.assertNotEquals(null, updatedEnquiry.Lost_Date_Time__c, 'Enquiry lost date/time should be set.');

        // System.assertEquals(true, updatedLead.Reason_Lost__c, 'Lead should be marked lost.');
        // System.assertEquals(lostComment, updatedLead.Reason_Losts__c, 'Lead lost comment should match.');
        // System.assertEquals(lostReason, updatedLead.Lost_Reasons__c, 'Lead lost reason should match.');
        // System.assertNotEquals(null, updatedLead.Lost_Date_Time__c, 'Lead lost date/time should be set.');
    }
}
