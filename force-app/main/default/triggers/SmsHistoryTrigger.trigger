trigger SmsHistoryTrigger on tdc_tsw__Message__c (after Insert) {
    if(trigger.isAfter && trigger.isInsert){
      try{
        tdc_tsw__SMSIncomingAlert__c sch = tdc_tsw__SMSIncomingAlert__c.getInstance('StopHistoryTrigger');
        if(sch==null){
        SMSHistoryShareTriggerHandler.afterInsert(trigger.new);
        }
        }catch(Exception ex){}
    }
}