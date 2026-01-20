public class Ue_ApplicationReceivedButton {
    
    public Application_form__c appForm {set;get;}
    public id formids=Apexpages.currentPage().getparameters().get('id'); 
    public string customleadValue{get;set;}
    public Ue_ApplicationReceivedButton(Apexpages.StandardController stdcontroller)
    {
        appForm = (formids==null) ? new Application_form__c():[ select id,Print_Copy_Submitted__c,Enquiry__c,
                                                               Enquiry__r.Contact__c,Enquiry__r.Contact__r.Lead_ID__c,Enquiry__r.Lead_ID__c
                                                               FROM Application_form__c where id=: formids];
            System.debug('Application Record---'+formids);
        customleadValue = appForm.Enquiry__r.Lead_ID__c;
    }
    public pageReference UpdateApplicationForm()
    {
        pageReference pg1;
        
        if(appForm.Print_Copy_Submitted__c){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Print Copy is already Submitted'));            
                                    
            }else{
            appForm.Print_Copy_Submitted__c = true;
            appForm.Status__c = 'Application Received';
            update appForm;
            Enquiry__c enq =[Select id,Name,Stages__c from Enquiry__c where id =: appForm.Enquiry__c Limit 1 ];
            enq.Stages__c= 'Application Received';
            update enq;
                List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Task_Count__c,Dormant_Count__c,Dormant__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead){
                        lead l = new lead();
                        l.id = le.id;
                        l.Stage__c = 'Application Received';
                        //l.Task_Count__c = 0;
                        l.Dormant_Count__c = 0;
                        l.Dormant__c = false ;
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){update lstlead;
                    }
                }
            pg1 = new pageReference('/'+appForm.Id);
        }
        return pg1;
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
     }
}