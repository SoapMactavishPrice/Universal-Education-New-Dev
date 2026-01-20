trigger UE_DuplicateContact on Contact (before insert, Before update) 
{
    for(Contact c:trigger.new)
    {
        for(Contact l:[Select MobilePhone,SecondaryMobileNo__c,Phone from Contact])
        {
            if(c.MobilePhone!=null || c.SecondaryMobileNo__c!=null )
            {
                if(l.MobilePhone==c.MobilePhone || l.MobilePhone==c.SecondaryMobileNo__c || l.SecondaryMobileNo__c==c.MobilePhone || l.SecondaryMobileNo__c==c.SecondaryMobileNo__c )
                {
                    c.addError('This Contact is already exist'); 
                }
            }
        } 
    }

}