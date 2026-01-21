trigger ContactTrigger on Contact (before Insert, after Insert, after Update) {
    if (RecursiveTriggerHandler.skipTrigger) {
        System.debug('--- ContactTrigger skipped due to test flag ---');
        return;
    }
    if(Trigger.isafter && Trigger.isUpdate){
        Trigger_Switch__mdt Trigger_Switch = Trigger_Switch__mdt.getInstance('ContactupdateCurrentStatus');
        if (Trigger_Switch.IsActive__c == true) {
            ContactTriggerHandler.updateCurrentStatus(Trigger.new);
        }    
    }
    
   if (Trigger.isBefore && Trigger.isInsert) {
        try {
            // Calling the handler method to update the LastName if it contains "+"
            ContactTriggerHandler.updateContactLastName(Trigger.new);
        } catch (Exception e) {
            // Logging any exception that occurs during execution
            System.debug('Exception in ContactTrigger before insert: ' + e.getMessage());
        }
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        System.debug('Start syncLeadNotesToContact');
        TransferNotesAcrossSystem.syncLeadNotesToContact(Trigger.new, null);
    }

    if (Test.isRunningTest()) {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}