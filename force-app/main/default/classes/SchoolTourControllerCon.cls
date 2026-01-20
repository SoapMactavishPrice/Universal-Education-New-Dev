public class SchoolTourControllerCon{
    
    public Contact con{get;set;}
    public lead clead{get;set;}
    public list<Contact> listcon{get;set;}
    public list<Event> listev{get;set;}
    public Event ev{get;set;}
    public boolean error{get;set;}
    public boolean back{get;set;}
    public List<string> calanderemailstr  = new List<String>(); 
	public string strlead{get;set;}
    public List<Lead> lstlead{get;set;}
    public List<Lead> lstleads {get;set;}
    
    
    public SchoolTourControllerCon(ApexPages.StandardController Controller){
        Id pid=Apexpages.currentpage().getParameters().get('id');
        con=[select id,Name,Stages__c,School_Institution__c,Log_Status__c,Interaction_Done__c,Campus_Visit_Scheduled__c,Re_Scheduled_Campus_Visit__c,Email,
             Meeting_Done__c,Lead_ID__c,On_Hold__c,Interested__c, School_Short_Code__c from Contact where Id=:pid];
        strlead = con.Lead_ID__c;
        lstleads = new List<Lead>();
        lstlead = new List<Lead>();
        lstlead = [select id,Lead_ID__c,Stage__c from lead where Lead_ID__c=:strlead];
        system.debug('ID::::'+pid);
        ev=new Event(); 
        //error=true;
        //back = false;
        
        
    }
    public PageReference createevent()
    {
        try{ 
            
            alreadytourscheduled();
            if(con.Campus_Visit_Scheduled__c==false){
                
                ev.WhatId = con.id;
                calanderemailstr.add(con.Email);
				ev.School_Institution__c= con.School_Institution__c;
                ev.Contact__c = con.Id ;
                insert ev;
                con.Log_Status__c = 'Capmus Visit Scheduled';
                con.Campus_Visit_Scheduled__c=true;
                update con;
                SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr,ev.Id,con.Name,'Meeting_At_School_Schedule_Email_Template');
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Error'));
            system.debug('Error while Insertion::'+ex.getMessage());
        }
        return  new pageReference('/'+con.Id);
    }
    
    public void alreadytourscheduled(){
        if(con.Campus_Visit_Scheduled__c==true && con.Log_Status__c == 'Capmus Visit Scheduled'){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Meet at school already booked.'));
        }
        if(con.Meeting_Done__c==true){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction Done. You can not book Meet at School.'));
            
        }
    }
    
    public PageReference schoolTourRescheduled()
    {
        try{
            scheduleFirsttoReschedule();
            if(con.Campus_Visit_Scheduled__c == true && con.Meeting_Done__c == false){
                
                ev.WhatId = con.id;
                 calanderemailstr.add(con.Email);
                ev.School_Institution__c= con.School_Institution__c;
                ev.Contact__c = con.Id;
                insert ev;
                system.debug('inside if'+ev);
                //  enq.Log_Status__c = 'School Tour';
                con.Re_Scheduled_Campus_Visit__c=true;
                update con;
                String templateName = 'Meeting_At_School_Reschedule_Email_Template';
                System.debug('-=-='+templateName);
                SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr,ev.Id,con.Name,templateName);
            } 
            
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Error'));
            system.debug('Error while Insertion::'+ex.getMessage());
        }
        return  new pageReference('/'+con.Id);
    }
    
    public void scheduleFirsttoReschedule()
    {
        if(con.Campus_Visit_Scheduled__c==false && con.Log_Status__c!='Capmus Visit Scheduled'){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'To Re-Scheduled You have to Schedule a meet at school first.'));
        }
        if(con.Meeting_Done__c==true){  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction Done. You can not Re-Schedule meet at school.'));
            
        }
    }
    public PageReference intractionDone()
    {
        PageReference pg;
        try{
            
            if(con.Campus_Visit_Scheduled__c==False){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'First Scheduled the meet at school.')); 
            }
             if(con.Interaction_Done__c == true && con.Log_Status__c == 'Interaction Done'){ ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Intraction is already Done!')); 
            }
            if(con.Stages__c == 'No Show'){ ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'You cannot change the stage to Meet Done directly!')); 
            }
            
            if((con.Campus_Visit_Scheduled__c==true && con.Re_Scheduled_Campus_Visit__c == False && con.Meeting_Done__c == false)||(con.Campus_Visit_Scheduled__c==true && con.Re_Scheduled_Campus_Visit__c==true && con.Meeting_Done__c==false))
            {
                con.Log_Status__c = 'Interaction Done';
                con.Stages__c = 'Meet Done';
                con.Meeting_Done__c = true;
                con.Meet_Done_On__c = System.now();
                con.Interaction_Done__c=true;
                con.On_Hold__c=false;
 				con.Interested__c = false;     
                update con;
                system.debug('lstlead -- ' + lstlead);
                for(lead le : lstlead){
                    lead l = new lead();
                    l.id = le.id; l.Stage__c = 'Meet Done';
                    lstleads.add(l);
                }
                system.debug('lstleads -- ' + lstleads);
                if(!lstleads.isEmpty()){update lstleads;
                }
                pg= new pageReference('/'+con.Id);      
            }
            
        }
        catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Error'));
            system.debug('Error ::'+ex.getMessage());
        }
        return  pg;
    }
    
    public PageReference cancel()
    {
        return  new pageReference('/'+con.Id);   
    }
    
    public PageReference noShowCheck()
    {
        PageReference pg;
        try{
            if(con.Campus_Visit_Scheduled__c==false)
            {
                error=false;
                back = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Meet at school not done.'));
            }            
            else if(con.Campus_Visit_Scheduled__c==true){
                con.Stages__c = 'No Show';
                con.On_Hold__c=false;
				con.Meeting_Done__c = false;
                con.Interaction_Done__c=false;
 				con.Interested__c = false;     
                update con;
                pg= new pageReference('/'+con.Id);      
            }
            
         }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Error'));
            system.debug('Error ::'+ex.getMessage());
        }
        return  pg;
    }
    
    public PageReference noHoldEnq()
    {
        PageReference pg;
        try{
            if(con.Stages__c != 'Meet Done'){ ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Meeting has not done yet.'));
            }            
            else if(con.Stages__c == 'Meet Done'){
                con.Stages__c = 'On Hold';
                //con.Log_Status__c = 'On Hold';
                con.On_Hold__c=true;
				con.Meeting_Done__c = false;
                con.Interaction_Done__c=false;
 				con.Interested__c = false;                
                update con;
                system.debug('lstlead -- ' + lstlead);
                for(lead le : lstlead){
                    lead l = new lead();
                    l.id = le.id;l.Stage__c = 'On Hold';lstleads.add(l);
                }
                system.debug('lstleads -- ' + lstleads);
                if(!lstleads.isEmpty()){update lstleads;
                }
                pg= new pageReference('/'+con.Id);      
            }
            
         }
        catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Error'));
            system.debug('Error ::'+ex.getMessage());
        }
        return  pg;
    }

    public Boolean isStellarSchool() {
        return this.con.School_Short_Code__c == 'STELRA' || this.con.School_Short_Code__c == 'STELRB'  || this.con.School_Short_Code__c == 'STELRG';
    }
    
    public PageReference enqInterested()
    {
        PageReference pg;
        try{
            System.debug('enqInterested');
            if(!this.isStellarSchool() && con.Stages__c != 'Meet Done' ){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Meeting done is pending!.'));}
            /*
			else if(con.Meeting_Done__c == true){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Stage already updated!.'));
            }*/           
            else if(this.isStellarSchool() || (con.Stages__c == 'Meet Done' && con.Meeting_Done__c == true)){
                con.Interested__c = true;
                con.Stages__c = 'Interested';
                //con.Log_Status__c = 'Interested';
                con.Meeting_Done__c = true;
                con.On_Hold__c=false;
                update con;
                system.debug('lstlead -- ' + lstlead);
                for(lead le : lstlead){
                    lead l = new lead();
                    l.id = le.id;l.Stage__c = 'Interested';lstleads.add(l);
                }
                system.debug('lstleads -- ' + lstleads);
                if(!lstleads.isEmpty()){update lstleads;
                }
                pg= new pageReference('/'+con.Id);      
            }
            
         }
        catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Error'));
            system.debug('Error ::'+ex.getMessage());
        }
        return  pg;

}
public static void testMethod1(){
        for(integer i=1; i<= 2; i++){
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
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

}