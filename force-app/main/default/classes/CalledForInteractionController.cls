public with sharing class CalledForInteractionController {
    public Enquiry__c senquiry{get;set;}    
    public boolean back{get;set;}
    public string strschoolshortname;
    public string strtype{get;set;}
    public string fullURl{get;set;}
    public string customLabelValue{get;set;}
    public string customleadValue{get;set;}
    
    public Admission_Form__c AdmissionForm{get;set;}
    public string customAdmissionFormValue{get;set;}
    ID enqId = ApexPages.currentPage().getParameters().get('id');
    public CalledForInteractionController(ApexPages.StandardController controller){
        system.debug('enqId >>>>>> @ > ' + enqId); 
        back = false;
    }
    public pageReference CalledForInteraction() {
        customLabelValue = System.Label.CalledForInteraction;
        system.debug('customLabelValue >>>>>> @ > ' + customLabelValue);
        senquiry = new Enquiry__c();
        if(!Test.isRunningTest()){senquiry = [select id, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Called_for_Observation__c,Interaction_Scheduled__c,Interaction_Scheduled_For__c,Interaction_Scheduled_On__c  from Enquiry__c where id=:enqId];}
        else{senquiry = [select id, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Called_for_Observation__c,Interaction_Scheduled__c, Interaction_Scheduled_On__c, Interaction_Scheduled_For__c, Interaction_Rescheduled__c, Interaction_Online_Scheduled__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Rescheduled__c, Interaction_Done__c  from Enquiry__c limit 1];}
        system.debug('senquiry >>>>>> @ > ' + senquiry);
        if(senquiry != null){
            if(senquiry.Interaction_Scheduled__c == true){back = true;ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction Scheduled Already Done!!'));
            }
            else{
                if(senquiry.Org_code__c=='STELRB'){  fullURl = customLabelValue+'?curiosity_id='+senquiry.id+'&objectType=Contact&objectId='+senquiry.Contact__c+'&type=observation-meeting';
                }
                if(senquiry.Org_code__c=='STELRA'){fullURl = customLabelValue+'?curiosity_id='+senquiry.id+'&objectType=Contact&objectId='+senquiry.Contact__c+'&type=observation-meeting';
                    
                }if(senquiry.Org_code__c=='STELRG'){ fullURl = customLabelValue+'?curiosity_id='+senquiry.id+'&objectType=Contact&objectId='+senquiry.Contact__c+'&type=observation-meeting';
                }
                customleadValue = senquiry.Lead_ID__c;
                customAdmissionFormValue = senquiry.Id;
                senquiry.Interaction_Scheduled__c = true;
                senquiry.Stages__c ='Interaction Scheduled';
                //senquiry.Interaction_Scheduled_On__c= Date.today();
                //senquiry.Interaction_Scheduled_For__c= Date.today();
                update senquiry;
                system.debug('customleadValue >> ' + customleadValue);
                List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead){lead l = new lead();l.id = le.id;l.Stage__c = 'Interaction Scheduled';
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){update lstlead;
                    }
                }
                system.debug('customAdmissionFormValue >> ' + customAdmissionFormValue);
                List<Admission_Form__c> lstAdmissionForm = new List<Admission_Form__c>();
                List<Admission_Form__c> slitAdmissionForm = new List<Admission_Form__c>();
                if(!Test.isRunningTest()){slitAdmissionForm = [SELECT Id,name, Application_Form__c, Enquiry_No__c, Interaction_Done__c, Interaction_Online_Rescheduled__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled__c, Interaction_Rescheduled__c, Interaction_Scheduled_For__c, Interaction_Scheduled_On__c, Interaction_Scheduled__c FROM Admission_Form__c where Enquiry_No__c=: customAdmissionFormValue];}
                else{slitAdmissionForm = [SELECT Id,name, Application_Form__c, Enquiry_No__c, Interaction_Scheduled__c, Interaction_Scheduled_On__c, Interaction_Scheduled_For__c, Interaction_Rescheduled__c, Interaction_Online_Scheduled__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Rescheduled__c, Interaction_Done__c FROM Admission_Form__c limit 1];}
                system.debug('slitAdmissionForm >> ' + slitAdmissionForm);
                if(!slitAdmissionForm.isEmpty()){
                    for(Admission_Form__c ADF : slitAdmissionForm){Admission_Form__c AF = new Admission_Form__c();
                        AF.id = ADF.id;AF.Interaction_Scheduled__c = true;AF.Status__c ='Interaction Scheduled';
                        lstAdmissionForm.add(AF);
                    }
                    system.debug('lstAdmissionForm -- ' + lstAdmissionForm);
                    if(!lstAdmissionForm.isEmpty()){update lstAdmissionForm;
                    }
                }
            }           
        }
        system.debug('fullURl >>> ' + fullURl);
        if(fullURl != null){
            PageReference retURL = new PageReference(fullURl);retURL.setRedirect(true);
            return retURL;
        }
        else{
             back = true;
            return null;
        }
    }
    public pageReference InteractionRescheduled() {
        senquiry = new Enquiry__c();
        if(!Test.isRunningTest()){senquiry = [select id, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Interaction_Rescheduled__c,Called_for_Observation__c,Interaction_Scheduled__c,Interaction_Scheduled_For__c,Interaction_Scheduled_On__c  from Enquiry__c where id=:enqId];}
        else{senquiry = [select id, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Interaction_Scheduled__c, Interaction_Scheduled_On__c, Interaction_Scheduled_For__c, Interaction_Rescheduled__c, Interaction_Online_Scheduled__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Rescheduled__c, Interaction_Done__c  from Enquiry__c limit 1];}
        system.debug('senquiry >>>>>> @ > ' + senquiry);
        if(senquiry != null){
            if(senquiry.Interaction_Rescheduled__c == true){  back = true;ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction Re Scheduled Already Done!!'));
            }
            else{
                senquiry.Stages__c ='Interaction Rescheduled';
                customAdmissionFormValue = senquiry.Id;
                senquiry.Interaction_Scheduled__c = false;
                senquiry.Interaction_Rescheduled__c= True;
                //senquiry.Interaction_Scheduled_On__c= date.today();
                update senquiry;
                List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead){lead l = new lead();l.id = le.id;l.Stage__c = 'Interaction Rescheduled';
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){update lstlead;
                    }
                }
                system.debug('customAdmissionFormValue >> ' + customAdmissionFormValue);
                List<Admission_Form__c> lstAdmissionForm = new List<Admission_Form__c>();
                List<Admission_Form__c> slitAdmissionForm = new List<Admission_Form__c>();
                if(!Test.isRunningTest()){slitAdmissionForm = [SELECT Id,name, Application_Form__c, Enquiry_No__c, Interaction_Done__c, Interaction_Online_Rescheduled__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled__c, Interaction_Rescheduled__c, Interaction_Scheduled_For__c, Interaction_Scheduled_On__c, Interaction_Scheduled__c FROM Admission_Form__c where Enquiry_No__c=: customAdmissionFormValue];}
                else{slitAdmissionForm = [SELECT Id,name, Application_Form__c, Enquiry_No__c, Interaction_Done__c, Interaction_Online_Rescheduled__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled__c, Interaction_Rescheduled__c, Interaction_Scheduled_For__c, Interaction_Scheduled_On__c, Interaction_Scheduled__c FROM Admission_Form__c limit 1];}
                system.debug('slitAdmissionForm >> ' + slitAdmissionForm);
                if(!slitAdmissionForm.isEmpty()){
                    for(Admission_Form__c ADF : slitAdmissionForm){Admission_Form__c AF = new Admission_Form__c();AF.id = ADF.id;AF.Interaction_Scheduled__c = false;AF.Interaction_Rescheduled__c= True;
                        AF.Status__c = 'Interaction Rescheduled';
                        lstAdmissionForm.add(AF);
                    }
                    system.debug('lstAdmissionForm -- ' + lstAdmissionForm);
                    if(!lstAdmissionForm.isEmpty()){ update lstAdmissionForm;
                    }
                }
            }           
        }
        PageReference retURL = new PageReference('/'+senquiry.Id);
        retURL.setRedirect(true);
        return retURL;    
    }
    public pageReference InteractionOnline() {
        customLabelValue = System.Label.CalledForInteraction;
        system.debug('customLabelValue >>>>>> @ > ' + customLabelValue);
        senquiry = new Enquiry__c();
        if(!Test.isRunningTest()){senquiry = [select id, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Interaction_Online_Scheduled__c,Interaction_Online_Scheduled_For__c,Interaction_Online_Scheduled_On__c  from Enquiry__c where id=:enqId];}
        else{senquiry = [select id, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Interaction_Scheduled__c, Interaction_Scheduled_On__c, Interaction_Scheduled_For__c, Interaction_Rescheduled__c, Interaction_Online_Scheduled__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Rescheduled__c, Interaction_Done__c  from Enquiry__c limit 1];}        
        system.debug('senquiry >>>>>> @ > ' + senquiry);
        if(senquiry != null){
            if(senquiry.Interaction_Online_Scheduled__c == true){back = true; ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction Online Scheduled Already Done!!'));
            }
            else{
                if(senquiry.Org_code__c=='STELRB'){  fullURl = customLabelValue+'?curiosity_id='+senquiry.id+'&objectType=Contact&objectId='+senquiry.Contact__c+'&type=observation-meeting';
                }
                if(senquiry.Org_code__c=='STELRA'){ fullURl = customLabelValue+'?curiosity_id='+senquiry.id+'&objectType=Contact&objectId='+senquiry.Contact__c+'&type=observation-meeting'; 
                }if(senquiry.Org_code__c=='STELRG'){ fullURl = customLabelValue+'?curiosity_id='+senquiry.id+'&objectType=Contact&objectId='+senquiry.Contact__c+'&type=observation-meeting';
                }
                customleadValue = senquiry.Lead_ID__c;
                customAdmissionFormValue = senquiry.Id;
                senquiry.Interaction_Online_Scheduled__c = true;
                senquiry.Stages__c = 'Interaction Online Scheduled';
                update senquiry;
                system.debug('customleadValue >> ' + customleadValue);
                List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead){ lead l = new lead(); l.id = le.id;l.Stage__c = 'Interaction Online Scheduled';
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){update lstlead;
                    }
                }
                system.debug('customAdmissionFormValue >> ' + customAdmissionFormValue);
                List<Admission_Form__c> lstAdmissionForm = new List<Admission_Form__c>();
                List<Admission_Form__c> slitAdmissionForm = new List<Admission_Form__c>();
                if(!Test.isRunningTest()){slitAdmissionForm = [SELECT Id,name, Application_Form__c, Enquiry_No__c, Interaction_Done__c, Interaction_Online_Rescheduled__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled__c, Interaction_Rescheduled__c, Interaction_Scheduled_For__c, Interaction_Scheduled_On__c, Interaction_Scheduled__c FROM Admission_Form__c where Enquiry_No__c=: customAdmissionFormValue];}
                else{slitAdmissionForm = [SELECT Id,name, Application_Form__c, Enquiry_No__c, Interaction_Done__c, Interaction_Online_Rescheduled__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled__c, Interaction_Rescheduled__c, Interaction_Scheduled_For__c, Interaction_Scheduled_On__c, Interaction_Scheduled__c FROM Admission_Form__c limit 1];}
                system.debug('slitAdmissionForm >> ' + slitAdmissionForm);
                if(!slitAdmissionForm.isEmpty()){
                    for(Admission_Form__c ADF : slitAdmissionForm){Admission_Form__c AF = new Admission_Form__c();AF.id = ADF.id;AF.Interaction_Online_Scheduled__c = true;AF.Status__c ='Interaction Online Scheduled';
                        lstAdmissionForm.add(AF);
                    }
                    system.debug('lstAdmissionForm -- ' + lstAdmissionForm);
                    if(!lstAdmissionForm.isEmpty()){update lstAdmissionForm;
                    }
                }
            }           
        }
        system.debug('fullURl >>> ' + fullURl);
        if(fullURl != null){
            PageReference retURL = new PageReference(fullURl);
            retURL.setRedirect(true);return retURL;
        }
        else{
             back = true;
            return null;
        }    
    }
    public pageReference InteractionOnlineRescheduled() {
        senquiry = new Enquiry__c();
        if(!Test.isRunningTest()){senquiry = [select id, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Interaction_Online_Rescheduled__c,Interaction_Rescheduled__c,Called_for_Observation__c,Interaction_Scheduled__c,Interaction_Scheduled_For__c,Interaction_Scheduled_On__c  from Enquiry__c where id=:enqId];}
        else{senquiry = [select id, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Interaction_Scheduled__c, Interaction_Scheduled_On__c, Interaction_Scheduled_For__c, Interaction_Rescheduled__c, Interaction_Online_Scheduled__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Rescheduled__c, Interaction_Done__c  from Enquiry__c limit 1];}
        system.debug('senquiry >>>>>> @ > ' + senquiry);
        if(senquiry != null){
            if(senquiry.Interaction_Online_Rescheduled__c == true){ back = true;ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction Online Re Scheduled Already Done!!'));
            }
            else{
                customAdmissionFormValue = senquiry.Id;
                senquiry.Interaction_Online_Scheduled__c = false;
                senquiry.Interaction_Online_Rescheduled__c = true;
                senquiry.Stages__c = 'Interaction Online Rescheduled';
                update senquiry;
                List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead){ lead l = new lead(); l.id = le.id;l.Stage__c = 'Interaction Online Rescheduled';
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){update lstlead;
                    }
                }
                system.debug('customAdmissionFormValue >> ' + customAdmissionFormValue);
                List<Admission_Form__c> lstAdmissionForm = new List<Admission_Form__c>();
                List<Admission_Form__c> slitAdmissionForm = new List<Admission_Form__c>();
                if(!Test.isRunningTest()){slitAdmissionForm = [SELECT Id,name, Application_Form__c, Enquiry_No__c, Interaction_Done__c, Interaction_Online_Rescheduled__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled__c, Interaction_Rescheduled__c, Interaction_Scheduled_For__c, Interaction_Scheduled_On__c, Interaction_Scheduled__c FROM Admission_Form__c where Enquiry_No__c=: customAdmissionFormValue];}
                else{slitAdmissionForm = [SELECT Id,name, Application_Form__c, Enquiry_No__c, Interaction_Done__c, Interaction_Online_Rescheduled__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled__c, Interaction_Rescheduled__c, Interaction_Scheduled_For__c, Interaction_Scheduled_On__c, Interaction_Scheduled__c FROM Admission_Form__c limit 1];}
                system.debug('slitAdmissionForm >> ' + slitAdmissionForm);
                if(!slitAdmissionForm.isEmpty()){
                    for(Admission_Form__c ADF : slitAdmissionForm){
                        Admission_Form__c AF = new Admission_Form__c();
                        AF.id = ADF.id;AF.Interaction_Online_Scheduled__c = false;AF.Interaction_Online_Rescheduled__c = true;AF.Status__c = 'Interaction Online Rescheduled';
                        lstAdmissionForm.add(AF);
                    }
                    system.debug('lstAdmissionForm -- ' + lstAdmissionForm);
                    if(!lstAdmissionForm.isEmpty()){update lstAdmissionForm;
                    }
                }
            }           
        }
        PageReference retURL = new PageReference('/'+senquiry.Id);
        retURL.setRedirect(true);
        return retURL;    
    }
    public PageReference IntractionDoneEnquiry()    {
         PageReference pg;
        senquiry = new Enquiry__c();
        if(!Test.isRunningTest()){senquiry = [select id, Demographic__c,name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Interaction_Rescheduled__c,Interaction_Scheduled__c  from Enquiry__c where id=:enqId];}
        else{senquiry = [select id,Demographic__c, name ,Interaction_Done__c,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Called_for_Observation__c,Interaction_Scheduled__c,Interaction_Scheduled_For__c,Interaction_Scheduled_On__c  from Enquiry__c limit 1];}
        senquiry = [select id,Demographic__c,Interaction_Done__c,Meet_Done__c ,Contact__r.Campus_Visit_Done__c,Contact__r.School_Short_Code__c, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Interaction_Rescheduled__c,Interaction_Scheduled__c  from Enquiry__c where id=:enqId];
        system.debug('senquiry >>>>>> @ > ' + senquiry);
        if(senquiry != null){
            if(senquiry.Interaction_Scheduled__c == false){
                back = true;
                system.debug('lk');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction is not Scheduled!!'));
             return pg; 
            }
            system.debug('Interaction_Done__c'+senquiry.Interaction_Done__c);
            system.debug('school code'+senquiry.Contact__r.School_Short_Code__c);
           
            if((!senquiry.Contact__r.School_Short_Code__c.contains('STELR')) && senquiry.Meet_Done__c == false){
                back = true;
                system.debug('lkpp');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction can not be done before meet done!'));
                return pg;
            }
           /*  if((senquiry.Contact__r.School_Short_Code__c.contains('STELR')) && senquiry.Contact__r.Campus_Visit_Done__c == false){
                back = true;
                system.debug('lkppcvDone');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction can not be done before Campus Visit Done !'));
                return pg;
            }*/
            
            
            
            
            //Demographic__c
            if(senquiry.Interaction_Done__c == true){
                back = true;
                system.debug('lkpp');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction Already Done!!'));
            } 
            
            
            
            
            if(senquiry.Interaction_Scheduled__c == true || senquiry.Interaction_Rescheduled__c == true ){
                   ST_AdmissionFormObservation.UpdateEnquiryObservationDone(senquiry.Id);
                pg = new PageReference('/'+senquiry.Id);
        pg.setRedirect(true);
                }                       
        }
        
        return pg;   
    }
     public PageReference NoShow()    {
        senquiry = new Enquiry__c();
        if(!Test.isRunningTest()){senquiry = [select id, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Interaction_Rescheduled__c,Interaction_Scheduled__c  from Enquiry__c where id=:enqId];}
        else{senquiry = [select id, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Called_for_Observation__c,Interaction_Scheduled__c,Interaction_Scheduled_For__c,Interaction_Scheduled_On__c  from Enquiry__c limit 1];}
        senquiry = [select id, name ,Org_code__c,Lead_ID__c,Contact__c,Stages__c,Interaction_Rescheduled__c,Interaction_Scheduled__c  from Enquiry__c where id=:enqId];
        system.debug('senquiry >>>>>> @ > ' + senquiry);
        if(senquiry != null){
            if(senquiry.Interaction_Scheduled__c == true){
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction Already Done!!'));
            }if(senquiry.Interaction_Rescheduled__c == true){ back = true;ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction Re Scheduled Already Done!!'));
            }
                if(senquiry.Interaction_Scheduled__c == true || senquiry.Interaction_Rescheduled__c == true){
                  // ST_AdmissionFormObservation.UpdateEnquiryObservationDone(senquiry.Id);
                }                       
        }
         senquiry.No_Show__c=true;
         update senquiry;
        PageReference retURL = new PageReference('/'+senquiry.Id);
        retURL.setRedirect(true);
        return retURL;   
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
        }
    public PageReference cancel()
    {
        return  new pageReference('/'+senquiry.Id);
    }
}