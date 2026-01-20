trigger ApplicationFormTrigger on Application_Form__c (after Insert, after Update) {

    if (Trigger.isAfter) {
        // Call the handler method to process insert and update logic
        System.debug('firing trigger of insert/update for updating address fields');
     //   ApplicationFormTriggerHandler.updateAddressFields(Trigger.new);
        ApplicationTrgFormHandler.syncLeadFieldsFromApplicationForm(Trigger.new);
        ApplicationTrgFormHandler.syncEnquiryFieldsFromApplicationForm(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Lead> leads = new List<Lead> ();
        for (Application_Form__c eachForm:Trigger.new) {
            Lead lead = new Lead();
            lead.Id = eachForm.Lead__c;
            leads.add(lead);
        }
        UPDATE leads;
    }
}