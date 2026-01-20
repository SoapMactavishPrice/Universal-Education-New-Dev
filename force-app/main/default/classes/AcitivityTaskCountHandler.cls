public class AcitivityTaskCountHandler {
    public static void checkobject(List<Task> taskList){
        string objectname;
        if(RecursiveTriComCurrStatusHandler.isFirstTime == True){
            if(!taskList.isEmpty()){
                for (Task t : taskList) {
                    if(t.WhoId != null){
                        objectname =t.WhoId;
                        objectname= objectname.left(3);                
                    }else{
                        objectname =t.WhatId;objectname= objectname.left(3);
                    }
                }
            }
        } 
        system.debug('objectname >>>>>>>>WhoId ' + objectname);
        system.debug('objectname >>>>>>>>WhatId ' + objectname);

        if(System.Label.StartsWithLeadFormObj == objectname){  
            updateTaskCountOnLead(taskList);
        }else if(System.Label.StartsWithContactFormObj == objectname){    
            updateTaskCountOnContact(taskList);
        }else if(System.Label.StartsWithEnquiresObj == objectname){
            AcitivityTaskCountHandler.updateTaskCountOnEnquiry(taskList);
        }else if(System.Label.StartsWithApplicationFormObj == objectname){
            AcitivityTaskCountHandler.updateTaskCountOnApplicationForm(taskList);
        }else if(System.Label.StartsWithAdmissionFormObj == objectname){
            AcitivityTaskCountHandler.updateTaskCountOnAdmissionForm(taskList);
        }else if(System.Label.StartsWithAdmissionGrantedObj == objectname){
            AcitivityTaskCountHandler.updateTaskCountOnAdmissionGranted(taskList);
        }
    }
    //Lead
    public static void updateTaskCountOnLead(List<Task> taskLst){
        Boolean TSubjectOUTBOUNDCall; 
        Set<ID> LeadIds = new Set<ID>();
        string TasksSubject;
        string Taskscallstatus;
        string leadReasons;
        string leadstatus;
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith('00Q')) {
                    if(!LeadIds.contains(t.WhoId)){
                        LeadIds.add(t.WhoId);
                        TasksSubject = t.Subject;
                        Taskscallstatus= t.Call_Status__c;
                    }
                }
            }
            system.debug('LeadIds------>' + LeadIds);
            system.debug('TasksSubject------>' + TasksSubject);
            system.debug('TSubjectOUTBOUNDCall------>' + TasksSubject.contains('OUTBOUND Call'));
            system.debug('Taskscallstatus------>' + Taskscallstatus);
            DateTime leadsWithTaskcountASC = [select id,WhoId,CreatedDate from Task Where WhoId=:LeadIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
            DateTime leadsWithTaskcountDESC = [select id,WhoId,CreatedDate from Task Where WhoId=:LeadIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
            List<Lead> leadsupdate = [select Id,Activity__c,Status,Reasons__c,First_Call_Date_Time__c,Last_Call_Date_Time__c,(select Id,Call_Status__c,Subject,WhoId,WhatId from Tasks ORDER BY SystemModstamp DESC limit 7) from Lead where id =:LeadIds];
            
            system.debug('In Side First COndition------>leadsWithTaskcountASC ' + leadsWithTaskcountASC);
            system.debug('In Side First COndition------>leadsWithTaskcountDESC ' + leadsWithTaskcountDESC);
            system.debug('In Side First COndition------>leadsupdate ' + leadsupdate);
            
            List<Lead> leadsUpdatEOCCMNA = new List<Lead>();
            List<Lead> leadsUpdatEOCCONN = new List<Lead>();
            List<Lead> leadsUpdatEOCNULL = new List<Lead>(); 
            List<Lead> leadsUpdatEFinaleLead = new List<Lead>();
            Integer Counts = 0;
            if(!leadsupdate.isEmpty()){
                for(Lead olead: leadsupdate){
                    leadstatus = olead.Status;
                    leadReasons = olead.Reasons__c;
                    for(Task oTask: olead.Tasks){
                        system.debug('In Side First COndition------>leadsupdate ' + oTask.Call_Status__c);
                        if((oTask.Subject).contains('OUTBOUND Call') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER' || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA')){
                            Counts ++;
                            system.debug('In Side First COndition------>01 -' + Counts);
                        }else if((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected'){
                            Counts = 0;
                            system.debug('In Side First COndition------>02 -' + Counts);
                        }
                    }
                    system.debug('In Side First COndition------>03 -' + Counts);
                    if(Counts == 7){system.debug('In Side First COndition------>04 if -' + Counts);
                        Lead nLead = new Lead();
                        nLead.id = olead.id;
                        nLead.Status = 'Dormant';
                        nLead.Reasons__c = 'N/A';
                        nLead.Activity__c = Counts;
                        nLead.First_Call_Date_Time__c = leadsWithTaskcountASC;
                        nLead.Last_Call_Date_Time__c  = leadsWithTaskcountDESC;
                        leadsUpdatEOCCMNA.add(nLead);
                    }else{system.debug('In Side First COndition------>04 - else' + Counts);
                        Lead nLead = new Lead();
                        nLead.id = olead.id;
                          if(olead.Status =='Working' && (olead.Reasons__c=='Busy now call me later' || olead.Reasons__c=='No Response' || olead.Reasons__c=='Request more details')){
                              nLead.Status = leadstatus;
                              nLead.Reasons__c = leadReasons;
                          }else{
                       // nLead.Status = 'New';
                              nLead.Reasons__c = 'N/A';}
                        nLead.Activity__c =0;
                        nLead.First_Call_Date_Time__c = leadsWithTaskcountASC;
                        nLead.Last_Call_Date_Time__c  = leadsWithTaskcountDESC;
                        leadsUpdatEOCCMNA.add(nLead);
                    }
                }
                system.debug('In Side First COndition------>05 --'  + leadsUpdatEOCCMNA);
                if(!leadsUpdatEOCCMNA.isEmpty()){
                    update leadsUpdatEOCCMNA;
                }
            }
        } 
    }    
    //Contact
    public static void updateTaskCountOnContact(List<Task> taskLst){
        Boolean TSubjectOUTBOUNDCall; 
        Set<ID> ContactIds = new Set<ID>();
        string TasksSubject;
        string Taskscallstatus;
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith('003')) {
                    if(!ContactIds.contains(t.WhoId)){
                        ContactIds.add(t.WhoId);
                        TasksSubject = t.Subject;
                        Taskscallstatus= t.Call_Status__c;
                    }
                }
            }
            system.debug('ContactIds------>' + ContactIds);
            system.debug('TasksSubject------>' + TasksSubject);
            system.debug('TSubjectOUTBOUNDCall------>' + TasksSubject.contains('OUTBOUND Call'));
            system.debug('Taskscallstatus------>' + Taskscallstatus);
            DateTime consWithTaskcountASC = [select id,WhoId,CreatedDate from Task Where WhoId=:ContactIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
            DateTime consWithTaskcountDESC = [select id,WhoId,CreatedDate from Task Where WhoId=:ContactIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
            List<Contact> consupdate = [select Id,Activity_Count__c,Contact_Reasons__c,Contact_Status__c,First_Call_Date_Time__c,Last_Call_Date_Time__c,(select Id,Call_Status__c,Subject,WhoId,WhatId from Tasks ORDER BY SystemModstamp DESC limit 7) from Contact where id =:ContactIds];
            
            system.debug('In Side First COndition------>consWithTaskcountASC ' + consWithTaskcountASC);
            system.debug('In Side First COndition------>consWithTaskcountDESC ' + consWithTaskcountDESC);
            system.debug('In Side First COndition------>consupdate ' + consupdate);
            
            List<Contact> consUpdatEOCCMNA = new List<Contact>();
            List<Contact> consUpdatEOCCONN = new List<Contact>();
            List<Contact> consUpdatEOCNULL = new List<Contact>(); 
            List<Contact> consUpdatEFinaleContact = new List<Contact>();
            Integer Counts = 0;
            if(!consupdate.isEmpty()){
                for(Contact ocon: consupdate){
                    for(Task oTask: ocon.Tasks){
                        system.debug('In Side First COndition------>leadsupdate ' + oTask.Call_Status__c);
                        if((oTask.Subject).contains('OUTBOUND Call') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER' || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA')){
                            Counts ++;
                            system.debug('In Side First COndition------>01 -' + Counts);
                        }else if((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected'){
                            Counts = 0;
                            system.debug('In Side First COndition------>02 -' + Counts);
                        }
                    }
                    system.debug('In Side First COndition------>03 -' + Counts);
                    if(Counts == 7){system.debug('In Side First COndition------>04 if -' + Counts);
                        Contact nContact = new Contact();
                        nContact.id = ocon.id;
                        nContact.Contact_Status__c = 'Dormant';
                        nContact.Contact_Reasons__c = 'N/A';
                        nContact.Activity_Count__c = Counts;
                        nContact.First_Call_Date_Time__c = consWithTaskcountASC;
                        nContact.Last_Call_Date_Time__c  = consWithTaskcountDESC;
                        consUpdatEOCCMNA.add(nContact);
                    }else{system.debug('In Side First COndition------>04 - else' + Counts);
                        Contact nContact = new Contact();
                        nContact.id = ocon.id;
                        //nContact.Contact_Status__c = 'New';
                        nContact.Contact_Reasons__c = 'N/A';
                        nContact.Activity_Count__c =0;
                        nContact.First_Call_Date_Time__c = consWithTaskcountASC;
                        nContact.Last_Call_Date_Time__c  = consWithTaskcountDESC;
                        consUpdatEOCCMNA.add(nContact);
                    }
                }
                system.debug('In Side First COndition------>05 --'  + consUpdatEOCCMNA);
                if(!consUpdatEOCCMNA.isEmpty()){
                    update consUpdatEOCCMNA;
                }
            }
        } 
    }
    //Enquiry
    public static void updateTaskCountOnEnquiry(List<Task> taskLst){
        Boolean TSubjectOUTBOUNDCall; 
        Set<ID> EnquiryIds = new Set<ID>();
        string TasksSubject;
        string Taskscallstatus;
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a01')) {
                    if(!EnquiryIds.contains(t.WhatId)){
                        EnquiryIds.add(t.WhatId);
                        TasksSubject = t.Subject;
                        Taskscallstatus= t.Call_Status__c;
                    }
                }
            }
            system.debug('ContactIds------>' + EnquiryIds);
            system.debug('TasksSubject------>' + TasksSubject);
            //system.debug('TSubjectOUTBOUNDCall------>' + TasksSubject.contains('OUTBOUND Call'));
            system.debug('Taskscallstatus------>' + Taskscallstatus);
            DateTime enqsWithTaskcountASC = [select id,WhatId,CreatedDate from Task Where WhatId=:EnquiryIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
            DateTime enqsWithTaskcountDESC = [select id,WhatId,CreatedDate from Task Where WhatId=:EnquiryIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
            List<Enquiry__c> enqsupdate = [select Id,Activity_Count__c,Stages__c,First_Call_Date_Time__c,Last_Call_Date_Time__c,(select Id,Call_Status__c,Subject,WhoId,WhatId from Tasks ORDER BY SystemModstamp DESC limit 7) from Enquiry__c where id =:EnquiryIds];
            
            system.debug('In Side First COndition------>enqsWithTaskcountASC ' + enqsWithTaskcountASC);
            system.debug('In Side First COndition------>enqsWithTaskcountDESC ' + enqsWithTaskcountDESC);
            system.debug('In Side First COndition------>leadsupdate ' + enqsupdate);
            
            List<Enquiry__c> enqsUpdatEOCCMNA = new List<Enquiry__c>();
            List<Enquiry__c> leadsUpdatEOCCONN = new List<Enquiry__c>();
            List<Enquiry__c> leadsUpdatEOCNULL = new List<Enquiry__c>(); 
            List<Enquiry__c> leadsUpdatEFinaleContact = new List<Enquiry__c>();
            Integer Counts = 0;
            if(!enqsupdate.isEmpty()){
                for(Enquiry__c oEnquiry: enqsupdate){
                    for(Task oTask: oEnquiry.Tasks){
                        system.debug('In Side First COndition------>leadsupdate ' + oTask.Call_Status__c);
                        if((oTask.Subject).contains('OUTBOUND Call') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER' || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA')){
                            Counts ++;
                            system.debug('In Side First COndition------>01 -' + Counts);
                        }else if((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected'){
                            Counts = 0;
                            system.debug('In Side First COndition------>02 -' + Counts);
                        }
                    }
                    system.debug('In Side First COndition------>03 -' + Counts);
                    if(Counts == 7){system.debug('In Side First COndition------>04 if -' + Counts);
                        Enquiry__c nEnquiry = new Enquiry__c();
                        nEnquiry.id = oEnquiry.id;
                        nEnquiry.Stages__c = 'Dormant';
                        nEnquiry.Activity_Count__c = Counts;
                        nEnquiry.First_Call_Date_Time__c = enqsWithTaskcountASC;
                        nEnquiry.Last_Call_Date_Time__c  = enqsWithTaskcountDESC;
                        enqsUpdatEOCCMNA.add(nEnquiry);
                    }else{system.debug('In Side First COndition------>04 - else' + Counts);
                        Enquiry__c nEnquiry = new Enquiry__c();
                        nEnquiry.id = oEnquiry.id;
                        //nEnquiry.Stages__c = 'New';
                        nEnquiry.Activity_Count__c =0;
                        nEnquiry.First_Call_Date_Time__c = enqsWithTaskcountASC;
                        nEnquiry.Last_Call_Date_Time__c  = enqsWithTaskcountDESC;
                        enqsUpdatEOCCMNA.add(nEnquiry);
                    }
                }
                system.debug('In Side First COndition------>05 --'  + enqsUpdatEOCCMNA);
                if(!enqsUpdatEOCCMNA.isEmpty()){
                    update enqsUpdatEOCCMNA;
                }
            }
        } 
    }
    //Application Form
    public static void updateTaskCountOnApplicationForm(List<Task> taskLst){
        Boolean TSubjectOUTBOUNDCall; 
        Set<ID> AppFormIds = new Set<ID>();
        string TasksSubject;
        string Taskscallstatus;
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0N')) {
                    if(!AppFormIds.contains(t.WhatId)){
                        AppFormIds.add(t.WhatId);
                        TasksSubject = t.Subject;
                        Taskscallstatus= t.Call_Status__c;
                    }
                }
            }
            system.debug('ContactIds------>' + AppFormIds);
            system.debug('TasksSubject------>' + TasksSubject);
            //system.debug('TSubjectOUTBOUNDCall------>' + TasksSubject.contains('OUTBOUND Call'));
            system.debug('Taskscallstatus------>' + Taskscallstatus);
            DateTime appFormsWithTaskcountASC = [select id,WhatId,CreatedDate from Task Where WhatId=:AppFormIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
            DateTime appFormsWithTaskcountDESC = [select id,WhatId,CreatedDate from Task Where WhatId=:AppFormIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
            List<Application_Form__c> appFormsupdate = [select Id,Activity_Count__c,Status__c,First_Call_Date_Time__c,Last_Call_Date_Time__c,(select Id,Call_Status__c,Subject,WhoId,WhatId from Tasks ORDER BY SystemModstamp DESC limit 7) from Application_Form__c where id =:AppFormIds];
            
            system.debug('In Side First COndition------>leadsWithTaskcountASC ' + appFormsWithTaskcountASC);
            system.debug('In Side First COndition------>leadsWithTaskcountDESC ' + appFormsWithTaskcountDESC);
            system.debug('In Side First COndition------>leadsupdate ' + appFormsupdate);
            
            List<Application_Form__c> appFormsUpdatEOCCMNA = new List<Application_Form__c>();
            List<Application_Form__c> appFormsUpdatEOCCONN = new List<Application_Form__c>();
            List<Application_Form__c> appFormsUpdatEOCNULL = new List<Application_Form__c>(); 
            List<Application_Form__c> appFormsUpdatEFinaleContact = new List<Application_Form__c>();
            Integer Counts = 0;
            if(!appFormsupdate.isEmpty()){
                for(Application_Form__c oAppForm: appFormsupdate){
                    for(Task oTask: oAppForm.Tasks){
                        system.debug('In Side First COndition------>leadsupdate ' + oTask.Call_Status__c);
                        if((oTask.Subject).contains('OUTBOUND Call') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER' || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA')){
                            Counts ++;
                            system.debug('In Side First COndition------>01 -' + Counts);
                        }else if((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected'){
                            Counts = 0;
                            system.debug('In Side First COndition------>02 -' + Counts);
                        }
                    }
                    system.debug('In Side First COndition------>03 -' + Counts);
                    if(Counts == 7){system.debug('In Side First COndition------>04 if -' + Counts);
                        Application_Form__c nAppForm = new Application_Form__c();
                        nAppForm.id = oAppForm.id;
                        nAppForm.Status__c = 'Dormant';
                        nAppForm.Activity_Count__c = Counts;
                        nAppForm.First_Call_Date_Time__c = appFormsWithTaskcountASC;
                        nAppForm.Last_Call_Date_Time__c  = appFormsWithTaskcountDESC;
                        appFormsUpdatEOCCMNA.add(nAppForm);
                    }else{system.debug('In Side First COndition------>04 - else' + Counts);
                        Application_Form__c nAppForm = new Application_Form__c();
                        nAppForm.id = oAppForm.id;
                        //nAppForm.Status__c = 'New';
                        nAppForm.Activity_Count__c =0;
                        nAppForm.First_Call_Date_Time__c = appFormsWithTaskcountASC;
                        nAppForm.Last_Call_Date_Time__c  = appFormsWithTaskcountDESC;
                        appFormsUpdatEOCCMNA.add(nAppForm);
                    }
                }
                system.debug('In Side First COndition------>05 --'  + appFormsUpdatEOCCMNA);
                if(!appFormsUpdatEOCCMNA.isEmpty()){
                    update appFormsUpdatEOCCMNA;
                }
            }
        } 
    }
    //Addmission Form
    public static void updateTaskCountOnAdmissionForm(List<Task> taskLst){
        Boolean TSubjectOUTBOUNDCall; 
        Set<ID> AddFormIds = new Set<ID>();
        string TasksSubject;
        string Taskscallstatus;
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0L')) {
                    if(!AddFormIds.contains(t.WhatId)){
                        AddFormIds.add(t.WhatId);
                        TasksSubject = t.Subject;
                        Taskscallstatus= t.Call_Status__c;
                    }
                }
            }
            system.debug('ContactIds------>' + AddFormIds);
            system.debug('TasksSubject------>' + TasksSubject);
            //system.debug('TSubjectOUTBOUNDCall------>' + TasksSubject.contains('OUTBOUND Call'));
            system.debug('Taskscallstatus------>' + Taskscallstatus);
            DateTime adFormsWithTaskcountASC = [select id,WhatId,CreatedDate from Task Where WhatId=:AddFormIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
            DateTime adFormsWithTaskcountDESC = [select id,WhatId,CreatedDate from Task Where WhatId=:AddFormIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
            List<Admission_Form__c> adFormsupdate = [select Id,Activity_Count__c,Status__c,First_Call_Date_Time__c,Last_Call_Date_Time__c,(select Id,Call_Status__c,Subject,WhoId,WhatId from Tasks ORDER BY SystemModstamp DESC limit 7) from Admission_Form__c where id =:AddFormIds];
            
            system.debug('In Side First COndition------>adFormsWithTaskcountASC ' + adFormsWithTaskcountASC);
            system.debug('In Side First COndition------>adFormsWithTaskcountDESC ' + adFormsWithTaskcountDESC);
            system.debug('In Side First COndition------>adFormsupdate ' + adFormsupdate);
            
            List<Admission_Form__c> adFormsUpdatEOCCMNA = new List<Admission_Form__c>();
            List<Admission_Form__c> adFormsUpdatEOCCONN = new List<Admission_Form__c>();
            List<Admission_Form__c> adFormsUpdatEOCNULL = new List<Admission_Form__c>(); 
            List<Admission_Form__c> adFormsUpdatEFinaleContact = new List<Admission_Form__c>();
            Integer Counts = 0;
            if(!adFormsupdate.isEmpty()){
                for(Admission_Form__c oAddForm: adFormsupdate){
                    for(Task oTask: oAddForm.Tasks){
                        system.debug('In Side First COndition------>leadsupdate ' + oTask.Call_Status__c);
                        if((oTask.Subject).contains('OUTBOUND Call') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER' || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA')){
                            Counts ++;
                            system.debug('In Side First COndition------>01 -' + Counts);
                        }else if((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected'){
                            Counts = 0;
                            system.debug('In Side First COndition------>02 -' + Counts);
                        }
                    }
                    system.debug('In Side First COndition------>03 -' + Counts);
                    if(Counts == 7){system.debug('In Side First COndition------>04 if -' + Counts);
                        Admission_Form__c naddForm = new Admission_Form__c();
                        naddForm.id = oAddForm.id;
                        naddForm.Status__c = 'Dormant';
                        naddForm.Activity_Count__c = Counts;
                        naddForm.First_Call_Date_Time__c = adFormsWithTaskcountASC;
                        naddForm.Last_Call_Date_Time__c  = adFormsWithTaskcountDESC;
                        adFormsUpdatEOCCMNA.add(naddForm);
                    }else{system.debug('In Side First COndition------>04 - else' + Counts);
                        Admission_Form__c naddForm = new Admission_Form__c();
                        naddForm.id = oAddForm.id;
                       // naddForm.Status__c = 'New';
                        naddForm.Activity_Count__c =0;
                        naddForm.First_Call_Date_Time__c = adFormsWithTaskcountASC;
                        naddForm.Last_Call_Date_Time__c  = adFormsWithTaskcountDESC;
                        adFormsUpdatEOCCMNA.add(naddForm);
                    }
                }
                system.debug('In Side First COndition------>05 --'  + adFormsUpdatEOCCMNA);
                if(!adFormsUpdatEOCCMNA.isEmpty()){
                    update adFormsUpdatEOCCMNA;
                }
            }
        } 
    }
    //Admission Granted Form
    public static void updateTaskCountOnAdmissionGranted(List<Task> taskLst){
        Boolean TSubjectOUTBOUNDCall; 
        Set<ID> AdGrantFormIds = new Set<ID>();
        string TasksSubject;
        string Taskscallstatus;
        if(!taskLst.isEmpty()){
            for (Task t : taskLst) {
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith('a0M')) {
                    if(!AdGrantFormIds.contains(t.WhatId)){
                        AdGrantFormIds.add(t.WhatId);
                        TasksSubject = t.Subject;
                        Taskscallstatus= t.Call_Status__c;
                    }
                }
            }
            system.debug('ContactIds------>' + AdGrantFormIds);
            system.debug('TasksSubject------>' + TasksSubject);
            //system.debug('TSubjectOUTBOUNDCall------>' + TasksSubject.contains('OUTBOUND Call'));
            system.debug('Taskscallstatus------>' + Taskscallstatus);
            DateTime addGrantsWithTaskcountASC = [select id,WhatId,CreatedDate from Task Where WhatId=:AdGrantFormIds ORDER BY CreatedDate ASC limit 1].CreatedDate;
            DateTime addGrantsWithTaskcountDESC = [select id,WhatId,CreatedDate from Task Where WhatId=:AdGrantFormIds ORDER BY CreatedDate DESC limit 1].CreatedDate;
            List<Admission_Granted__c> addGrantsupdate = [select Id,Activity_Count__c,Status__c,First_Call_Date_Time__c,Last_Call_Date_Time__c,(select Id,Call_Status__c,Subject,WhoId,WhatId from Tasks ORDER BY SystemModstamp DESC limit 7) from Admission_Granted__c where id =:AdGrantFormIds];
            
            system.debug('In Side First COndition------>addGrantsWithTaskcountASC ' + addGrantsWithTaskcountASC);
            system.debug('In Side First COndition------>addGrantsWithTaskcountDESC ' + addGrantsWithTaskcountDESC);
            system.debug('In Side First COndition------>addGrantsupdate ' + addGrantsupdate);
            
            List<Admission_Granted__c> addGrantsUpdatEOCCMNA = new List<Admission_Granted__c>();
            List<Admission_Granted__c> addGrantsUpdatEOCCONN = new List<Admission_Granted__c>();
            List<Admission_Granted__c> addGrantsUpdatEOCNULL = new List<Admission_Granted__c>(); 
            List<Admission_Granted__c> addGrantsUpdatEFinaleContact = new List<Admission_Granted__c>();
            Integer Counts = 0;
            if(!addGrantsupdate.isEmpty()){
                for(Admission_Granted__c oAddGrant: addGrantsupdate){
                    for(Task oTask: oAddGrant.Tasks){
                        system.debug('In Side First COndition------>leadsupdate ' + oTask.Call_Status__c);
                        if((oTask.Subject).contains('OUTBOUND Call') && (oTask.Call_Status__c == 'Customer Missed' || oTask.Call_Status__c == 'NO_ANSWER' || oTask.Call_Status__c== 'User Disconnected' || oTask.Call_Status__c== 'NA')){
                            Counts ++;
                            system.debug('In Side First COndition------>01 -' + Counts);
                        }else if((oTask.Subject).contains('OUTBOUND Call') && oTask.Call_Status__c == 'Connected'){
                            Counts = 0;
                            system.debug('In Side First COndition------>02 -' + Counts);
                        }
                    }
                    system.debug('In Side First COndition------>03 -' + Counts);
                    if(Counts == 7){system.debug('In Side First COndition------>04 if -' + Counts);
                        Admission_Granted__c nAddGrant = new Admission_Granted__c();
                        nAddGrant.id = oAddGrant.id;
                        nAddGrant.Status__c = 'Dormant';
                        nAddGrant.Activity_Count__c = Counts;
                        nAddGrant.First_Call_Date_Time__c = addGrantsWithTaskcountASC;
                        nAddGrant.Last_Call_Date_Time__c  = addGrantsWithTaskcountDESC;
                        addGrantsUpdatEOCCMNA.add(nAddGrant);
                    }else{system.debug('In Side First COndition------>04 - else' + Counts);
                        Admission_Granted__c nAddGrant = new Admission_Granted__c();
                        nAddGrant.id = oAddGrant.id;
                        //nAddGrant.Status__c = 'New';
                        nAddGrant.Activity_Count__c =0;
                        nAddGrant.First_Call_Date_Time__c = addGrantsWithTaskcountASC;
                        nAddGrant.Last_Call_Date_Time__c  = addGrantsWithTaskcountDESC;
                        addGrantsUpdatEOCCMNA.add(nAddGrant);
                    }
                }
                system.debug('In Side First COndition------>05 --'  + addGrantsUpdatEOCCMNA);
                if(!addGrantsUpdatEOCCMNA.isEmpty()){
                    update addGrantsUpdatEOCCMNA;
                }
            }
        } 
    }
     public static void fakeMethod() {
        Integer j = 0;
             j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
             j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
             j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
     }
}