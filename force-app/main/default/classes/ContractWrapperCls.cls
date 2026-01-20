global class ContractWrapperCls {
    public Boolean isSelected {get;set;}
    public Contact contactcls {get;set;}
    public ContractWrapperCls(Contact contactcls,Boolean isSelected)
    {
       // contactcls=new Contact();
       // isSelected=false;
       this.contactcls= contactcls;
       this.isSelected= isSelected;
    }    
    public ContractWrapperCls(Contact contactcls){
        this.contactcls = contactcls;
    }
}


////////////////////////////////////
//public class Sample 
//{    
/*    private integer totalRecs = 0;     
    private integer index = 0;
    private integer blockSize = 5;         
    
    public sample()
    {
        totalRecs = [select count() from Member__c];        
    }    
    
    public List<Member__c> getMemb() 
    {
        List<Member__c> membs = Database.Query('SELECT Name, Age__c FROM Member__c LIMIT :blockSize OFFSET :index');
        System.debug('Values are ' + membs);
        return membs;
    }    
    
    public void beginning()
    {
        index = 0;
    }
    
    public void previous()
    {
        index = index - blockSize;
    }
    
    public void next()
    {
        index = index + blockSize;
    }

    public void end()
    {
        index = totalrecs - math.mod(totalRecs,blockSize);
    }        
    
    public boolean getprev()
    {
        if(index == 0)
        return true;
        else
        return false;
    }  
    
    public boolean getnxt()
    {
        if((index + blockSize) > totalRecs)
        return true;
        else
        return false;
    }      */   
//}