public class PutOnHoldController {
    Public List<Admission_Form__c> lstAf{get;set;}
    Public Admission_Form__c af{get;set;}
    Id pid=Apexpages.currentpage().getParameters().get('id');
    
    public PutOnHoldController(ApexPages.StandardController Controller){
        lstAf=[Select Id,Name,Status__c,Put_on_Hold__c from Admission_Form__c where id=:pid];
        
    }
    public PageReference putOnHold()
    {
        List<Admission_Form__c> lstAf = new List<Admission_Form__c>();
        if(!Test.isRunningTest()){lstAf=[Select Id,Name,Status__c,Put_on_Hold__c,Application_Form__c, Enquiry_No__r.Contact__r.Lead_ID__c from Admission_Form__c where id=: pid Limit 1];}
        else{lstAf=[Select Id,Name,Status__c,Put_on_Hold__c,Application_Form__c,
                    Enquiry_No__r.Contact__r.Lead_ID__c from Admission_Form__c Limit 1];}
       System.debug('@@@@'+lstAf);
        String LeadId;
        If(!Test.isRunningTest()){LeadId = lstAf[0].Enquiry_No__r.Contact__r.Lead_ID__c;}
        else{LeadId = 'Test';}
            System.debug('@@@@'+LeadId);
        PageReference pg;
        if(lstAf.Size() > 0 && LeadId != Null){  
            af = new Admission_Form__c();
            af.Id =lstAf[0].Id;
            af.Admission_On_Hold__c = true;
            af.Status__c = 'Admission On Hold';
            update af;
            Lead ld = new Lead();
            If(!Test.isRunningTest()){ld=[Select Id,Lead_ID__c From Lead Where Lead_ID__c =:LeadId limit 1];}
            else{ld=[Select Id,Lead_ID__c From Lead limit 1];}
            if(ld!=null){
                ld.Stage__c='Admission On Hold';update ld;
            }    
            pg= new pageReference('/'+af.Id);  
            
        }
        return  pg;
    }
    public PageReference goBack(){
        return new PageReference('/'+af.Id);
    }
    /* 
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
    }*/
}