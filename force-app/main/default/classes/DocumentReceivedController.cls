public with sharing class DocumentReceivedController {

    @RemoteAction
    public static Boolean updateDocumentReceived(String recordId) {
        Boolean result = false;
        try {
            // Query the Admission_Form__c record
            Admission_Form__c admissionForm = [SELECT Id, Document_Received__c 
                                               FROM Admission_Form__c 
                                               WHERE Id = :recordId LIMIT 1];

            // If the document is already marked as received, return true
            if (admissionForm.Document_Received__c) {
                return true;
            }

            // Update the Document_Received__c field
            admissionForm.Document_Received__c = true;
            update admissionForm;

            result = true; // Successfully marked as received
        } catch (Exception e) {
            // Handle any exceptions if necessary (no alert here)
            System.debug('Error: ' + e.getMessage());
        }
        return result;
    }
}