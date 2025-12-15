public class LastModifiedTaskController {
    public static void checkobject(List<Task> taskList){
        system.debug('inside yes |||'+RecursiveTriComCurrStatusHandler.isFirstTime);
        string objectname;
        if(test.isRunningTest()){
            RecursiveTriComCurrStatusHandler.isFirstTime = true;
        }
        system.debug('inside yes |||'+RecursiveTriComCurrStatusHandler.isFirstTime);
        if(!taskList.isEmpty()){
            for (Task t : taskList) {
                system.debug('call  lead || contact '+ t.WhoId +' or other '+t.WhatId);
                if(t.WhoId != null){
                    objectname =t.WhoId;
                    objectname= objectname.left(3);                
                }else if(t.WhatId != null){
                   
                    objectname =t.WhatId;
                    objectname= objectname.left(3);
                }
            }
        }
        //} 
        
        if(System.Label.StartsWithLeadFormObj == objectname){ 
            system.debug('StartsWithLeadFormObj'+System.Label.StartsWithLeadFormObj);
            updateTaskModifyCountOnLead(taskList);
        }else if(System.Label.StartsWithContactFormObj == objectname){ 
            system.debug('StartsWithContactFormObj'+System.Label.StartsWithContactFormObj);
            updateTaskModifyOnContact(taskList);
        }else if(System.Label.StartsWithEnquiresObj == objectname){
            system.debug('StartsWithEnquiresObj'+System.Label.StartsWithEnquiresObj);
            updateTaskModifyOnEnquiry(taskList);
        }else if(System.Label.StartsWithApplicationFormObj == objectname){
            system.debug('StartsWithApplicationFormObj'+System.Label.StartsWithApplicationFormObj);
            updateTaskModifyOnApplicationForm(taskList);
        }else if(System.Label.StartsWithAdmissionFormObj == objectname){
            system.debug('StartsWithAdmissionFormObj'+System.Label.StartsWithAdmissionFormObj);
            updateTaskModifyOnAdmissionForm(taskList);
        }else if(System.Label.StartsWithAdmissionGrantedObj == objectname){
            system.debug('StartsWithAdmissionGrantedObj'+System.Label.StartsWithAdmissionGrantedObj);
            updateTaskModifyOnAdmissionGranted(taskList);
        }
    }
    
    public static void updateTaskModifyCountOnLead(List<Task> taskLst){
        map<Id,DateTime> leadMapDate = new map<Id,DateTime>();
        for (Task t : taskLst) {
            if (t.WhoId!= null && string.valueof(t.WhoId).startsWith('00Q')) {
                leadMapDate.put(t.WhoId, t.createdDate);
            }
        }
        
        List<Lead> ldList = [select Id , Task_Count__c,Overall_Last_Activity_Date__c	,Last_Call_Date_Time__c from Lead where Id In : leadMapDate.keyset()];
        map<Id,Lead> ldMap = new map<Id,Lead>();
        for(Lead ld : ldList){
            if (leadMapDate.containskey(ld.Id)) {
                if(string.isNOTBLANK(string.valueOf(ld.Overall_Last_Activity_Date__c))){
                    system.debug(ld.Overall_Last_Activity_Date__c);
                    system.debug(leadMapDate.get(ld.Id));
                    
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
        if(ldMap.size()>0){
        update ldMap.values();
        }
    }
    //contact
    public static void updateTaskModifyOnContact(List<Task> taskLst){
        system.debug('goes for contact');
        Set<ID> LeadIds = new Set<ID>();
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        
        for (Task t : taskLst) {
            if (t.WhoId!= null && string.valueof(t.WhoId).startsWith('003')) {
                system.debug('inside contact'+t.WhoId);
                upadateDateMap.put(t.WhoId,t.createdDate);
            }
        }
        
        system.debug('inside upadateDateMap'+upadateDateMap);
        List<Contact> conList = [select Id,Lead__c,Lead__r.Overall_Last_Activity_Date__c from Contact where ID IN : upadateDateMap.keyset()];
        
        system.debug('inside conList'+conList);
        List<Lead> leadList = new  List<Lead>();
        for(Contact oTask: conList){
            system.debug('inside cinatis if'+oTask.Id);
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
    
    
    
    //enquiry
    public static void updateTaskModifyOnEnquiry(List<Task> taskLst){
        Set<ID> parenIds = new Set<ID>();
        Set<ID> LeadIds = new Set<ID>();
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        
        for (Task t : taskLst) {
            if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a01')) {
                parenIds.add(t.WhatId);
                upadateDateMap.put(t.WhatId,t.createdDate);
                
            }
        }
        
        List<Enquiry__c> conList = [select Id,Lead__c,Lead__r.Overall_Last_Activity_Date__c from Enquiry__c where ID IN : parenIds];
        for(Enquiry__c con : conList){
            LeadIds.add(con.Lead__c);
        }
        List<Lead> leadList = new  List<Lead>();
        for(Enquiry__c oTask: conList){
            //if(String.isNotBlank(oTask.Lead__c)) {
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
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        
        for (Task t : taskLst) {
            if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0N')) {
                upadateDateMap.put(t.WhatId,t.createdDate);
                
            }
        }
        
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
                upadateDateMap.put(t.WhatId,t.createdDate);
                
            }
        }
        
        List<Admission_Form__c> conList = [select Id,Lead__c,Lead__r.Overall_Last_Activity_Date__c from Admission_Form__c where ID IN : upadateDateMap.keyset()];
        
        List<Lead> leadList = new  List<Lead>();
        for(Admission_Form__c oTask: conList){
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
            
        }    }
    
    
    // Admission Granted
    public static void updateTaskModifyOnAdmissionGranted(List<Task> taskLst){
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        for (Task t : taskLst) {
            if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0M')) {
                upadateDateMap.put(t.WhatId,t.createdDate);
                
            }
        }
        
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