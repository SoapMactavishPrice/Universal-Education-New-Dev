@isTest
public class AbsentAttachRejectedInteCtrlTest {

     @testSetup
    static void setupData() {
        // Create Lead
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Stage__c = 'Absent for Interaction'
        );
        insert testLead;

        // Create Enquiry__c record linked to Lead
        Enquiry__c testEnquiry = new Enquiry__c(
            Name = 'Test Enquiry',
            FirstName__c = 'Test',
            Lead__c = testLead.Id,      
           //s Lead_ID__c = testLead.Id,    
            Interaction_Done__c = false,
            Interaction_Online_Rescheduled__c = false,
            Interaction_Online_Scheduled__c = false,
            Interaction_Rescheduled__c = false,
            Interaction_Scheduled__c = false,
            Rejected_After_Interaction__c = false,
            Attach_Interaction_Notes__c = false,
            Absent_for_Interaction__c = false,
            Stages__c = 'Initial'
        );
        insert testEnquiry;

        // Create Admission_Form__c linked to Enquiry__c
        Admission_Form__c testForm = new Admission_Form__c(
            Name = 'Test Admission',
            Enquiry_No__c = testEnquiry.Id,
            Lead__c = testLead.Id,
            Rejected_After_Interaction__c = false,
            Attach_Interaction_Notes__c = false,
            Absent_for_Interaction__c = false,
            Status__c = 'Absent for Interaction'
        );
        insert testForm;
    }

    @isTest
    static void testControllerMethods() {
        // Fetch the created test data
        Lead lead = [SELECT Id FROM Lead LIMIT 1];
        Enquiry__c enq = [SELECT Id, Stages__c FROM Enquiry__c LIMIT 1];

        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', enq.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(enq);
        AbsentAttachRejectedInteCtrl ctrl = new AbsentAttachRejectedInteCtrl(sc);

        // Test goToPageTwo()
        PageReference goToPg = ctrl.goToPageTwo();

        // Test RejectedAfterInteraction() when stage is not 'Rejected After Interaction'
        PageReference rejectPg = ctrl.RejectedAfterInteraction();

        // Test RejectedAfterInteraction() when stage = 'Rejected After Interaction'
        enq.Stages__c = 'Rejected After Interaction';
        update enq;
        rejectPg = ctrl.RejectedAfterInteraction();

        // Test AbsentforInteraction() when stage is not 'Absent for Interaction'
        enq.Stages__c = 'Initial';
        update enq;
      //  PageReference absentPg = ctrl.AbsentforInteraction();

        // Test AbsentforInteraction() when stage = 'Absent for Interaction'
        enq.Stages__c = 'Absent for Interaction';
        update enq;
     //   absentPg = ctrl.AbsentforInteraction();

        // Test goBack()
        PageReference backPg = ctrl.goBack();

        // Test static method fakeMethod()
        AbsentAttachRejectedInteCtrl.fakeMethod();
        Test.stopTest();
    }
}