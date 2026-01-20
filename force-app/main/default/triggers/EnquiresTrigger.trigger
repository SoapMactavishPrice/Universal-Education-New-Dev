trigger EnquiresTrigger on Enquiry__c (after Insert, after Update) {

	if(Trigger.isafter && Trigger.isUpdate){
        Trigger_Switch__mdt Trigger_Switch = Trigger_Switch__mdt.getInstance('EnquiresupdateCurrentStatus');
        if (Trigger_Switch.IsActive__c == true) {
            EnquiresTriggerHandler.updateCurrentStatus(Trigger.new);
        }    
    }
}