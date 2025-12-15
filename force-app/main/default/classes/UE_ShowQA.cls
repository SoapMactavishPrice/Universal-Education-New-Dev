public class UE_ShowQA {
    
  	public  FAQs__c f{get;set;}
  	public List<Q_A__c> q{get;set;}
    public List<Q_A__c> qlist{get;set;}
    public string searchfaq{get;set;}
    public Boolean show1{get;set;}
    public Boolean show2{get;set;}
    ID pid = ApexPages.currentPage().getParameters().get('ID');
    
    public UE_ShowQA(ApexPages.StandardController std)
    {
       show1=true;
        show2=false;
      q=[Select Name,Questions__c,Answer__c from Q_A__c where FAQ__c=:pid];
    }
    public void search()
    {
        qlist=new List<Q_A__c>();
        show1=false;
        show2=true;
        system.debug('&&&&&&&'+q);
    	//String s=searchfaq+;
        //system.debug('@@@@@@@@'+s);
        for(Q_A__c qa:[Select id,Name,Questions__c,Answer__c from Q_A__c where FAQ__c=:pid])
        {
            if(qa.Questions__c.contains(searchfaq))
                qlist.add(qa);
        }
        System.debug('********--'+q);
        update q;
    }

}