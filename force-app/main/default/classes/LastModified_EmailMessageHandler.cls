public class LastModified_EmailMessageHandler {
    public static void checkobject(List<Task> taskList){
        system.debug('call this, yes '+taskList);
        string objectname;
        // if(RecursiveTriComCurrStatusHandler.isFirstTime == True){
        if(!taskList.isEmpty()){
            for (Task t : taskList) {
                system.debug(' t.WhoId '+t.WhoId+' What Id '+t.WhatId);
                
                if(t.WhoId != null){
                    system.debug('t.WhoId'+t.WhoId);
                    objectname =t.WhoId;
                    objectname= objectname.left(3);                
                }else{
                    system.debug('t.what'+t.WhoId);
                    objectname =t.WhatId;objectname= objectname.left(3);
                }
            }
        }
        //} 
        
        system.debug('call this, yes '+objectname);
        if(System.Label.StartsWithLeadFormObj == objectname){  
            updateTaskModifyCountOnLead(taskList);
        }else if(System.Label.StartsWithContactFormObj == objectname){    
            updateTaskModifyOnContact(taskList);
        }else if(System.Label.StartsWithEnquiresObj == objectname){
            updateTaskModifyOnEnquiry(taskList);
        }else if(System.Label.StartsWithApplicationFormObj == objectname){
            system.debug('Application form'+System.Label.StartsWithApplicationFormObj);
            updateTaskModifyOnApplicationForm(taskList);
        }else if(System.Label.StartsWithAdmissionFormObj == objectname){
            updateTaskModifyOnAdmissionForm(taskList);
        }else if(System.Label.StartsWithAdmissionGrantedObj == objectname){
            updateTaskModifyOnAdmissionGranted(taskList);
        }
    }
    
    public static void updateTaskModifyCountOnLead(List<Task> taskLst){
        map<Id,DateTime> leadMapDate = new map<Id,DateTime>();
        
        for (Task t : taskLst) {
            if (t.WhoId!= null && string.valueof(t.WhoId).startsWith('00Q')) {
                leadMapDate.put(t.WhoId,t.CreatedDate);
            }
        }
        List<Lead> ldList = [select Id , Task_Count__c,Overall_Last_Activity_Date__c	,Last_Call_Date_Time__c from Lead where Id In : leadMapDate.keyset()];
        map<Id,Lead> ldMap = new map<Id,Lead>();
        
        for(Lead ld : ldList){
            if (leadMapDate.containskey(ld.Id)) {
                if(string.isNOTBLANK(string.valueOf(ld.Overall_Last_Activity_Date__c))){
                    if(ld.Overall_Last_Activity_Date__c < leadMapDate.get(ld.Id)){
                        ld.Overall_Last_Activity_Date__c = leadMapDate.get(ld.Id);
                        ldMap.put(ld.Id,ld);
                    }
                }else{
                    ld.Overall_Last_Activity_Date__c = leadMapDate.get(ld.Id);
                    ldMap.put(ld.Id,ld);
                }
            }
        }
        update ldMap.values();
        
        
    }
    //contact
    public static void updateTaskModifyOnContact(List<Task> taskLst){
        system.debug('inside contact mail');
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        for (Task t : taskLst) {
            if (t.WhoId!= null && string.valueof(t.WhoId).startsWith('003')) {
                upadateDateMap.put(t.WhoId,t.CreatedDate);
            }
        }
        system.debug('inside contact'+upadateDateMap.keyset());
        List<Contact> conList = [select Id,Lead__c,Lead__r.Overall_Last_Activity_Date__c from Contact where ID IN : upadateDateMap.keyset()];
        
        
        List<Lead> leadList = new  List<Lead>();
        for(Contact oTask: conList){
            system.debug('inside for'+oTask.Lead__c);
            if (upadateDateMap.containskey(oTask.Id) && String.isNotBlank(oTask.Lead__c)) {
                system.debug('inside if 1'+oTask.Lead__c);
                Lead ld = new Lead();
                ld.Id = oTask.Lead__c;
                if(string.isNOTBLANK(string.valueOf(oTask.Lead__r.Overall_Last_Activity_Date__c))){
                    if(oTask.Lead__r.Overall_Last_Activity_Date__c < upadateDateMap.get(oTask.Id)){
                        system.debug('inside if 3'+ld.Overall_Last_Activity_Date__c);
                        ld.Overall_Last_Activity_Date__c = upadateDateMap.get(oTask.Id);
                        leadList.add(ld);
                    }
                }else{
                    system.debug('inside if else'+ld.Overall_Last_Activity_Date__c);
                    ld.Overall_Last_Activity_Date__c = upadateDateMap.get(oTask.Id);
                    leadList.add(ld);
                }
            }
        }
        if(leadList.size() > 0){
            update leadList;
        }
    }
    //enquiry
    public static void updateTaskModifyOnEnquiry(List<Task> taskLst){
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        for (Task t : taskLst) {
            if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a01')) {
                upadateDateMap.put(t.WhatId,t.CreatedDate);
                
            }
        }
        
        List<Enquiry__c> conList = [select Id,Lead__c,Lead__r.Overall_Last_Activity_Date__c from Enquiry__c where ID IN : upadateDateMap.keyset()];
        system.debug('upadateDateMap'+upadateDateMap);
        List<Lead>leadList = new List<Lead>();
        for(Enquiry__c oTask: conList){
            if (upadateDateMap.containskey(oTask.Id) && String.isNotBlank(oTask.Lead__c)) {
                Lead ld = new Lead();
                ld.Id = oTask.Lead__c;
                if(string.isNOTBLANK(string.valueOf(oTask.Lead__r.Overall_Last_Activity_Date__c))){
                    if(oTask.Lead__r.Overall_Last_Activity_Date__c < upadateDateMap.get(oTask.Id)){
                        ld.Overall_Last_Activity_Date__c = upadateDateMap.get(oTask.Id);
                        leadList.add(ld);
                    }
                }else{
                    ld.Overall_Last_Activity_Date__c = upadateDateMap.get(oTask.Id);
                    leadList.add(ld);
                }
            }
        }
        if(leadList.size() > 0){
            update leadList;
        }
    }
    
    //Application Form
    public static void updateTaskModifyOnApplicationForm(List<Task> taskLst){
        system.debug('inside application form');
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        
        for (Task t : taskLst) {
            if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0N')) {
                system.debug('inside application t.WhatId'+t.WhatId);
                upadateDateMap.put(t.WhatId,t.CreatedDate);
                
            }
        }
        
        system.debug('upadateDateMap'+upadateDateMap);
        List<Application_Form__c> conList = [select Id,Lead__c,Lead__r.Overall_Last_Activity_Date__c from Application_Form__c where ID IN : upadateDateMap.keyset()];
        List<Lead> leadList = new  List<Lead>();
        
        for(Application_Form__c oTask: conList){
            if (upadateDateMap.containskey(oTask.Id) && String.isNotBlank(oTask.Lead__c)) {
                Lead ld = new Lead();
                ld.Id = oTask.Lead__c;
                if(string.isNOTBLANK(string.valueOf(oTask.Lead__r.Overall_Last_Activity_Date__c))){
                    if(oTask.Lead__r.Overall_Last_Activity_Date__c < upadateDateMap.get(oTask.Id)){
                        ld.Overall_Last_Activity_Date__c = upadateDateMap.get(oTask.Id);
                        leadList.add(ld);
                    }
                }else{
                    ld.Overall_Last_Activity_Date__c = upadateDateMap.get(oTask.Id);
                    leadList.add(ld);
                }
            }
        }
        if(leadList.size() > 0){
            update leadList;
        }
    }
    
    //admission form
    public static void updateTaskModifyOnAdmissionForm(List<Task> taskLst){
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        for (Task t : taskLst) {
            if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0L')) {
                upadateDateMap.put(t.WhatId,t.CreatedDate);
                
            }
        }
        
        List<Admission_Form__c> conList = [select Id,Lead__c,Lead__r.Overall_Last_Activity_Date__c from Admission_Form__c where ID IN : upadateDateMap.keyset()];
        List<Lead> leadList = new  List<Lead>();
        for(Admission_Form__c oTask: conList){
            if (upadateDateMap.containskey(oTask.Id)){
                Lead ld = new Lead();
                ld.Id = oTask.Lead__c;
                if(string.isNOTBLANK(string.valueOf(oTask.Lead__r.Overall_Last_Activity_Date__c))){
                    if(oTask.Lead__r.Overall_Last_Activity_Date__c < upadateDateMap.get(oTask.Id)){
                        ld.Overall_Last_Activity_Date__c = upadateDateMap.get(oTask.Id);
                        leadList.add(ld);
                    }
                }else{
                    ld.Overall_Last_Activity_Date__c = upadateDateMap.get(oTask.Id);
                    leadList.add(ld);
                }
            }
        }
        if(leadList.size() > 0){
            update leadList;
        }
    }
    
    
    // Admission Granted
    public static void updateTaskModifyOnAdmissionGranted(List<Task> taskLst){
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        system.debug('Inside granted');
        for (Task t : taskLst) {
            system.debug('Inside granted'+t.WhatId);
            if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0M')) {
                upadateDateMap.put(t.WhatId,t.CreatedDate);
                
            }
        }
        system.debug('Inside upadateDateMap'+upadateDateMap);
        List<Admission_Granted__c> conList = [select Id,Lead__c,Lead__r.Overall_Last_Activity_Date__c from Admission_Granted__c where ID IN : upadateDateMap.keyset()];
        
        List<Lead> leadList = new  List<Lead>();
        for(Admission_Granted__c oTask: conList){
            if (upadateDateMap.containskey(oTask.Id) && String.isNotBlank(oTask.Lead__c)) {
                Lead ld = new Lead();
                ld.Id = oTask.Lead__c;
                if(string.isNOTBLANK(string.valueOf(oTask.Lead__r.Overall_Last_Activity_Date__c))){
                    if(oTask.Lead__r.Overall_Last_Activity_Date__c < upadateDateMap.get(oTask.Id)){
                        ld.Overall_Last_Activity_Date__c = upadateDateMap.get(oTask.Id);
                        leadList.add(ld);
                    }
                }else{
                    ld.Overall_Last_Activity_Date__c = upadateDateMap.get(oTask.Id);
                    leadList.add(ld);
                }
            }
        }
        if(leadList.size() > 0){
            update leadList;
        }
    }
}