trigger AdmissionFormTrigger on Admission_Form__c (after Insert, after Update) {

if(Trigger.isafter && Trigger.isUpdate){
        Trigger_Switch__mdt Trigger_Switch = Trigger_Switch__mdt.getInstance('AdmissiFormupdateCurrentStatus');
        if (Trigger_Switch.IsActive__c == true) {
            AdmissionFormTriggerHandler.updateCurrentStatus(Trigger.new);
        }    
    }
    
    // Check if the trigger is after insert
    if (Trigger.isAfter && Trigger.isInsert) {
        // Call the handler method to process the insert logic
        AdmissionFormTriggerHandler.handleAfterInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        TransferNotesAcrossSystem.syncApplicationFormNotesToAdmissionForm(Trigger.new, null);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        Set<Id> leadIds = new Set<Id>();
        
        for (Admission_Form__c eachForm : Trigger.new) {
            if(eachForm.Lead__c != null){
                leadIds.add(eachForm.Lead__c);
            }
        }

        List<Lead> leads = new List<Lead>();
        for(Id leadId : leadIds){
            leads.add(new Lead(Id = leadId));
        }

        update leads;
    }
}