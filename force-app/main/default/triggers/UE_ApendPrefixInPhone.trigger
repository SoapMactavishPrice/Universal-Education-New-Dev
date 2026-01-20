trigger UE_ApendPrefixInPhone on Contact (before insert,before Update) 
{
    for(Contact l:trigger.new){
       if(l.MobilePhone!=null)
       {   
       if(l.MobilePhone.contains('+91')==false)
       {
           if(l.MobilePhone.length()==10 )
           {
                l.MobilePhone = '+91'+l.MobilePhone;
           }
           else
           {
               l.addError('Invalid Primary Number!!!');
           }
       }
       }
       if(l.SecondaryMobileNo__c!=null)
       { 
            if(l.SecondaryMobileNo__c.contains('+91')==false)
            {
                if(l.SecondaryMobileNo__c.length()==10 )
                {
                    l.SecondaryMobileNo__c = '+91'+l.SecondaryMobileNo__c;
                }
                else
                {
                    l.addError('Invalid Secondary Number!!!');
                }
            }
       }
    }
}