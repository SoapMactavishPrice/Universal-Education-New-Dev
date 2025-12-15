trigger SendSMSforBussinessHour on Task (after insert) {
    List<smsgupshupTemplate__c> sms=new List<smsgupshupTemplate__c>();
    List<Task> tlist=new List<Task>();
    String t;
    for(Task e:trigger.new)
    {
                            // Get the default business hours
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
                            // Create Datetime on for now in the local timezone.
        Datetime targetTime = System.now();
                            // Find whether the time now is within the default business hours
        Boolean isWithin= BusinessHours.isWithin(bh.id, targetTime);
                            // Update leads being inserted if during business hours
        
        If(isWithin == False)
        {
         if(e.knowlarity_cti__Knowlarity_Number__c=='+912233292028'|| e.knowlarity_cti__Knowlarity_Number__c=='+912233292024')
         {
          sms=[select id,Description__c,Name__c from smsgupshupTemplate__c where Name__c='Working Hours'];
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
         //   Task t1=new Task();
          //  t1.id=e.id;
          //  t1.CheckCallDisposition__c=True;
           // tlist.add(t1);
           // update tlist;
                  }
               }
            }
          }
            //When Ebenezer Education Getting call after or before business hour
            
       if(e.knowlarity_cti__Knowlarity_Number__c=='+912233292026')
       {
        sms=[select id,Description__c,Name__c from smsgupshupTemplate__c where Name__c='Ebenezer Education Business hour'];
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
         //   Task t1=new Task();
          //  t1.id=e.id;
          //  t1.CheckCallDisposition__c=True;
           // tlist.add(t1);
           // update tlist;
                  }
               }
            }
          }
            
      }
        
        //Sending Message for Universal Education when Inbound Call is missed
        
      if(e.knowlarity_cti__Knowlarity_Number__c=='+912233292028'|| e.knowlarity_cti__Knowlarity_Number__c=='+912233292024')
      {
       sms=[select id,Description__c,Name__c from smsgupshupTemplate__c where Name__c='Universal Education If Call Missed'];
       if(sms!=null && sms.size()>0)
       {
            
         if(e.Description!= null && e.Description !='') 
         { 
           String Test=e.Description;
           t=Test.substringBetween('Call Type:','Call ID');
           system.debug('#########'+t); 
           }
           if(e.Description!= null && e.Description !='')
           {  
              if(t!=null && ( t.contains('Sound - NA') || t.contains('Phone - NO_ANSWER') || t.contains('Phone - User Disconnected')) )
              {
               if(e.WhoId!=null )
                {
                 Contact c=[Select id,Phone from Contact where id=:e.whoId];
                 System.debug('NUMBER:::'+c.phone);
                 if(c.Phone!=null)
                 {
                        EnquirySendSmSCallout.sendgupshupsms(sms[0].Description__c,c.Phone,'2000045203','universalgoogle');
                        EnquirySendSmSCallout.sendsms();
                        System.debug('@@@@@@@@@@::::::'+t);  
                  }
               }
            }
         }        
      }
          
             
        Task t1=new Task();
        t1.id=e.id;
        //t1.CheckCallDisposition__c=True;
         t1.Call_Status__c = t;
         tlist.add(t1);
         update tlist;
         }
        
        //Sending Message for Ebenezer Education when Inbound Call is missed
        
   if(e.knowlarity_cti__Knowlarity_Number__c=='+912233292026')
      {
       sms=[select id,Description__c,Name__c from smsgupshupTemplate__c where Name__c='Ebenezer Education Missed call'];
       if(sms!=null && sms.size()>0)
       {
            
         if(e.Description!= null && e.Description !='') 
         { 
           String Test=e.Description;
           t=Test.substringBetween('Call Type:','Call ID');
           system.debug('#########'+t); 
           }
           if(e.Description!= null && e.Description !='')
           {  
              if(t!=null && ( t.contains('Sound - NA') || t.contains('Phone - NO_ANSWER') || t.contains('Phone - User Disconnected')) )
              {
               if(e.WhoId!=null )
                {
                 Contact c=[Select id,Phone from Contact where id=:e.whoId];
                 System.debug('NUMBER:::'+c.phone);
                 if(c.Phone!=null)
                 {
                        EnquirySendSmSCallout.sendgupshupsms(sms[0].Description__c,c.Phone,'2000138537','universalgoogle');
                        EnquirySendSmSCallout.sendsms();
                        System.debug('@@@@@@@@@@::::::'+t);  
                  }
               }
            }
          }        
       }
          
        Task t1=new Task();
        t1.id=e.id;
        //t1.CheckCallDisposition__c=True;
         t1.Call_Status__c = t;
         tlist.add(t1);
         update tlist;
          
        }
        
        //Here only updating the Fields
        
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