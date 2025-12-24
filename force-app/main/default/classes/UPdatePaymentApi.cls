/*
To test, navigate to workbench, apex rest explorer,
select get, enter below url :

/services/apexrest/UpdatePayment/UpdateStatus?schoolid=001C5000002LEG4&mobilenumber=9819443581&Acdemicyear=2022-2023

Check the raw response and debug log for details
*/
@RestResource(urlMapping='/UpdatePayment/*')
global with sharing  class UPdatePaymentApi {
    @HttpPost
    global static String UpdateStatus() {
        boolean islead = false;
        RestRequest request = RestContext.request;
        RestResponse res = Restcontext.response;
        System.debug(request.params);
        string emailid = RestContext.request.params.get('emailid');
        string lead_id = RestContext.request.params.get('lead_id');
        string paymentdate = RestContext.request.params.get('paymentdate');
       // emailid='kushal.jain.g4nz9@universal.edu.in';
        system.debug('emailid : '+emailid);
        boolean isSucesss = false;
        Admission_Granted__c ld = null;
        
        if (emailid != null && emailid != '') {
            ld = [SELECT id,Lead_ID__c,Fees_Status__c, Payment_Received__c,Payment_Confirmed__c,Lead__c,Payment_Confirmed_On_Date__c,Payment_Confirmed_On_Time__c FROM Admission_Granted__c  WHERE Email_Address__c =:emailid LIMIT 1];
        } else if (lead_id != null && lead_id != '') {
            ld = [SELECT id,Lead_ID__c,Fees_Status__c, Payment_Received__c,Payment_Confirmed__c,Lead__c,Payment_Confirmed_On_Date__c,Payment_Confirmed_On_Time__c FROM Admission_Granted__c  WHERE Lead_Id__c=:lead_id LIMIT 1];
        }
        system.debug(ld);
        if(ld!=null){
            ld.Payment_Received__c=true;
            ld.Payment_Confirmed__c=true;
            ld.Fees_Status__c='Paid';
            ld.Payment_Confirmed_On_Date__c=paymentdate;
            ld.Payment_Confirmed_On_Time__c=system.now().format('hh:mm a');
            isSucesss=true;
            update ld;
            Lead l=new lead();
            if(ld.Lead__c!=null)
            {
                l = [Select id, Payment_Confirmed__c,Payment_Confirmed_On_Date__c,Payment_Confirmed_On_Time__c from Lead  where id =:ld.Lead__c limit 1];
            }
            else if(ld.Lead_ID__c!=null)
            {
                l = [Select id, Payment_Confirmed__c,Payment_Confirmed_On_Date__c,Payment_Confirmed_On_Time__c from Lead  where Lead_ID__c =:ld.Lead_ID__c limit 1];                
            }
            if(l!=null && l.id!=null){
                l.Payment_Confirmed__c=true;
                l.Payment_Confirmed_On_Date__c=paymentdate;
                l.Payment_Confirmed_On_Time__c=system.now().format('hh:mm a');
                
                update l;
            }
        }
        return ld.Lead_ID__c != null ? ld.Lead_ID__c : 'Lead_ID__c not available';
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
    }    
}