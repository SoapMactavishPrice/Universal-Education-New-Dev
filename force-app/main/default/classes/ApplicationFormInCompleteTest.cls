@isTest
public class ApplicationFormInCompleteTest {

    
    @isTest
    static void testCallUpdateDocument() {
        // Step 1: Create and insert test Enquiry record
        Enquiry__c enq = new Enquiry__c(Name = 'Test Enquiry');
        insert enq;

        // Step 2: Create and insert test Application Form record linked to Enquiry
        Application_Form__c appForm = new Application_Form__c(
            Name = 'Test Form',
            Enquiry__c = enq.Id,
            Status__c = 'New'
        );
        insert appForm;

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockSmsCallout());

        // Step 3: Set up test page and parameter
        PageReference pageRef = Page.Applicationform; // Replace with your actual VF page name
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', appForm.Id);

        // Step 4: Instantiate controller and invoke callUpdateDocument
        ApplicationFormInCompleteDocLightning controller = new ApplicationFormInCompleteDocLightning();
        PageReference redirectPage = controller.callUpdateDocument();

        Test.stopTest();

        // Step 5: Assertions
        // Re-query the updated records
        Application_Form__c updatedAppForm = [SELECT Status__c FROM Application_Form__c WHERE Id = :appForm.Id];
        Enquiry__c updatedEnq = [SELECT Stages__c FROM Enquiry__c WHERE Id = :enq.Id];

        
    }
}