public class UE_CtrAddQuesAnswer {
    
    public Q_A__c opplt{get;set;}
    public List<Q_A__c> listopp{get;set;}
    public List<Q_A__c> listopp1{get;set;}
    public FAQs__c op{get;set;}
    public Id pid {get;set;}
    private ApexPages.StandardSetController controller;
    
   public UE_CtrAddQuesAnswer(ApexPages.StandardsetController controller){
        this.controller = controller;
        pid=ApexPages.currentPage().getParameters().get('id');
        op=new FAQs__c();
        opplt=new Q_A__c();
        listopp=new List<Q_A__c>();
        opplt.FAQ__c=pid;
        listopp.add(opplt);
        
    }
   
	public void addrow()
      {
       Q_A__c oplt=new Q_A__c();
       oplt.FAQ__c=pid;
       listopp.add(oplt);
      } 
    
    public void delRow(){
        Integer i=listopp.size();
        listopp.remove(i-1);
    }

    public PageReference save()
       {	
           listopp1=new List<Q_A__c>();
           System.debug('List:'+ listopp);
           for(Q_A__c qa : listopp)
           {
               
               Q_A__c q1=new Q_A__c();
               
               q1.FAQ__c =pid;
               q1.Questions__c = qa.Questions__c;
               q1.Answer__c = qa.Answer__c;
               system.debug('CHECk'+q1);
               listopp1.add(q1);
           }
           insert listopp1;
           Schema.DescribeSObjectResult result = Q_A__c.SObjectType.getDescribe();
           PageReference pg=new PageReference('/' + pid);
           pg.setRedirect(true);
           return pg;    
       } 
       public PageReference cancel()
       {
           Schema.DescribeSObjectResult result = Q_A__c.SObjectType.getDescribe();
           PageReference pg=new PageReference('/' + pid);
           pg.setRedirect(true);
           return pg;    
       }       
    

}