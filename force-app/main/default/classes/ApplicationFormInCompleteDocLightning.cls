public class ApplicationFormInCompleteDocLightning {

    public String applicationFormId { get; set; }
    public Boolean isActionExecuted { get; set; }

    // Constructor to get the record Id
    public ApplicationFormInCompleteDocLightning() {
        applicationFormId = ApexPages.currentPage().getParameters().get('id');
        isActionExecuted = false;  // Initially, the action has not been executed
    }

    // Method to automatically call when the page is loaded
    public PageReference callUpdateDocument() {
        Boolean result = UpdateDocumentInComplete(applicationFormId);
        isActionExecuted = true;  // Mark action as executed

        if (result) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Document status updated successfully.'));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error updating the document status.'));
        }

        // Redirect back to the record page
        PageReference recordPage = new PageReference('/' + applicationFormId); // Redirect to the record page
        return recordPage;  // Return the redirect to the record page
    }

    // Update document status method
    public static Boolean UpdateDocumentInComplete(String applicationFormId) {
        Boolean result = false;
        List<Enquiry__c> updateEnquiry = new List<Enquiry__c>();
        List<Application_Form__c> updateApplicationForm = new List<Application_Form__c>();
        try {
            Application_Form__c af = [SELECT Id, Status__c, Enquiry__c FROM Application_Form__c WHERE Id = :applicationFormId];
            af.Status__c = 'Document Incomplete';
            updateApplicationForm.add(af);

            update updateApplicationForm;

            Enquiry__c enq = [SELECT Id, Stages__c FROM Enquiry__c WHERE Id = :af.Enquiry__c];
            enq.Stages__c = 'Document Incomplete';
            updateEnquiry.add(enq);

            update updateEnquiry;

            result = true;
        } catch (DmlException e) {
            System.debug('Error: ' + e.getMessage());
            result = false;
        }

        return result;
    }
}