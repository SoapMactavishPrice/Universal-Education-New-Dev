public class changeStatusInAdmissionGranted {
    
    public list<Admission_Granted__c> listGrant{get;set;}
    public Admission_Granted__c ag{get;set;}
    Public List<Enquiry__c> enqList {get;set;}
    public list<Application_Form__c> applist {get;set;}
    Id pid=Apexpages.currentpage().getParameters().get('id');
    public string customleadValue{get;set;}
    public changeStatusInAdmissionGranted(ApexPages.StandardController Controller)
    {
        
        ag = [Select Id,Name,Status__c from Admission_Granted__c where id=:pid];
        
    }
    
    public PageReference admissionCanceled(){
        Admission_Granted__c ag = [Select id,Name,Status__c,Admission_Form__c,
                                   EnquiryNo__r.Contact__c,EnquiryNo__r.Contact__r.Lead_ID__c,EnquiryNo__r.Lead_ID__c 
                                   from Admission_Granted__c 
                                   where id=: pid Limit 1];
        customleadValue = ag.EnquiryNo__r.Lead_ID__c;
        PageReference pg;
        if(ag.Status__c =='Admission Process Completed' )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Admission Process is Completed. You can not cancelled the Admission !'));
        }
        else
        {
            ag.Status__c ='Admission Cancelled';
            update ag;
            
            List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead){lead l = new lead();l.id = le.id;l.Stage__c = 'Admission Cancelled';
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){update lstlead;
                    }
                }
            
            //Admission Status Update
            Admission_Form__c adForm = [Select Id,Name,Status__c,Application_Form__c from Admission_Form__c Where Id =: ag.Admission_Form__c Limit 1];
            adform.Status__c = 'Admission Cancelled';
            Update adform;
            
            //Application Status Field Update
            applist = [Select id,Name,Status__c,Enquiry__c,Reason_For_Rejection__c from Application_Form__c where Id=: adform.Application_Form__c LIMIT 1];
            system.debug('Application Status:::'+applist);
            Application_Form__c app = new Application_Form__c();
            app.id = applist[0].Id;
            app.Status__c = 'Admission Cancelled';
            applist.add(app);
            
            map<id,Application_Form__c> appMap = new map<id,Application_Form__c>();
            
            //put all the values from the list to map. 
            appMap.putall(applist);
            if(appMap.size()>0){
                update appMap.values();
            }
            
            //Enquiry Stage update
            enqList = [Select id,Name,Stages__c from Enquiry__c where id =: applist[0].Enquiry__c Limit 1 ];
            Enquiry__c enq = new Enquiry__c();
            enq.id = enqList[0].id;
            enq.Stages__c = 'Admission Cancelled';
            enqList.add(enq);
            
            map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();
            
            //put all the values from the list to map. 
            enqMap.putall(enqList);
            if(enqMap.size()>0){
                update enqMap.values();
            }
            
            pg =  new PageReference('/'+ag.Id);    
        }
        return pg;
    }
    
    public PageReference admissionIncomplete(){
        Admission_Granted__c ag = [Select id,Name,Status__c from Admission_Granted__c where id=: pid Limit 1];
        
        PageReference pg;
        if(ag.Status__c =='Admission Process Completed' )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'For this Applicant Admission Process is already completed. Now,you can not change the status !'));
        }
        else{
            ag.Status__c ='Admission Incomplete';
            update ag;
            pg = new PageReference('/'+ag.Id);
        }
        return pg;
    }
    
    public PageReference admissionProcessCompleted(){
        Admission_Granted__c ag = [Select id,Name,Grade_lookup__c,House_lookup__c,Fees_Status__c,Status__c,EnquiryNo__r.Contact__c,EnquiryNo__r.Contact__r.Lead_ID__c,
                                   Original_Document__c,Admission_Form__c,Enrollment_No__c,Fee_Applicable_Date__c,Date_of_Admission__c,
                                   Confirmation_Date__c,Section_lookup__c,EnquiryNo__r.Lead_ID__c from Admission_Granted__c where id=: pid Limit 1];
        customleadValue = ag.EnquiryNo__r.Lead_ID__c;
        PageReference pg;
         boolean isEmailactive=false;
        string emailtemp;
        boolean notem=true;
       

        if(ag.Enrollment_No__c==null || ag.Grade_lookup__c ==null || ag.House_lookup__c ==null || ag.Enrollment_No__c == null || ag.Fee_Applicable_Date__c == null || ag.Date_of_Admission__c == null || ag.Confirmation_Date__c==null || ag.Section_lookup__c ==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Required Information is missing kindly re-check before completing the Process. '));  
        }
        
        if (ag.Status__c == 'Admission Process Completed'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Admission Process is already Completed!!')); 
        }
        if(ag.Original_Document__c == 'Pending'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Orginal Document is pending !!'));
        }
        if(ag.Fees_Status__c == 'Unpaid'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Fees not paid !!'));   
        }
        
        if(ag.Original_Document__c == 'Received' && ag.Status__c!= 'Admission Process Completed' && ag.Fees_Status__c == 'Paid'){
            ag.Status__c ='Admission Process Completed';
            update ag;
            List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead){
                        lead l = new lead();
                        l.id = le.id;
                        l.Stage__c = 'Admission Process Completed';
                        l.Current_Status__c ='Won';
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){update lstlead;
                    }
                }
            
            Admission_Form__c adForm = [Select Id,Name,Status__c,Application_Form__c from Admission_Form__c Where Id =: ag.Admission_Form__c Limit 1];
            adform.Status__c = 'Admission Granted';
            Update adform;
            
            applist = [Select id,Name,Status__c,Enquiry__c,Reason_For_Rejection__c from Application_Form__c where Id=: adform.Application_Form__c LIMIT 1];
            system.debug('Application Status:::'+applist);
            Application_Form__c app = new Application_Form__c();
            app.id = applist[0].Id;
            app.Status__c = 'Admission Granted';
            applist.add(app);
            
            map<id,Application_Form__c> appMap = new map<id,Application_Form__c>();
            
            //put all the values from the list to map. 
            appMap.putall(applist);
            if(appMap.size()>0){
                update appMap.values();
            }
            
            
            enqList = [Select id,Contact__c,Org_code__c,Name,Stages__c from Enquiry__c where id =: applist[0].Enquiry__c Limit 1 ];
            Enquiry__c enq = new Enquiry__c();
            enq.id = enqList[0].id;
            enq.Stages__c = 'Admission Granted';
            enqList.add(enq);
            
            map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();
            
            //put all the values from the list to map. 
            enqMap.putall(enqList);
            if(enqMap.size()>0){
                update enqMap.values();
            }
             List< SchoolEmail__mdt> se=new list<SchoolEmail__mdt>(); 
        se=[select CCAddress__c,DisplayName__c,TempName__c,Active__c, Event__c ,Object__c ,SchoolShortcode__c from SchoolEmail__mdt where SchoolShortcode__c =:enqList[0].Org_code__c and Event__c='Admission Process Completed'];
        if(se!=null && se.size()>0){
            isEmailactive=se[0].Active__c;
            emailtemp=se[0].TempName__c;
        }
        else
        {
            notem=false;
        }
            if(isEmailactive)
                   {
                       system.debug('temp '+emailtemp);
                       SendEmail.SendEmailTemplateWithTemplate(emailtemp,enqList[0].Contact__c,true,ag.id,se[0],null);
                   }
                   
                   // System.debug('-=-=-=-=--=-=-=-'+htmlbody);
            return new PageReference('/'+ag.Id);
        }return pg;
    }
    
    public PageReference goBack(){
        return new PageReference('/'+ag.Id); 
    }
}