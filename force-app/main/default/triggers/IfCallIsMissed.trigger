trigger IfCallIsMissed on Task (after insert) {
   /* system.debug('@@@@@@@@@');
    
    List<smsgupshupTemplate__c> sms=new List<smsgupshupTemplate__c>();
    List<Task> tlist=new List<Task>();
    String t;
    for(Task e:trigger.new){
       //if(e.Description.){
        sms=[select id,Description__c,Name__c from smsgupshupTemplate__c where Name__c='If Call Missed'];
           if(sms!=null && sms.size()>0){
               
               if(e.Description!= null && e.Description !='') { 
               String Test=e.Description;
                t=Test.substringBetween('Call Type:','Call ID');
                    system.debug('#########'+t); 
               }
               
               if(e.Description!= null && e.Description !='') {  
              if(t!=null && ( t.contains('Sound - NA') || t.contains('Phone - NO_ANSWER') || t.contains('Phone - User Disconnected')) ){
                if(e.WhoId!=null ){
                 Contact c=[Select id,Phone from Contact where id=:e.whoId];
                  System.debug('NUMBER:::'+c.phone);
                   if(c.Phone!=null){
            EnquirySendSmSCallout.sendgupshupsms(sms[0].Description__c,c.Phone,'2000045203','universalgoogle');
            EnquirySendSmSCallout.sendsms();
                 System.debug('@@@@@@@@@@::::::'+t);  
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
                       
           //}
            
                }
         
    
        }
    
    
    */
    
    
}