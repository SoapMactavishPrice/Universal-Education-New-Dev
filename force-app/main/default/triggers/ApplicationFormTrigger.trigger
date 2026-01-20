trigger ApplicationFormTrigger on Application_Form__c (after Insert, after Update) {
    if (Trigger.isAfter) {
        // Call the handler method to process insert and update logic
        System.debug('firing trigger of insert/update for updating address fields');
     //   ApplicationFormTriggerHandler.updateAddressFields(Trigger.new);
   
        ApplicationTrgFormHandler.syncLeadFieldsFromApplicationForm(Trigger.new);
        ApplicationTrgFormHandler.syncEnquiryFieldsFromApplicationForm(Trigger.new);
    }
}