trigger EventTrigger on Event  (after insert,after Update) {
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        system.debug('call handler');
        LastModified_EventHandler.checkobject(trigger.new);
    }

}