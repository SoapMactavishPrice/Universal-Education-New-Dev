trigger ContentVersionTrigger on ContentVersion (after insert) {
    if(Trigger.IsInsert && Trigger.IsAfter){
        ContentVersionTriggerHandler.doAfterInsert(Trigger.New);
    }
}