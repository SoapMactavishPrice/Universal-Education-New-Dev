trigger AutomateSMSTask on Task (after insert,after update) 
{
    String t;
    List<smsgupshupTemplate__c> sms=new List<smsgupshupTemplate__c>();
    List<Task> tlist=new List<Task>();
    for(Task e:trigger.new)
    {
     if(e.knowlarity_cti__Call_Disposition__c!=null && e.CheckCallDisposition__c==False )
     {
      if(e.Status == 'Completed')
      {
        if(e.knowlarity_cti__Knowlarity_Number__c=='+912233292028' || e.knowlarity_cti__Knowlarity_Number__c=='+912233292024')
        {
        sms=[select id,Description__c,Name__c from smsgupshupTemplate__c where Name__c='Universal Education Call Disposed Successfully'];
         if(sms!=null && sms.size()>0)
         {
           if(e.WhoId!=null)
           {
            Contact c=[Select id,Phone from Contact where id=:e.whoId];
            System.debug('NUMBER:::'+c.phone);
            if(c.Phone!=null)
            {
             EnquirySendSmSCallout.sendgupshupsms(sms[0].Description__c,c.Phone,'2000045203','universalgoogle');
             EnquirySendSmSCallout.sendsms();
            
             Task t1=new Task();
             t1.id=e.id;
             t1.CheckCallDisposition__c=True;
             tlist.add(t1);
             update tlist;
            
             }
            }          
          }
        }
           
           
          //When Ebenezer Inbound Call Disposed Successfully
       if(e.knowlarity_cti__Knowlarity_Number__c=='+912233292026')
       {
        sms=[select id,Description__c,Name__c from smsgupshupTemplate__c where Name__c='Ebenezer Education Call Disposed'];
         if(sms!=null && sms.size()>0)
         {
           if(e.WhoId!=null)
           {
            Contact c=[Select id,Phone from Contact where id=:e.whoId];
            System.debug('NUMBER:::'+c.phone);
            if(c.Phone!=null)
            {
             EnquirySendSmSCallout.sendgupshupsms(sms[0].Description__c,c.Phone,'2000138537','universalgoogle');
             EnquirySendSmSCallout.sendsms();
        
             Task t1=new Task();
             t1.id=e.id;
             t1.CheckCallDisposition__c=True;
             tlist.add(t1);
             update tlist;
             }      
           }          
        }
      }
        
      if(e.knowlarity_cti__Knowlarity_Number__c=='+912233292022')
        {
            
        String Test=e.Description;
        t=Test.substringBetween('Call Type:','Call ID');
        system.debug('#########'+t); 
            
        Task t1=new Task();
        t1.id=e.id;
        //t1.CheckCallDisposition__c=True;
        t1.Call_Status__c = t;
        tlist.add(t1);
        update tlist;
        }      
      }
    }
  } 
  
}