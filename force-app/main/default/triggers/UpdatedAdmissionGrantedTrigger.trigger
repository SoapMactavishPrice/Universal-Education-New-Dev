trigger UpdatedAdmissionGrantedTrigger on Admission_Granted__c (before insert, before update) {
    try {
        System.debug('--- AdmissionGrantedTrigger started ---');
        
        // Only process records that are being inserted or updated
        if (Trigger.isBefore) {
            // Call the handler method to update the RecordTypeId
            UpdatedAdmissionGrantedHandler.updateRecordTypeOnAdmissionGranted(Trigger.new);
        }
    } catch (Exception e) {
        // Log exception if any
        System.debug('Error in AdmissionGrantedTrigger: ' + e.getMessage());
    }
}