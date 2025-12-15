public class LastModified_EventHandler {
    public static void checkobject(List<Event> taskList){
        string objectname;
        if(RecursiveTriComCurrStatusHandler.isFirstTime == True){
            if(!taskList.isEmpty()){
                for (Event t : taskList) {
                    if(t.WhoId != null){
                        objectname =t.WhoId;
                        objectname= objectname.left(3);                
                    }else if(t.WhatId != null){
                        
                        objectname =t.WhatId;objectname= objectname.left(3);
                    }
                }
            }
        } 
        
        if(System.Label.StartsWithLeadFormObj == objectname){ 
                        system.debug('StartsWithLeadFormObj'+System.Label.StartsWithLeadFormObj);
  updateTaskModifyCountOnLead(taskList);
        }else if(System.Label.StartsWithContactFormObj == objectname){ 
                        system.debug('StartsWithLeadFormObj'+System.Label.StartsWithContactFormObj);
            updateTaskModifyOnContact(taskList);
        }else if(System.Label.StartsWithEnquiresObj == objectname){
            system.debug('StartsWithLeadFormObj'+System.Label.StartsWithEnquiresObj);
            updateTaskModifyOnEnquiry(taskList);
        }else if(System.Label.StartsWithApplicationFormObj == objectname){
            system.debug('StartsWithLeadFormObj'+System.Label.StartsWithApplicationFormObj);
            updateTaskModifyOnApplicationForm(taskList);
        }else if(System.Label.StartsWithAdmissionFormObj == objectname){
            system.debug('StartsWithLeadFormObj'+System.Label.StartsWithAdmissionFormObj);
            updateTaskModifyOnAdmissionForm(taskList);
        }else if(System.Label.StartsWithAdmissionGrantedObj == objectname){
            system.debug('StartsWithLeadFormObj'+System.Label.StartsWithAdmissionGrantedObj);
            updateTaskModifyOnAdmissionGranted(taskList);
        }
    }
    
    public static void updateTaskModifyCountOnLead(List<Event> taskLst){
        Set<ID> LeadIds = new Set<ID>();
        
        for (Event t : taskLst) {
            if (t.WhoId!= null && string.valueof(t.WhoId).startsWith('00Q')) {
                LeadIds.add(t.WhoId);
            }
        }
        
        List<Lead> ldList = [select Id , Task_Count__c,Overall_Last_Activity_Date__c,Last_Call_Date_Time__c from Lead where Id In : LeadIds];
        map<Id,Lead> ldMap = new map<Id,Lead>();
        for(Lead ld : ldList){
            ldMap.put(ld.Id,ld);
			
        }
        
        for(Event oTask: taskLst){
            if (ldMap.containskey(oTask.WhoId)) {
                if(string.isNOTBLANK(string.valueOf(ldMap.get(oTask.WhoId).Overall_Last_Activity_Date__c))){
					system.debug('createddate'+oTask.CreatedDate);
					system.debug('createddate'+date.valueOf(oTask.CreatedDate));
                  if(ldMap.get(oTask.WhoId).Overall_Last_Activity_Date__c <  oTask.CreatedDate){
                    ldMap.get(oTask.WhoId).Overall_Last_Activity_Date__c = oTask.CreatedDate;
                }
            }else{
                    ldMap.get(oTask.WhoId).Overall_Last_Activity_Date__c = oTask.CreatedDate;
                }
        }
        
        
    }
        update ldMap.values();
    }
    //contact
    public static void updateTaskModifyOnContact(List<Event> taskLst){
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        for (Event t : taskLst) {
            if (t.WhoId!= null && string.valueof(t.WhoId).startsWith('003')) {
                upadateDateMap.put(t.WhoId,t.CreatedDate);
            }
        }
        
        List<Contact> conList = [select Id,Lead__c,Lead__r.Overall_Last_Activity_Date__c from Contact where ID IN : upadateDateMap.keyset()];
       
        
        List<Lead> leadList = new  List<Lead>();
        for(Contact oTask: conList){
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
    public static void updateTaskModifyOnEnquiry(List<Event> taskLst){
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        for (Event t : taskLst) {
            if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a01')) {
                upadateDateMap.put(t.WhatId,t.CreatedDate);
                
            }
        }
        
        List<Enquiry__c> conList = [select Id,Lead__c,Lead__r.Overall_Last_Activity_Date__c from Enquiry__c where ID IN : upadateDateMap.keyset()];
        
        List<Lead> leadList = new  List<Lead>();
        system.debug('upadateDateMap'+upadateDateMap);
        
        for(Enquiry__c oTask: conList){
            system.debug('inside for'+oTask.Id);
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
    public static void updateTaskModifyOnApplicationForm(List<Event> taskLst){
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        
        for (Event t : taskLst) {
            if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0N')) {
                upadateDateMap.put(t.WhatId,t.CreatedDate);
                
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
    public static void updateTaskModifyOnAdmissionForm(List<Event> taskLst){
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        
        for (Event t : taskLst) {
            if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0L')) {
                upadateDateMap.put(t.WhatId,t.CreatedDate);
                
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
            
        }
    }
    
    
    // Admission Granted
    public static void updateTaskModifyOnAdmissionGranted(List<Event> taskLst){
        map<Id,DateTime> upadateDateMap= new Map<Id,DateTime>();
        
        for (Event t : taskLst) {
            if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0M')) {
                upadateDateMap.put(t.WhatId,t.CreatedDate);
                
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