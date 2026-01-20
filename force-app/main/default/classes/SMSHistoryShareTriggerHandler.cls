public   class SMSHistoryShareTriggerHandler {
    public static void afterInsert(List <tdc_tsw__message__c> lstMsg){
    try{
        Map<String,SchoolIdAndGroupId__c> customsetrecrd = SchoolIdAndGroupId__c.getAll();
        List<tdc_tsw__Message__share> newMessageShare = new List<tdc_tsw__Message__share>();  
        if(customsetrecrd != null && customsetrecrd.size() > 0){
              for(tdc_tsw__Message__c msg : lstMsg){
                String schoolId,schoolId18digit,schoolId15digit;
                if(msg.School_Id__c != null && msg.School_Id__c.length() > 15){
                    schoolId15digit = msg.School_Id__c.left(15);
                    schoolId18digit = msg.School_Id__c;
                }else{
                     schoolId15digit = msg.School_Id__c;
                    try{
                        schoolId18digit = Id.valueOf(msg.School_Id__c);
                    }catch(Exception ex){
                    
                    }
                }
                if(schoolId15digit != null && customsetrecrd.containskey(schoolId15digit)){
                    schoolId = schoolId15digit;
                }else if(schoolId18digit != null && customsetrecrd.containskey(schoolId18digit)){
                    schoolId = schoolId18digit;
                }
                System.debug(msg.School_Id__c);
                if(msg != null && schoolId!=null && msg.School_Id__c != null && customsetrecrd.containskey(schoolId)){
                  tdc_tsw__Message__share newShareRecord = new tdc_tsw__Message__share();
                    newShareRecord.ParentId = Msg.Id;
                    newShareRecord.AccessLevel = 'edit';
                    newShareRecord.UserOrGroupId =customsetrecrd.get(schoolId).groupId__c;
                    newShareRecord.RowCause = 'Manual';
                   newMessageShare.add(newShareRecord);
                }  
                }
            if(newMessageShare != null && newMessageShare.size() > 0){
                System.debug('newMessageShare'+newMessageShare);
                insert newMessageShare;
            }
        }
    }catch(Exception ex){
        System.debug(ex);
    }
}
}