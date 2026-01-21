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

    if (Trigger.isAfter && Trigger.isInsert) {
        TransferNotesAcrossSystem.syncAdmissionFormNotesToAdmissionGranted(Trigger.new, null);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        RecursiveTriComCurrStatusHandler.isFirstTime = true;
        List<Lead> leads = new List<Lead> ();
        for (Admission_Granted__c eachForm:Trigger.new) {
            Lead lead = new Lead();
            lead.Id = eachForm.Lead__c;
            leads.add(lead);
        }
        UPDATE leads;
    }
}