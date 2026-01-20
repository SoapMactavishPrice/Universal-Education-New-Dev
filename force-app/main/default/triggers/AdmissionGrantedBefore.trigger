trigger AdmissionGrantedBefore on Admission_Granted__c (After update, after insert) {
 If (trigger.IsAfter){
 if(RecursiveTriggerHandler.isFirstTime){
        RecursiveTriggerHandler.isFirstTime = false;

 new AdmissionGrantedHandler().GenrateStudentCode(Trigger.new);
}

     if(trigger.isUpdate){
         List<Admission_Granted__c> listOfAdmission = new List<Admission_Granted__c>();
         
         for(Admission_Granted__c tmp : trigger.New){
             if(trigger.Oldmap.get(tmp.Id).Status__c != tmp.Status__c && tmp.Status__c == 'Admission Process Completed')
                 listOfAdmission.add(tmp);
         }
         
         if(listOfAdmission.size() > 0)
             AdmissionGrantedHandler.updateLeadAfterCompletion(listOfAdmission);
     }
 }
}