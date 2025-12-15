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
}