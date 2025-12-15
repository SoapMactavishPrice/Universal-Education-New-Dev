trigger AdmissionGrantedTrigger on Admission_Granted__c (after Insert, after Update, before insert, before update) {
if(Trigger.isafter && Trigger.isUpdate){
        Trigger_Switch__mdt Trigger_Switch = Trigger_Switch__mdt.getInstance('AdmissiGrantupdateCurrentStatus');
        if (Trigger_Switch.IsActive__c == true) {
            AdmissiGrantTriggerHandler.updateCurrentStatus(Trigger.new);
        }    
    }
    if(Trigger.isafter &&  Trigger.isUpdate){
        AdmissiGrantTriggerHandler.updateRemark(Trigger.new,Trigger.oldMap);
    }
    
    System.debug('Trigger Context: ' + Trigger.operationType + ', Size: ' + Trigger.new.size());
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        AdmissionGrantedHandler.updateApplicationCompletedDate(Trigger.new);
    }
}