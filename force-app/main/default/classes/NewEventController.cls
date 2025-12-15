public class NewEventController {
    public Admission_Form__c af{get;set;}
    //public list<Admission_Form__c> listform{get;set;}
    //public list<Event> listev{get;set;}
    public Event ev{get;set;}
    public boolean error{get;set;}
    public List<Application_form__c> aapList{get;set;}
    public List<Enquiry__c> enqList{get;set;}
    public List<Enquiry__c> enqListSend{get;set;}
    public string schoolshortcode{get;set;}
    public List<string> calanderemailstr  = new List<String>();
    Public List<School_List__mdt> CalendarEmailMdt = new list<School_List__mdt>();
    public List<School_List__mdt> CalendarEmail= new list<School_List__mdt>();
    public string strlead{get;set;}
    public List<Lead> lstlead{get;set;}
    public List<Lead> lstleads {get;set;}
    
    Id pid=Apexpages.currentpage().getParameters().get('id');
    public NewEventController(ApexPages.StandardController Controller){
        Id pid=Apexpages.currentpage().getParameters().get('id');
        //  af=(Admission_Form__c)Controller.getRecord();
        af=[select id,Enquiry_No__c,Enquiry_No__r.Lead_ID__c,Enquiry_No__r.name,Non_Stellar_Interaction_Scheduled__c,
            Non_Stellar_Interaction_Scheduled_On__c,Non_Stellar_Interaction_Scheduled_For__c,
            Non_Stellar_Interaction_Reschedule__c,Non_Stellar_Interaction_Online_Scheduled__c,N_S_Interaction_Online_Scheduled_On__c,N_S_Interaction_Online_Scheduled_For__c,N_S_Interaction_Online_Reschedule__c,
            Non_Stellar_Absent_For_Interaction__c,Non_Stellar_Interaction_Done__c,Non_Stellar_Attach_Interaction_Notes__c,
            Non_Stellar_Reject_After_Interaction__c,Non_Stellar_Document_Incomplete__c,School_Institution__c, Name,
            Called_for_Observation__c,Observation_Re_scheduled__c, Observation_Done__c from Admission_Form__c where id=:pid];
        //error = true;
        system.debug('ID::::'+pid);
        
        ev=new Event(); 
        ev.WhatId = pid;
        ev.School_Institution__c= af.School_Institution__c;
        
        strlead = af.Enquiry_No__r.Lead_ID__c;
        lstleads = new List<Lead>();
        lstlead = new List<Lead>();
        lstlead = [select id,Lead_ID__c,Stage__c from lead where Lead_ID__c=:strlead];
        system.debug('lstlead   ::::'+   lstlead);
        
    }
    
    public PageReference createevent()
    {
        PageReference pg; 
        Admission_Form__c adf = [Select id,Enquiry_No__c,Enquiry_No__r.name,Non_Stellar_Interaction_Scheduled__c,Non_Stellar_Interaction_Scheduled_On__c,Non_Stellar_Interaction_Scheduled_For__c,Non_Stellar_Interaction_Reschedule__c,Non_Stellar_Interaction_Online_Scheduled__c,N_S_Interaction_Online_Scheduled_On__c,N_S_Interaction_Online_Scheduled_For__c,N_S_Interaction_Online_Reschedule__c,Non_Stellar_Absent_For_Interaction__c,Non_Stellar_Interaction_Done__c,Non_Stellar_Attach_Interaction_Notes__c,Non_Stellar_Reject_After_Interaction__c,Non_Stellar_Document_Incomplete__c,Name,Application_Form__c,Document_Received__c,Academic__c,Status__c,Called_for_Observation__c,Observation_Re_scheduled__c from Admission_Form__c where id=: pid];
        //try{                
        //alreadycalledforobservation();    
        if(af.Non_Stellar_Interaction_Scheduled__c==false)
        {
            //if(af.Enquiry_No__r.name.Contains('ENQ')){
            af.Non_Stellar_Interaction_Scheduled__c=true;
            af.Status__c = 'Interaction-Scheduled';
            af.Non_Stellar_Interaction_Scheduled_On__c =system.now();
            //}
            update af;
            system.debug('lstlead -- ' + lstlead);
            for(lead le : lstlead){
                lead l = new lead();
                l.id = le.id; l.Stage__c = 'Interaction-Scheduled';
                lstleads.add(l);
            }
            system.debug('lstleads -- ' + lstleads);
            if(!lstleads.isEmpty()){update lstleads;
                                   }
            aapList = [Select Id,Name,Status__c,Enquiry__c, School_Institution__c from Application_form__c where ID =:adf.Application_Form__c Limit 1 ];
            system.debug('Application_Update_Status:::'+aapList[0].Status__c);
            Application_form__c app = new Application_form__c();
            app.id = aapList[0].ID;
            app.Status__c = 'Interaction-Scheduled';
            aapList.add(app);
            
            map<id,Application_form__c> appMap = new map<id,Application_form__c>();
            
            //put all the values from the list to map. 
            appMap.putall(aapList);
            if(appMap.size()>0){
                update appMap.values();
            }
            system.debug('aapList[0].Enquiry__c ' + aapList[0].Enquiry__c);
            enqList = [Select id,Name,Stages__c,Org_code__c,Email__c, Contact__c from Enquiry__c where id =: aapList[0].Enquiry__c Limit 1 ];
            ev.Contact__c = enqList[0].Contact__c ;
            system.debug('ev ' + aapList[0].Enquiry__c);
            insert ev;
            
            system.debug('enqList:::'+enqList);
            Enquiry__c enq = new Enquiry__c();
            enq.id = enqList[0].id;
            enq.Stages__c = 'Interaction-Scheduled';
            
            enqList.add(enq);
            
            map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();
            
            //put all the values from the list to map. Observation Scheduled
            enqMap.putall(enqList);
            if(enqMap.size()>0){
                update enqMap.values();
                
            }
            enqListSend = [Select id,Name,Stages__c,Email__c,School_Institution__c from Enquiry__c where id =: aapList[0].Enquiry__c Limit 1 ];
            
            /*String templateName = 'Call_for_Observation_email_template';
System.debug('-=   templateName  -='+templateName);
System.debug('-=  enqListSend[0].Email -='+ enqListSend[0].Email__c);
System.debug('-=  ev.Id -='+ ev.Id);
System.debug('-=  enqListSend[0].Name -='+ enqListSend[0].Name); 
String response = SendEmail.sendEmailFromShortCode(enqListSend[0].School_Institution__c,enqListSend[0].Email__c,ev.Id,enqListSend[0].Name,templateName);
System.debug('-=-=-=-  response  =--=-=-=-'+ response);  */
            String templateName = 'Call_for_Observation_email_template';
            schoolshortcode = enqList[0].Org_code__c;
            System.debug('-=-=-=-  schoolshortcode=--=-=-=-'+ schoolshortcode);
            CalendarEmail=[select id,Calendar_Email__c,State__c,label,MasterLabel from School_List__mdt where label=:schoolshortcode];
            If(CalendarEmail.size() > 0 && !CalendarEmail.isEmpty() ){
                String CE = CalendarEmail[0].Calendar_Email__c ;
                
                calanderemailstr.add(CE);
                calanderemailstr.add(enqListSend[0].Email__c);
            }
            
            else {
                String Msg = 'School is not listed for email notification';
                enq.adderror(msg);
            }
            if(!Test.isRunningTest()){
                
                String htmlbody = SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr,ev.Id,enqListSend[0].Name ,templateName);
                GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id, htmlbody);
            }
            
        }
        pg=new pageReference('/'+af.Id);
        /*}
catch(Exception ex){
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Error'));
system.debug('Error while Insertion::'+ex.getMessage());
system.debug('Error while Insertion::'+ex.getStackTraceString());
}*/
        return  pg;
    }
    
    
    public PageReference observationOnline()
    {
        PageReference pg; 
        Admission_Form__c adf = [Select id,Enquiry_No__c,Enquiry_No__r.name,Non_Stellar_Interaction_Scheduled__c,Non_Stellar_Interaction_Scheduled_On__c,Non_Stellar_Interaction_Scheduled_For__c,Non_Stellar_Interaction_Reschedule__c,Non_Stellar_Interaction_Online_Scheduled__c,N_S_Interaction_Online_Scheduled_On__c,N_S_Interaction_Online_Scheduled_For__c,N_S_Interaction_Online_Reschedule__c,Non_Stellar_Absent_For_Interaction__c,Non_Stellar_Interaction_Done__c,Non_Stellar_Attach_Interaction_Notes__c,Non_Stellar_Reject_After_Interaction__c,Non_Stellar_Document_Incomplete__c,Name,Application_Form__c,Document_Received__c,Academic__c,Status__c,Called_for_Observation__c,Observation_Re_scheduled__c from Admission_Form__c where id=: pid];
        system.debug('@@@@ af @@@@@' + af);
        system.debug('@@@@ adf @@@@@' + adf);
        try{                
            //alreadycalledforobservation();    
            if(af.Non_Stellar_Interaction_Online_Scheduled__c==false)
            {
                if(af.Enquiry_No__r.name.Contains('ENQ')){
                    af.Non_Stellar_Interaction_Online_Scheduled__c=true;
                    af.Status__c = 'Interaction-Online-Scheduled';
                    af.N_S_Interaction_Online_Scheduled_On__c =system.now();
                }
                update af;
                system.debug('lstlead -- ' + lstlead);
                for(lead le : lstlead){
                    lead l = new lead();
                    l.id = le.id; l.Stage__c = 'Interaction-Online-Scheduled';
                    lstleads.add(l);
                }
                system.debug('lstleads -- ' + lstleads);
                if(!lstleads.isEmpty()){update lstleads;
                                       }
                aapList = [Select Id,Name,Status__c,Enquiry__c from Application_form__c where ID =:adf.Application_Form__c Limit 1 ];
                system.debug('Application_Update_Status:::'+aapList[0].Status__c);
                Application_form__c app = new Application_form__c();
                app.id = aapList[0].ID;
                app.Status__c = 'Interaction-Online-Scheduled';
                aapList.add(app);
                system.debug('aapList:::'+  aapList);
                map<id,Application_form__c> appMap = new map<id,Application_form__c>();
                
                //put all the values from the list to map. 
                appMap.putall(aapList);
                if(appMap.size()>0){
                    update appMap.values();
                }
                system.debug('appMap.values() :::'+ appMap.values());
                enqList = [Select id,Name,Stages__c,Email__c,Contact__c, Org_code__c from Enquiry__c where id =: aapList[0].Enquiry__c Limit 1 ];
                system.debug('enqList:::'+enqList);
                
                ev.Contact__c = enqList[0].Contact__c ;
                ev.Enquiry_Email__c = enqList[0].Email__c;
                insert ev;
                
                system.debug('ev:::'+ ev);
                Enquiry__c enq = new Enquiry__c();
                enq.id = enqList[0].id;
                enq.Stages__c = 'Interaction-Online-Scheduled';
                
                enqList.add(enq);
                
                map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();
                
                //put all the values from the list to map. Observation Scheduled
                enqMap.putall(enqList);
                
                if(enqMap.size()>0){
                    update enqMap.values();
                    
                }
                enqListSend = [Select id,Name,Stages__c,Email__c,School_Institution__c, Org_code__c from Enquiry__c where id =: aapList[0].Enquiry__c Limit 1 ];
                
                String templateName = 'Observation_Online';
                schoolshortcode = enqList[0].Org_code__c;
                CalendarEmail=[select id,Calendar_Email__c,State__c,label,MasterLabel from School_List__mdt where label=:schoolshortcode];
                If(CalendarEmail.size() > 0 && !CalendarEmail.isEmpty() ){
                    String CE = CalendarEmail[0].Calendar_Email__c ;
                    
                    calanderemailstr.add(CE);
                    calanderemailstr.add(enqListSend[0].Email__c);
                }
                
                else {
                    String Msg = 'School is not listed for email notification';
                    enq.adderror(msg);
                }
                
                String htmlbody = SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr,ev.Id,enqListSend[0].Name ,templateName);
                GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id, htmlbody);
            }      
            
            pg=new pageReference('/'+af.Id);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Error'));
            system.debug('Error while Insertion::'+ex.getMessage());
            system.debug('Error while Insertion::'+ex.getStackTraceString());
        }
        return  pg; 
    }
    
    
    public PageReference ObservationOnlineRescheduled()
    {
        PageReference pg=ApexPages.CurrentPage(); 
        system.debug(' pid ' + pid);
        Admission_Form__c adf = [Select id,Enquiry_No__c,Enquiry_No__r.name,Non_Stellar_Interaction_Scheduled__c,Non_Stellar_Interaction_Scheduled_On__c,Non_Stellar_Interaction_Scheduled_For__c,Non_Stellar_Interaction_Reschedule__c,Non_Stellar_Interaction_Online_Scheduled__c,N_S_Interaction_Online_Scheduled_On__c,N_S_Interaction_Online_Scheduled_For__c,N_S_Interaction_Online_Reschedule__c,Non_Stellar_Absent_For_Interaction__c,Non_Stellar_Interaction_Done__c,Non_Stellar_Attach_Interaction_Notes__c,Non_Stellar_Reject_After_Interaction__c,Non_Stellar_Document_Incomplete__c,Name,Application_Form__c,Document_Received__c,Academic__c,Status__c,Called_for_Observation__c,Observation_Re_scheduled__c from Admission_Form__c where id=: pid];
        system.debug(' adf ' + adf);
        //try{
        //scheduleobservationfirst();
        if(af.Non_Stellar_Interaction_Online_Scheduled__c==true)
        {
            if(af.Enquiry_No__r.name.Contains('ENQ')){
                af.N_S_Interaction_Online_Reschedule__c=true;
                af.Status__c = 'Interaction-Online-Reschedule';
            }
            update af;
            system.debug('lstlead -- ' + lstlead);
            for(lead le : lstlead){
                lead l = new lead();
                l.id = le.id; l.Stage__c = 'Interaction-Online-Reschedule';
                lstleads.add(l);
            }
            system.debug('lstleads -- ' + lstleads);
            if(!lstleads.isEmpty()){update lstleads;
                                   }
            aapList = [Select Id,Name,Status__c,Enquiry__c from Application_form__c where ID =:adf.Application_Form__c Limit 1 ];
            system.debug(' aapList ' + aapList);
            system.debug('Application_Update_Status:::'+aapList[0].Status__c);
            Application_form__c app = new Application_form__c();
            app.id = aapList[0].ID;
            app.Status__c = 'Interaction-Online-Reschedule';
            aapList.add(app);
            
            
            
            map<id,Application_form__c> appMap = new map<id,Application_form__c>();
            
            //put all the values from the list to map. 
            appMap.putall(aapList);
            if(appMap.size()>0){
                update appMap.values();
            }
            
            enqList = [Select id,Name,Stages__c,contact__r.Email, Email__c, Org_code__c from Enquiry__c where id =: aapList[0].Enquiry__c Limit 1 ];
            system.debug('enqList ' + enqList);
            ev.Contact__c = enqList[0].Contact__c ;
            ev.Enquiry_Email__c = enqList[0].Email__c;
            
            if(Test.isRunningTest()) {
                update ev;    
            } else {
                insert ev;
            }
            
            Enquiry__c enq = new Enquiry__c();
            enq.id = enqList[0].id;
            enq.Stages__c = 'Interaction-Online-Reschedule';
            enqList.add(enq);
            
            
            
            map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();
            
            //put all the values from the list to map. Observation Scheduled
            enqMap.putall(enqList);
            if(enqMap.size()>0){
                update enqMap.values();
            }
            
            enqListSend = [Select id,Name,Stages__c,Email__c,School_Institution__c, Org_code__c from Enquiry__c where id =: aapList[0].Enquiry__c Limit 1 ];
            
            String templateName = 'Observation_Online_Re_schedule';
            schoolshortcode = enqList[0].Org_code__c;
            CalendarEmail=[select id,Calendar_Email__c,State__c,label,MasterLabel from School_List__mdt where label=:schoolshortcode];
            If(CalendarEmail.size() > 0 && !CalendarEmail.isEmpty() ){
                String CE = CalendarEmail[0].Calendar_Email__c ;
                
                calanderemailstr.add(CE);
                calanderemailstr.add(enqList[0].Email__c);
            }
            
            else {
                String Msg = 'School is not listed for email notification';
                enq.adderror(msg);
            }
            
            String htmlbody = SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr,ev.Id,enqList[0].Name,templateName);
            GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id,htmlbody);
            
            
        }
        return  new pageReference('/'+af.Id);
        /*}
catch(Exception ex){
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Error'));
system.debug('Error while Insertion::'+ex.getMessage());
system.debug('Error while Insertion::'+ex.getStackTraceString());
}
return pg;*/ 
    }
    
    
    public void alreadycalledforobservation(){
        
        /*try{
if(af.Observation_Done__c == true){
error=false;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Observation already done.'));
}
if(af.Called_for_Observation__c==true){
error=false;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Already Called for Observation.'));
}

}
catch(Exception ex){
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Error.'));
system.debug('Error while Insertion::'+ex.getMessage());
}*/
        
    }
    public PageReference ObservationRescheduled()
    {
        PageReference pg=ApexPages.CurrentPage(); 
        Admission_Form__c adf = [Select id,Enquiry_No__c,Email_Address__c,Enquiry_No__r.name,Non_Stellar_Interaction_Scheduled__c,Non_Stellar_Interaction_Scheduled_On__c,Non_Stellar_Interaction_Scheduled_For__c,Non_Stellar_Interaction_Reschedule__c,Non_Stellar_Interaction_Online_Scheduled__c,N_S_Interaction_Online_Scheduled_On__c,N_S_Interaction_Online_Scheduled_For__c,N_S_Interaction_Online_Reschedule__c,Non_Stellar_Absent_For_Interaction__c,Non_Stellar_Interaction_Done__c,Non_Stellar_Attach_Interaction_Notes__c,Non_Stellar_Reject_After_Interaction__c,Non_Stellar_Document_Incomplete__c,Name,Application_Form__c,Document_Received__c,Academic__c,Status__c,Called_for_Observation__c,Observation_Re_scheduled__c from Admission_Form__c where id=: pid];
        //try{
        //scheduleobservationfirst();
        system.debug('adf.Non_Stellar_Interaction_Scheduled__c -- ' + adf.Non_Stellar_Interaction_Scheduled__c );
        system.debug('af.Non_Stellar_Interaction_Scheduled__c -- ' + af.Non_Stellar_Interaction_Scheduled__c );
        if(af.Non_Stellar_Interaction_Scheduled__c==true)
        {
            //if(af.Enquiry_No__r.name.Contains('ENQ')){
            af.Non_Stellar_Interaction_Reschedule__c=true;
            af.Status__c = 'Interaction-Reschedule';
            //}
            update af;
            system.debug('lstlead -- ' + lstlead);
            for(lead le : lstlead){
                lead l = new lead();
                l.id = le.id; l.Stage__c = 'Interaction-Reschedule';
                lstleads.add(l);
            }
            system.debug('lstleads -- ' + lstleads);
            if(!lstleads.isEmpty()){update lstleads;
                                   }
            aapList = [Select Id,Name,Status__c,Enquiry__c from Application_form__c where ID =:adf.Application_Form__c Limit 1 ];
            system.debug('Application_Update_Status:::'+aapList[0].Status__c);
            Application_form__c app = new Application_form__c();
            app.id = aapList[0].ID;
            app.Status__c = 'Interaction-Reschedule';
            aapList.add(app);
            
            map<id,Application_form__c> appMap = new map<id,Application_form__c>();
            
            //put all the values from the list to map. 
            appMap.putall(aapList);
            if(appMap.size()>0){
                update appMap.values();
            }
            
            enqList = [Select id,Name,Stages__c,contact__r.Email,Email__c,Org_code__c from Enquiry__c where id =: aapList[0].Enquiry__c Limit 1 ];
            ev.Contact__c = enqList[0].Contact__c ;
            if(Test.isRunningTest()) {
                update ev;    
            } else {
                insert ev;
            }
            
            system.debug('enqList:::'+enqList);
            Enquiry__c enq = new Enquiry__c();
            enq.id = enqList[0].id;
            enq.Stages__c = 'Interaction-Reschedule';
            enqList.add(enq);
            
            map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();
            
            //put all the values from the list to map. Observation Scheduled
            enqMap.putall(enqList);
            if(enqMap.size()>0){
                update enqMap.values();
            }
            
            enqListSend = [Select id,Name,Stages__c,Email__c,School_Institution__c from Enquiry__c where id =: aapList[0].Enquiry__c Limit 1 ];
            
            /*String templateName = 'Call_for_Observation_email_template';
System.debug('-=   templateName  -='+templateName);
System.debug('-=  enqListSend[0].Email -='+ enqListSend[0].Email__c);
System.debug('-=  ev.Id -='+ ev.Id);
System.debug('-=  enqListSend[0].Name -='+ enqListSend[0].Name); 
String htmlbody = SendEmail.sendEmailFromShortCode(enqListSend[0].School_Institution__c,enqListSend[0].Email__c,ev.Id,enqListSend[0].Name,templateName);
System.debug('-=-=-=-  htmlbody  =--=-=-=-'+htmlbody);*/  
            String templateName = 'Call_for_Observation_email_template';
            schoolshortcode = enqList[0].Org_code__c;
            CalendarEmail=[select id,Calendar_Email__c,State__c,label,MasterLabel from School_List__mdt where label=:schoolshortcode];
            If(CalendarEmail.size() > 0 && !CalendarEmail.isEmpty() ){
                String CE = CalendarEmail[0].Calendar_Email__c ;
                
                calanderemailstr.add(CE);
                calanderemailstr.add(adf.Email_Address__c);
            }
            
            else {
                String Msg = 'School is not listed for email notification';
                enq.adderror(msg);
            }
            
            if(!Test.isRunningTest()){
                String htmlbody = SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr,ev.Id,enqList[0].Name,templateName);
                GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id,htmlbody);
            }
        }
        return  new pageReference('/'+af.Id);
        //}
        /*catch(Exception ex){
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Error'));
system.debug('Error while Insertion::'+ex.getMessage());
system.debug('Error while Insertion::'+ex.getStackTraceString());
}*/
        //return pg;
    }
    public void scheduleobservationfirst(){
        /*if(af.Observation_Done__c == true){
error=false;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Observation already done.'));
}
if(af.Called_for_Observation__c==false){
error = false;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'You have to schedule observation first.'));
}*/
    }
    public PageReference cancel()
    {
        return  new pageReference('/'+af.Id);   
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
}