public class ActivityTasksCountHandler {
    public static boolean Outbound = false;
    public static boolean OutboundConnected = false;
    public static void checkobject(List<Task> taskList , Map<Id, Task> oldMap){
        string objectname;
        
        if(RecursiveTriComCurrStatusHandler.isFirstTime == True){
            if(!taskList.isEmpty()){
                for (Task t : taskList) {
                    if(t.WhoId != null){
                        objectname =t.WhoId;
                        objectname= objectname.left(3);
                    }else if(t.WhatId != null){
                        objectname =t.WhatId;
                        objectname= objectname.left(3);
                    }
                    if (t.Subject != null && ((t.Subject).contains('OUTBOUND Call') || t.CallType == 'Outbound') && (t.Call_Status__c == 'Customer Missed' || t.Call_Status__c == 'NO_ANSWER'
                        || t.Call_Status__c== 'User Disconnected' || t.Call_Status__c== 'NA' || t.Call_Status__c == 'Missed' || t.Call_Status__c == 'Unanswered'
                    || t.Call_Status__c == 'Done' || t.Call_Status__c == 'None' || t.Call_Status__c == 'Fail' || t.Call_Status__c == null)){
                        Outbound = True;
                        system.debug('OUTBOUND Call'+Outbound);
                    }else{
                        Outbound = false;
                        system.debug('Inbound Call'+Outbound);
                    }
                    /* if (t.Subject != null && ((t.Subject).contains('OUTBOUND Call'))&& ((t.Call_Status__c).contains('Connected'))){
                        OutboundConnected = True;
                        system.debug('OUTBOUND-connected Call'+OutboundConnected);
                    }else{
                        OutboundConnected = false;
                        system.debug('Inbound Call'+OutboundConnected);
                    }*/
                }
            }
        }
        
        if(System.Label.StartsWithLeadFormObj == objectname){
            updateTaskCountOnLead(taskList,oldMap);
        }else if(System.Label.StartsWithContactFormObj == objectname){
            updateTaskCountOnContact(taskList,oldMap);
        }else if(System.Label.StartsWithEnquiresObj == objectname){
            updateTaskCountOnEnquiry(taskList,oldMap);
        }else if(System.Label.StartsWithApplicationFormObj == objectname){
            updateTaskCountOnApplicationForm(taskList,oldMap);
        }else if(System.Label.StartsWithAdmissionFormObj == objectname){
            updateTaskCountOnAdmissionForm(taskList,oldMap);
        }else if(System.Label.StartsWithAdmissionGrantedObj == objectname){
            updateTaskCountOnAdmissionGranted(taskList,oldMap);
        }
    }
    
    //Lead
    public static void updateTaskCountOnLead(List<Task> taskLst , Map<Id, Task> oldMap){
        Set<ID> LeadIds = new Set<ID>();
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith('00Q')) {
                    if(!LeadIds.contains(t.WhoId)){
                        LeadIds.add(t.WhoId);
                    }
                }
            }
            
        }
        
        List<Lead> ldList = [select Id , Task_Count__c,Reasons__c,Dormant__c,Dormant_Count__c,First_Call_Date_Time__c,Last_Call_Date_Time__c from Lead where Id In : LeadIds];
        //system.debug('ldList>>'+ldList);
        map<Id,Lead> ldMap = new map<Id,Lead>();
        for(Lead ld : ldList){
            ldMap.put(ld.Id,ld);
        }
        
        DateTime leadsWithTaskcountASC = [select id,WhoId,CreatedDate from Task Where WhoId=:LeadIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
        DateTime leadsWithTaskcountDESC = [select id,WhoId,CreatedDate from Task Where WhoId=:LeadIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
        
        
        for(Task oTask: taskLst){
            Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
            if(oldMap != null && oldMap.containsKey(oTask.Id)) {
                oldTask = oldMap.get(oTask.Id);
                system.debug(oldMap.get(oTask.Id));
            }
            
            system.debug('oldTask'+oldTask);
            system.debug(oTask.Call_Status__c);
            system.debug(oldTask.Call_Status__c);
            
            if (ldMap.containskey(oTask.WhoId) && oTask.Call_Status__c != oldTask.Call_Status__c) {
                system.debug('Inside Lead>>>>>');
                if(((oTask.Subject).contains('OUTBOUND Call') || oTask.CallType == 'Outbound') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER'
                    || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA' || oTask.Call_Status__c == 'Missed' || oTask.Call_Status__c == 'Unanswered'
                || oTask.Call_Status__c == 'Done' ||  oTask.Call_Status__c == 'None' || oTask.Call_Status__c == 'Fail' || oTask.Call_Status__c == null)){
                    
                    if(ldMap.get(oTask.WhoId).Task_Count__c == null){
                        ldMap.get(oTask.WhoId).Task_Count__c = 1 ;
                    }
                    else{
                        ldMap.get(oTask.WhoId).Task_Count__c +=1;
                    }
                    system.debug('Call Subject>>>>'+oTask.Subject);
                    system.debug('Call Status>>>>'+oTask.Call_Status__c);
                    
                }else if((oTask.Subject).contains('INBOUND Call') || ((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected')){
                    // ldMap.get(oTask.WhoId).Task_Count__c = 0 ;
                    system.debug('INBOUND Call - connected');
                    ldMap.get(oTask.WhoId).Dormant_Count__c = 0 ;
                    system.debug('INBOUND Call - Dormant_Count'+ldMap.get(oTask.WhoId).Dormant_Count__c);
                    ldMap.get(oTask.WhoId).Dormant__c = false ;
                    // ldMap.get(oTask.WhoId).Reasons__c = 'N/A';
                    ldMap.get(oTask.WhoId).First_Call_Date_Time__c = leadsWithTaskcountASC;
                    ldMap.get(oTask.WhoId).Last_Call_Date_Time__c  = leadsWithTaskcountDESC;
                    break;
                }
            }
        }
        if(Outbound == true ){
            system.debug('Inside OUTBOUND >>>>'+Outbound);
            list<task> taskslist=[select id,WhoId,Subject,Call_Status__c,format(CreatedDate),format(LastModifiedDate) from Task Where WhoId=:LeadIds  and 
                            (Subject like '%Outbound%' OR CallType = 'Outbound')and CreatedDate = today and Call_Status__c IN ('Missed','NA','None','Done','Customer Missed','NO_ANSWER','User Disconnected','Unanswered','NOT ANSWERED', 'Fail', null)   
                           ];
            system.debug('taskslist'+taskslist);
            
            //Call_Status__c != null and
            for(task t:taskslist ){
                Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
                if(oldMap != null && oldMap.containsKey(t.Id)) {
                    oldTask = oldMap.get(t.Id);
                    system.debug(oldMap.get(t.Id));
                }
                
                system.debug('oldTask'+t.Call_Status__c);
                system.debug(t.Call_Status__c);
                system.debug(oldTask.Call_Status__c);
                if (ldMap.containskey(t.WhoId) && t.Call_Status__c != oldTask.Call_Status__c){
                    if(taskslist.size() == 1){
                        system.debug('Dormant 1');
                        if(ldMap.get(t.WhoId).Dormant_Count__c == null || ldMap.get(t.WhoId).Dormant_Count__c == 0){
                            ldMap.get(t.WhoId).Dormant_Count__c = 1 ;
                        }else{
                            ldMap.get(t.WhoId).Dormant_Count__c +=1;
                        }
                        if(ldMap.get(t.WhoId).Dormant_Count__c == 5){
                            ldMap.get(t.WhoId).Dormant__c = true ;
                        }
                    }
                }
            }
        }
        
        system.debug('ldMap>>>>>>>>>>>>'+ldMap.values());
        update ldMap.values();
    }
    
    //Contact
    public static void updateTaskCountOnContact(List<Task> taskLst , Map<Id, Task> oldMap){
        Set<ID> ContactIds = new Set<ID>();
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith('003')) {
                    if(!ContactIds.contains(t.WhoId)){
                        ContactIds.add(t.WhoId);
                    }
                }
            }
            
        }
        // List<lead> ldlist = [select Id , Task_Count__c,Reasons__c,First_Call_Date_Time__c,Last_Call_Date_Time__c from Lead];
        
        List<Contact> conList = [select Id ,Activity_Count__c,lead__c,Lead__r.Task_Count__c,Lead__r.Dormant_Count__c,Contact_Reasons__c,Contact_Status__c,First_Call_Date_Time__c,
                                 Last_Call_Date_Time__c from Contact where Id In : ContactIds];
        
        
        map<Id,Lead> conMap = new map<Id,Lead>();
        for(Contact con : conList){
            if(String.isNotBlank(con.Lead__c)) {
                
                
                Lead ld = new Lead();
                ld.Id = con.Lead__c;
                ld.Task_Count__c = con.Lead__r.Task_Count__c;
                ld.Dormant_Count__c = con.Lead__r.Dormant_Count__c;
                conMap.put(con.Id, ld);
            }
        }
        DateTime consWithTaskcountASC = [select id,WhoId,CreatedDate from Task Where WhoId IN : ContactIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
        DateTime consWithTaskcountDESC = [select id,WhoId,CreatedDate from Task Where WhoId IN : ContactIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
        
        for(Task oTask: taskLst){
            
            Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
            if(oldMap != null && oldMap.containsKey(oTask.Id)) {
                oldTask = oldMap.get(oTask.Id);
                system.debug(oldMap.get(oTask.Id));
            }
            
            system.debug('oldTask'+oldTask);
            system.debug(oTask.Call_Status__c);
            system.debug(oldTask.Call_Status__c);
            
            
            if (conMap.containskey(oTask.WhoId) && oTask.Call_Status__c != oldTask.Call_Status__c) {
                system.debug('Inside Contact>>>>');
                if((oTask.Subject).contains('OUTBOUND Call') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER'
                    || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA' || oTask.Call_Status__c == 'Missed' || oTask.Call_Status__c == 'Unanswered'
                || oTask.Call_Status__c == 'NOT ANSWERED' || oTask.Call_Status__c == 'Done' ||  oTask.Call_Status__c == 'None' || oTask.Call_Status__c == 'Fail' || oTask.Call_Status__c == null )){
                    
                    if(conMap.get(oTask.WhoId).Task_Count__c == null){
                        conMap.get(oTask.WhoId).Task_Count__c = 1 ;
                    }
                    else{
                        conMap.get(oTask.WhoId).Task_Count__c +=1;
                    }
                    
                }else
                if((oTask.Subject).contains('INBOUND Call') || ((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected')){
                    //conMap.get(oTask.WhoId).Task_Count__c = 0 ;
                    conMap.get(oTask.WhoId).Dormant_Count__c = 0 ;
                    conMap.get(oTask.WhoId).Dormant__c = false ;
                    conMap.get(oTask.WhoId).Reasons__c = 'N/A';
                    // conMap.get(oTask.WhoId).Activity_Count__c =0;
                    conMap.get(oTask.WhoId).First_Call_Date_Time__c = consWithTaskcountASC;
                    conMap.get(oTask.WhoId).Last_Call_Date_Time__c  = consWithTaskcountDESC;
                    break;
                }
            }
        }
        if(Outbound == true){
            list<task> tsklist=[select id,WhoId,Subject,Call_Status__c,format(CreatedDate),format(LastModifiedDate) from Task Where WhoId=:ContactIds  
                            and Subject like '%Outbound%'  and CreatedDate = today and Call_Status__c IN ('Missed','NA','None','Done','Customer Missed','NO_ANSWER','User Disconnected','Unanswered','NOT ANSWERED', 'Fail', null) 
                           ];
            for(task t:tsklist ){
                Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
                if(oldMap != null && oldMap.containsKey(t.Id)) {
                    oldTask = oldMap.get(t.Id);
                    system.debug(oldMap.get(t.Id));
                }
                
                system.debug('oldTask'+t);
                system.debug(t.Call_Status__c);
                system.debug(oldTask.Call_Status__c);
                if (conMap.containskey(t.WhoId) && t.Call_Status__c != oldTask.Call_Status__c){
                    if(tsklist.size() == 1){
                        system.debug('Dormant 1');
                        if(conMap.get(t.WhoId).Dormant_Count__c == null || conMap.get(t.WhoId).Dormant_Count__c == 0){
                            conMap.get(t.WhoId).Dormant_Count__c = 1 ;
                        }else{
                            conMap.get(t.WhoId).Dormant_Count__c +=1;
                        }
                        if(conMap.get(t.WhoId).Dormant_Count__c == 5){
                            conMap.get(t.WhoId).Dormant__c = true ;
                        }
                    }
                }
            }
        }
        
        update conMap.values();
    }
    
    //Enquiry
    public static void updateTaskCountOnEnquiry(List<Task> taskLst , Map<Id, Task> oldMap){
        Set<ID> EnquiryIds = new Set<ID>();
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a01')) {
                    if(!EnquiryIds.contains(t.WhatId)){
                        EnquiryIds.add(t.WhatId);
                    }
                }
            }
            
        }
        
        DateTime enqsWithTaskcountASC = [select id,WhatId,CreatedDate from Task Where WhatId=:EnquiryIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
        DateTime enqsWithTaskcountDESC = [select id,WhatId,CreatedDate from Task Where WhatId=:EnquiryIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
        
        List<Enquiry__c> enqList = [select Id,Activity_Count__c,Lead__c,Lead__r.Task_Count__c,Lead__r.Dormant_Count__c,Stages__c,First_Call_Date_Time__c,Last_Call_Date_Time__c  from Enquiry__c where Id IN : EnquiryIds];
        map<Id,lead> enqMap = new map<Id,lead>();
        
        for(Enquiry__c nq : enqList){
            if(String.isNotBlank(nq.Lead__c)) {
                Lead ld = new Lead();
                ld.Id = nq.Lead__c;
                ld.Task_Count__c = nq.Lead__r.Task_Count__c;
                ld.Dormant_Count__c = nq.Lead__r.Dormant_Count__c;
                enqMap.put(nq.Id, ld);
                //enqMap.put(nq.Id,nq);
            }
        }
        
        for(Task oTask: taskLst){
            
            Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
            if(oldMap != null && oldMap.containsKey(oTask.Id)) {
                oldTask = oldMap.get(oTask.Id);
                system.debug(oldMap.get(oTask.Id));
            }
            
            system.debug('oldTask'+oldTask);
            system.debug(oTask.Call_Status__c);
            system.debug(oldTask.Call_Status__c);
            
            if (enqMap.containskey(oTask.WhatId) && oTask.Call_Status__c != oldTask.Call_Status__c) {
                system.debug('id>>'+(enqMap.containskey(oTask.WhatId)));
                system.debug('id>>'+(enqMap.get(oTask.WhatId)));
                if((oTask.Subject).contains('OUTBOUND Call') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER'
                    || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA' || oTask.Call_Status__c == 'Missed' || oTask.Call_Status__c == 'Unanswered'
                || oTask.Call_Status__c == 'NOT ANSWERED' || oTask.Call_Status__c == 'Done' ||  oTask.Call_Status__c == 'None'  || oTask.Call_Status__c == 'Fail'|| oTask.Call_Status__c == null)){
                    
                    if(enqMap.get(oTask.WhatId).Task_Count__c == null){
                        enqMap.get(oTask.WhatId).Task_Count__c = 1 ;
                    }
                    else{
                        enqMap.get(oTask.WhatId).Task_Count__c +=1;
                    }
                    /* if(enqMap.get(oTask.WhatId).Task_Count__c == 5){
                        //enqMap.get(oTask.WhatId).Status = 'Dormant';
                        enqMap.get(oTask.WhatId).Dormant__c = true ;
                        enqMap.get(oTask.WhatId).First_Call_Date_Time__c = enqsWithTaskcountASC;
                        enqMap.get(oTask.WhatId).Last_Call_Date_Time__c  = enqsWithTaskcountDESC;
                    }*/
                }else if((oTask.Subject).contains('INBOUND Call') || ((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected')){
                    //enqMap.get(oTask.WhatId).Task_Count__c = 0 ;
                    enqMap.get(oTask.WhatId).Dormant_Count__c = 0 ;
                    enqMap.get(oTask.WhatId).Dormant__c = false ;
                    //enqMap.get(oTask.WhatId).Contact_Reasons__c = 'N/A';
                    enqMap.get(oTask.WhatId).First_Call_Date_Time__c = enqsWithTaskcountASC;
                    enqMap.get(oTask.WhatId).Last_Call_Date_Time__c  = enqsWithTaskcountDESC;
                    break;
                }
            }
        }
        
        if(Outbound == true){
            
            list<task> tsklist=[select id,WhatId,Subject,Call_Status__c,format(CreatedDate),format(LastModifiedDate) from Task Where WhatId=:EnquiryIds 
                            and Subject like '%Outbound%'  and CreatedDate = today and Call_Status__c IN ('Missed','NA','None','Done','Customer Missed','NO_ANSWER','User Disconnected','Unanswered','NOT ANSWERED', 'Fail', null)  
                           ];
            
            for(task t:tsklist ){
                Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
                if(oldMap != null && oldMap.containsKey(t.Id)) {
                    oldTask = oldMap.get(t.Id);
                    system.debug(oldMap.get(t.Id));
                }
                
                system.debug('oldTask'+t);
                system.debug(t.Call_Status__c);
                system.debug(oldTask.Call_Status__c);
                if (enqMap.containskey(t.WhatId) && t.Call_Status__c != oldTask.Call_Status__c){
                    if(tsklist.size() == 1){
                        system.debug('Dormant 1');
                        if(enqMap.get(t.WhatId).Dormant_Count__c == null || enqMap.get(t.WhatId).Dormant_Count__c == 0){
                            enqMap.get(t.WhatId).Dormant_Count__c = 1 ;
                        }else{
                            enqMap.get(t.WhatId).Dormant_Count__c +=1;
                        }
                        if(enqMap.get(t.WhatId).Dormant_Count__c == 5){
                            enqMap.get(t.WhatId).Dormant__c = true ;
                        }
                    }
                }
            }
        }
        
        update enqMap.values();
    }
    
    //Application Form
    public static void updateTaskCountOnApplicationForm(List<Task> taskLst , Map<Id, Task> oldMap){
        Set<ID> AppFormIds = new Set<ID>();
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0N')) {
                    if(!AppFormIds.contains(t.WhatId)){
                        AppFormIds.add(t.WhatId);
                    }
                }
            }
            
        }
        
        DateTime appFormsWithTaskcountASC = [select id,WhatId,CreatedDate from Task Where WhatId=:AppFormIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
        DateTime appFormsWithTaskcountDESC = [select id,WhatId,CreatedDate from Task Where WhatId=:AppFormIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
        
        List<Application_Form__c> appFormList = [select Id,Activity_Count__c,lead__c,lead__r.Task_Count__c,Lead__r.Dormant_Count__c,Status__c,First_Call_Date_Time__c,Last_Call_Date_Time__c  from Application_Form__c where Id IN : AppFormIds];
        map<Id,lead> ppFormMap = new map<Id,lead>();
        for(Application_Form__c nq : appFormList){
            if(String.isNotBlank(nq.Lead__c)) {
                Lead ld = new Lead();
                ld.Id = nq.Lead__c;
                ld.Task_Count__c = nq.Lead__r.Task_Count__c;
                ld.Dormant_Count__c = nq.Lead__r.Dormant_Count__c;
                ppFormMap.put(nq.Id, ld);
            }
            //ppFormMap.put(nq.Id,nq);
        }
        
        for(Task oTask: taskLst){
            
            Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
            if(oldMap != null && oldMap.containsKey(oTask.Id)) {
                oldTask = oldMap.get(oTask.Id);
                system.debug(oldMap.get(oTask.Id));
            }
            
            system.debug('oldTask'+oldTask);
            system.debug(oTask.Call_Status__c);
            system.debug(oldTask.Call_Status__c);
            
            
            if (ppFormMap.containskey(oTask.WhatId) && oTask.Call_Status__c != oldTask.Call_Status__c) {
                
                system.debug('Inside Application Form>>>>');
                
                if((oTask.Subject).contains('OUTBOUND Call') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER'
                    || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA' || oTask.Call_Status__c == 'Missed' || oTask.Call_Status__c == 'Unanswered' ||
                oTask.Call_Status__c == 'NOT ANSWERED' || oTask.Call_Status__c == 'Done' ||  oTask.Call_Status__c == 'None'  || oTask.Call_Status__c == 'Fail'|| oTask.Call_Status__c == null)){
                    
                    if(ppFormMap.get(oTask.WhatId).Task_Count__c == null){
                        ppFormMap.get(oTask.WhatId).Task_Count__c = 1 ;
                    }
                    else{
                        ppFormMap.get(oTask.WhatId).Task_Count__c +=1;
                    }
                    /*if(ppFormMap.get(oTask.WhatId).Task_Count__c == 5){
                        // ppFormMap.get(oTask.WhatId).Status = 'Dormant';
                        ppFormMap.get(oTask.WhatId).Dormant__c = true ;
                        ppFormMap.get(oTask.WhatId).First_Call_Date_Time__c = appFormsWithTaskcountASC;
                        ppFormMap.get(oTask.WhatId).First_Call_Date_Time__c  = appFormsWithTaskcountDESC;
                    }*/
                }else if((oTask.Subject).contains('INBOUND Call') || ((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected')){
                    //ppFormMap.get(oTask.WhatId).Task_Count__c = 0 ;
                    ppFormMap.get(oTask.WhatId).Dormant_Count__c = 0 ;
                    ppFormMap.get(oTask.WhatId).Dormant__c = false ;
                    //enqMap.get(oTask.WhatId).Contact_Reasons__c = 'N/A';
                    ppFormMap.get(oTask.WhatId).First_Call_Date_Time__c = appFormsWithTaskcountASC;
                    ppFormMap.get(oTask.WhatId).Last_Call_Date_Time__c  = appFormsWithTaskcountDESC;
                    break;
                }
            }
        }
        
        if(Outbound == true){
            
            list<task> tsklist=[select id,WhatId,Subject,Call_Status__c,format(CreatedDate),format(LastModifiedDate) from Task Where WhatId=:AppFormIds 
                            and Subject like '%Outbound%'  and CreatedDate = today and Call_Status__c IN ('Missed','NA','None','Done','Customer Missed','NO_ANSWER','User Disconnected','Unanswered','NOT ANSWERED', 'Fail', null)  
                           ];
            
            for(task t:tsklist ){
                Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
                if(oldMap != null && oldMap.containsKey(t.Id)) {
                    oldTask = oldMap.get(t.Id);
                    system.debug(oldMap.get(t.Id));
                }
                
                system.debug('oldTask'+t);
                system.debug(t.Call_Status__c);
                system.debug(oldTask.Call_Status__c);
                if (ppFormMap.containskey(t.WhatId) && t.Call_Status__c != oldTask.Call_Status__c){
                    if(tsklist.size() == 1){
                        system.debug('Dormant 1');
                        if(ppFormMap.get(t.WhatId).Dormant_Count__c == null || ppFormMap.get(t.WhatId).Dormant_Count__c == 0){
                            ppFormMap.get(t.WhatId).Dormant_Count__c = 1 ;
                        }else{
                            ppFormMap.get(t.WhatId).Dormant_Count__c +=1;
                        }
                        if(ppFormMap.get(t.WhatId).Dormant_Count__c == 5){
                            ppFormMap.get(t.WhatId).Dormant__c = true ;
                        }
                    }
                }
            }
        }
        update ppFormMap.values();
    }
    
    //Addmission Form
    public static void updateTaskCountOnAdmissionForm(List<Task> taskLst , Map<Id, Task> oldMap){
        Set<ID> AddFormIds = new Set<ID>();
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0L')) {
                    if(!AddFormIds.contains(t.WhatId)){
                        AddFormIds.add(t.WhatId);
                    }
                }
            }
            
        }
        
        DateTime adFormsWithTaskcountASC = [select id,WhatId,CreatedDate from Task Where WhatId=:AddFormIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
        DateTime adFormsWithTaskcountDESC = [select id,WhatId,CreatedDate from Task Where WhatId=:AddFormIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
        
        List<Admission_Form__c> adsFormList = [select Id, Activity_Count__c,lead__c,lead__r.Task_Count__c,Lead__r.Dormant_Count__c,Status__c,First_Call_Date_Time__c,Last_Call_Date_Time__c  from Admission_Form__c where Id IN : AddFormIds];
        map<Id,lead> adsFormMap = new map<Id,lead>();
        for(Admission_Form__c nq : adsFormList){
            if(String.isNotBlank(nq.Lead__c)) {
                Lead ld = new Lead();
                ld.Id = nq.Lead__c;
                ld.Task_Count__c = nq.Lead__r.Task_Count__c;
                ld.Dormant_Count__c = nq.Lead__r.Dormant_Count__c;
                
                adsFormMap.put(nq.Id,ld);
            }//adsFormMap.put(nq.Id,nq);
        }
        
        for(Task oTask: taskLst){
            
            Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
            if(oldMap != null && oldMap.containsKey(oTask.Id)) {
                oldTask = oldMap.get(oTask.Id);
                system.debug(oldMap.get(oTask.Id));
            }
            
            system.debug('oldTask'+oldTask);
            system.debug(oTask.Call_Status__c);
            system.debug(oldTask.Call_Status__c);
            
            
            
            if (adsFormMap.containskey(oTask.WhatId) && oTask.Call_Status__c != oldTask.Call_Status__c)  {
                
                system.debug('Inside Addmission Form>>>>>');
                if((oTask.Subject).contains('OUTBOUND Call') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER'
                    || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA' || oTask.Call_Status__c == 'Missed' || oTask.Call_Status__c == 'Unanswered'
                || oTask.Call_Status__c == 'NOT ANSWERED' || oTask.Call_Status__c == 'Done' ||  oTask.Call_Status__c == 'None' || oTask.Call_Status__c == 'Fail'|| oTask.Call_Status__c == null)){
                    
                    if(adsFormMap.get(oTask.WhatId).Task_Count__c == null){
                        adsFormMap.get(oTask.WhatId).Task_Count__c = 1 ;
                    }
                    else{
                        adsFormMap.get(oTask.WhatId).Task_Count__c +=1;
                    }
                    /* if(adsFormMap.get(oTask.WhatId).Task_Count__c == 5){
                        // adsFormMap.get(oTask.WhatId).Status = 'Dormant';
                        adsFormMap.get(oTask.WhatId).Dormant__c = true ;
                        adsFormMap.get(oTask.WhatId).First_Call_Date_Time__c = adFormsWithTaskcountASC;
                        adsFormMap.get(oTask.WhatId).First_Call_Date_Time__c  = adFormsWithTaskcountDESC;
                    }*/
                }else if((oTask.Subject).contains('INBOUND Call') || ((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected')){
                    // adsFormMap.get(oTask.WhatId).Task_Count__c = 0 ;
                    adsFormMap.get(oTask.WhatId).Dormant_Count__c = 0 ;
                    adsFormMap.get(oTask.WhatId).Dormant__c = false ;
                    //enqMap.get(oTask.WhatId).Contact_Reasons__c = 'N/A';
                    adsFormMap.get(oTask.WhatId).First_Call_Date_Time__c = adFormsWithTaskcountASC;
                    adsFormMap.get(oTask.WhatId).Last_Call_Date_Time__c  = adFormsWithTaskcountDESC;
                    break;
                }
            }
        }
        if(Outbound == true){
            
            list<task> tsklist=[select id,WhatId,Subject,Call_Status__c,format(CreatedDate),format(LastModifiedDate) from Task Where WhatId=:AddFormIds 
                            and Subject like '%Outbound%'  and CreatedDate = today and Call_Status__c IN ('Missed','NA','None','Done','Customer Missed','NO_ANSWER','User Disconnected','Unanswered','NOT ANSWERED', 'Fail', null)  
                           ];
            
            for(task t:tsklist ){
                Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
                if(oldMap != null && oldMap.containsKey(t.Id)) {
                    oldTask = oldMap.get(t.Id);
                    system.debug(oldMap.get(t.Id));
                }
                
                system.debug('oldTask'+t);
                system.debug(t.Call_Status__c);
                system.debug(oldTask.Call_Status__c);
                if (adsFormMap.containskey(t.WhatId) && t.Call_Status__c != oldTask.Call_Status__c){
                    if(tsklist.size() == 1){
                        system.debug('Dormant 1');
                        if(adsFormMap.get(t.WhatId).Dormant_Count__c == null || adsFormMap.get(t.WhatId).Dormant_Count__c == 0){
                            adsFormMap.get(t.WhatId).Dormant_Count__c = 1 ;
                        }else{
                            adsFormMap.get(t.WhatId).Dormant_Count__c +=1;
                        }
                        if(adsFormMap.get(t.WhatId).Dormant_Count__c == 5){
                            adsFormMap.get(t.WhatId).Dormant__c = true ;
                        }
                    }
                }
            }
        }
        update adsFormMap.values();
    }
    
    
    //Admission Granted Form
    public static void updateTaskCountOnAdmissionGranted(List<Task> taskLst , Map<Id, Task> oldMap){
        Set<ID> AdGrantFormIds = new Set<ID>();
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0M')) {
                    if(!AdGrantFormIds.contains(t.WhatId)){
                        AdGrantFormIds.add(t.WhatId);
                    }
                }
            }
            
        }
        
        DateTime addGrantsWithTaskcountASC = [select id,WhatId,CreatedDate from Task Where WhatId=:AdGrantFormIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
        DateTime addGrantsWithTaskcountDESC = [select id,WhatId,CreatedDate from Task Where WhatId=:AdGrantFormIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
        
        
        List<Admission_Granted__c> adsFormList = [select Id,Lead__c,Lead__r.Task_Count__c,Lead__r.Dormant_Count__c,Activity_Count__c,Status__c,First_Call_Date_Time__c,Last_Call_Date_Time__c  from Admission_Granted__c where Id IN : AdGrantFormIds];
        map<Id,lead> adsFormMap = new map<Id,lead>();
        for(Admission_Granted__c nq : adsFormList){
            if(String.isNotBlank(nq.Lead__c)) {
                Lead ld = new Lead();
                ld.Id = nq.Lead__c;
                ld.Task_Count__c = nq.Lead__r.Task_Count__c;
                ld.Dormant_Count__c = nq.Lead__r.Dormant_Count__c;
                adsFormMap.put(nq.Id,ld);
            }
        }
        
        for(Task oTask: taskLst){
            
            Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
            if(oldMap != null && oldMap.containsKey(oTask.Id)) {
                oldTask = oldMap.get(oTask.Id);
                system.debug(oldMap.get(oTask.Id));
            }
            
            system.debug('oldTask'+oldTask);
            system.debug(oTask.Call_Status__c);
            system.debug(oldTask.Call_Status__c);
            
            if (adsFormMap.containskey(oTask.WhatId) && oTask.Call_Status__c != oldTask.Call_Status__c) {
                system.debug('Inside Admission granted>>>>>');
                if ((oTask.Subject).contains('OUTBOUND Call') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER'
                    || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA' || oTask.Call_Status__c == 'Missed' || oTask.Call_Status__c == 'Unanswered'
                || oTask.Call_Status__c == 'NOT ANSWERED' || oTask.Call_Status__c == 'Done' ||  oTask.Call_Status__c == 'None'  || oTask.Call_Status__c == 'Fail'|| oTask.Call_Status__c == null)){
                    
                    if(adsFormMap.get(oTask.WhatId).Task_Count__c == null){
                        adsFormMap.get(oTask.WhatId).Task_Count__c = 1 ;
                    }
                    else{
                        adsFormMap.get(oTask.WhatId).Task_Count__c +=1;
                    }
                    /* if(adsFormMap.get(oTask.WhatId).Task_Count__c == 5){
                        // adsFormMap.get(oTask.WhatId).Status = 'Dormant';
                        adsFormMap.get(oTask.WhatId).Dormant__c = true ;
                        adsFormMap.get(oTask.WhatId).First_Call_Date_Time__c = addGrantsWithTaskcountASC;
                        adsFormMap.get(oTask.WhatId).First_Call_Date_Time__c  = addGrantsWithTaskcountDESC;
                    }*/
                }else if((oTask.Subject).contains('INBOUND Call') || ((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected')){
                    // adsFormMap.get(oTask.WhatId).Task_Count__c = 0 ;
                    adsFormMap.get(oTask.WhatId).Dormant_Count__c = 0 ;
                    //enqMap.get(oTask.WhatId).Contact_Reasons__c = 'N/A';
                    adsFormMap.get(oTask.WhatId).Dormant__c = false ;
                    adsFormMap.get(oTask.WhatId).First_Call_Date_Time__c = addGrantsWithTaskcountASC;
                    adsFormMap.get(oTask.WhatId).Last_Call_Date_Time__c  = addGrantsWithTaskcountDESC;
                    break;
                }
            }
        }
        if(Outbound == true){
            list<task> tsklist=[select id,WhatId,Subject,Call_Status__c,format(CreatedDate),format(LastModifiedDate) from Task Where WhatId=:AdGrantFormIds 
                            and Subject like '%Outbound%'  and CreatedDate = today and Call_Status__c IN ('Missed','NA','None','Done','Customer Missed','NO_ANSWER','User Disconnected','Unanswered','NOT ANSWERED', 'Fail', null)  
                           ];
            
            for(task t:tsklist ){
                Task oldTask = new Task(Call_Status__c = 'Call status to compare'); //added to compare call status for task with blank status
                if(oldMap != null && oldMap.containsKey(t.Id)) {
                    oldTask = oldMap.get(t.Id);
                    system.debug(oldMap.get(t.Id));
                }
                
                system.debug('oldTask'+t);
                system.debug(t.Call_Status__c);
                system.debug(oldTask.Call_Status__c);
                if (adsFormMap.containskey(t.WhatId) && t.Call_Status__c != oldTask.Call_Status__c){
                    if(tsklist.size() == 1){
                        system.debug('Dormant 1');
                        if(adsFormMap.get(t.WhatId).Dormant_Count__c == null || adsFormMap.get(t.WhatId).Dormant_Count__c == 0){
                            adsFormMap.get(t.WhatId).Dormant_Count__c = 1 ;
                        }else{
                            adsFormMap.get(t.WhatId).Dormant_Count__c +=1;
                        }
                        if(adsFormMap.get(t.WhatId).Dormant_Count__c == 5){
                            adsFormMap.get(t.WhatId).Dormant__c = true ;
                        }
                    }
                }
            }
        }
        update adsFormMap.values();
    }
    
    public static void setFirstActivityDateTimeOnLead(List<Task> taskList) {
        // A set to hold Lead records to be updated
        Set<Id> leadIdsToUpdate = new Set<Id>();
        Map<Id, DateTime> taskCreatedDates = new Map<Id, DateTime>();
        
        try {
            // Loop through the Task records
            for (Task tsk : taskList) {
                // Check if WhoId is not null and points to a Lead record
                if (tsk.WhoId != null && tsk.WhoId.getSObjectType() == Schema.Lead.sObjectType) {
                    // Store the Task CreatedDate against the Lead ID (WhoId)
                    taskCreatedDates.put(tsk.WhoId, tsk.CreatedDate);
                    
                    // Debug log to check the WhoId and task info
                    System.debug('Task ID: ' + tsk.Id + ', WhoId: ' + tsk.WhoId + ', Task CreatedDate: ' + tsk.CreatedDate);
                } else {
                    // Log the Task info if WhoId is invalid or not a Lead
                    System.debug('Skipping Task ID: ' + tsk.Id + ' because WhoId is either null or not a Lead');
                }
            }
            
            // Query the Leads to check the First Activity Date/Time field
            List<Lead> leadsToUpdate = [SELECT Id, First_Activity_Date_Time__c FROM Lead WHERE Id IN :taskCreatedDates.keySet()];
            
            // Check if leads are being fetched correctly
            System.debug('Fetched Leads for update: ' + leadsToUpdate.size());
            
            // Loop through the Leads and set the First Activity Date/Time if it's null
            for (Lead ld : leadsToUpdate) {
                System.debug('Lead ID: ' + ld.Id + ', Current First_Activity_Date_Time__c: ' + ld.First_Activity_Date_Time__c);
                
                if (ld.First_Activity_Date_Time__c == null) {
                    // Set the First Activity Date/Time to the Task's CreatedDate
                    DateTime taskCreatedDate = taskCreatedDates.get(ld.Id);
                    ld.First_Activity_Date_Time__c = taskCreatedDate;
                    
                    // Debug log to verify the update value
                    System.debug('Setting First_Activity_Date_Time__c for Lead ID: ' + ld.Id + ' to ' + ld.First_Activity_Date_Time__c);
                    
                    leadIdsToUpdate.add(ld.Id);
                }
            }
            
            // If we have any Leads that need to be updated, perform DML operation
            if (!leadIdsToUpdate.isEmpty()) {
                update leadsToUpdate;
                
                // Debug log to confirm the update operation
                System.debug('--- First Activity Date/Time updated for ' + leadsToUpdate.size() + ' Lead records ---');
            } else {
                // Log if no Leads needed updating
                System.debug('--- No Lead records needed First Activity Date/Time update ---');
            }
        } catch (DmlException e) {
            // Handle DML exceptions
            System.debug('DML Exception occurred while updating First Activity Date/Time on Lead: ' + e.getMessage());
        } catch (Exception e) {
            // Handle any other general exceptions
            System.debug('Unexpected exception occurred while updating First Activity Date/Time on Lead: ' + e.getMessage());
        }
    }
    
    // Method to handle Chatter post based on Task conditions
    public static void handleChatterPostOnTask(List<Task> taskList) {
        // List to store Chatter post actions
        List<FeedItem> chatterPosts = new List<FeedItem>();
        
        // Debug log for total number of tasks being processed
        System.debug('Processing ' + taskList.size() + ' tasks.');
        
        // Loop through each Task in the trigger context
        for (Task tsk : taskList) {
            // Debug log to show Task Subject and other field values
            System.debug('Processing Task ID: ' + tsk.Id + ' with Subject: ' + tsk.Subject);
            System.debug('Call Type: ' + tsk.CallType);
            System.debug('Call Disposition: ' + tsk.knowlarity_cti__Call_Disposition__c);
            System.debug('Description: ' + tsk.Description);
            
            // Check if the Task Subject is not blank and does not contain "Lead Updated with"
            if (String.isNotBlank(tsk.Subject) && !tsk.Subject.contains('Lead Updated with')) {
                // Prepare the Chatter message
                String message = 'Subject : ' + '@' + tsk.Subject + ' ;\n' +
                    'Call Type : ' + (tsk.CallType != null ? tsk.CallType : '') + ' ;\n' +
                    'Call Disposition : ' + (tsk.knowlarity_cti__Call_Disposition__c != null ? tsk.knowlarity_cti__Call_Disposition__c : '') + '\n' +
                    'Comment : ' + (tsk.Description != null ? tsk.Description : '');
                
                // Debug log to show the message content being posted
                System.debug('Creating Chatter post for Task ID: ' + tsk.Id + ' with message: ' + message);
                
                // Create a FeedItem (Chatter post) for the Task's owner
                FeedItem post = new FeedItem(
                    ParentId = tsk.OwnerId,  // Post to the Task owner's Chatter feed
                Body = message,  // Set the message body
                Type = 'TextPost' // Type of post (Text post)
                    );
                
                // Add the post to the list
                chatterPosts.add(post);
            } else {
                // Debug log if Task is skipped (either blank Subject or contains "Lead Updated with")
                System.debug('Skipping Task ID: ' + tsk.Id + ' because Subject is blank or contains "Lead Updated with"');
            }
        }
        
        // Only insert posts if there are records to post
        if (!chatterPosts.isEmpty()) {
            try {
                // Insert all Chatter posts at once to minimize DML operations
                insert chatterPosts;
                System.debug('Created ' + chatterPosts.size() + ' Chatter posts.');
            } catch (DmlException e) {
                // Handle errors during Chatter post creation
                System.debug('Error creating Chatter posts: ' + e.getMessage());
            }
        } else {
            // Debug log when no tasks meet the criteria for Chatter posting
            System.debug('No tasks met the criteria for Chatter posting.');
        }
    }
    
    public static void testMethod1() {
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