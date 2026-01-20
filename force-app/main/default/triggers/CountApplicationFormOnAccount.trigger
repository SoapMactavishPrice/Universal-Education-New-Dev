trigger CountApplicationFormOnAccount on Application_Form__c (after insert, after update, after delete, before insert) {


Set <Id> accountIds = new Set <Id>();
List <Account> lstAccountsToUpdate = new List <Account>();
if(Trigger.isInsert){
for(Application_Form__c app:trigger.new){
    accountIds.add(app.School_Institution__c);
}
}
if(Trigger.isUpdate|| Trigger.isDelete){
for(Application_Form__c app:trigger.old){
    accountIds.add(app.School_Institution__c);
}
}

for(Account acc:[SELECT Id,Name,Total_No_of_Application_Form_Received__c,(Select Id from Applications_Form__r) from Account where Id IN: accountIds]){
Account accObj = new Account ();
accObj.Id = acc.Id;
accObj.Total_No_of_Application_Form_Received__c = acc.Applications_Form__r.size();
lstAccountsToUpdate.add(accObj);
}

UPDATE lstAccountsToUpdate;


if(Trigger.isBefore && Trigger.isInsert)
{
List<smsgupshupTemplate__c> sms=new List<smsgupshupTemplate__c>();
List<Application_Form__c> Enq=new List<Application_Form__c>();
String msg;

for(Application_Form__c ap:trigger.new)
{
if(ap.Mobile_Number__c !=null && ap.ApplicationReceived_SMS_Sent__c == False)
{
    System.debug('Applcation Mobile Number::::'+ap.Mobile_Number__c);
    
    sms=[select id,Description__c,Name__c from smsgupshupTemplate__c where Name__c=:'confirm_Application'];
    system.debug('SMS Name++++'+sms);
    
    msg = 'Dear Parent, Thank you for submitting your application. Your Application no. is '+ap.Name+'. Kindly submit all forms & documents to the school office within 3 working days.';
    
    //if(sms!=null && sms.size()>0)
    //{
        System.debug('NUMBER:::'+ap.Mobile_Number__c);
        if(ap.Mobile_Number__c!=null)
        {   
            
           
           // EnquirySendSmSCallout.sendgupshupsms(sms[0].Description__c,ap.Mobile_Number__c,'2000045203','universalgoogle');
            EnquirySendSmSCallout.sendgupshupsms(msg,ap.Mobile_Number__c,'2000045203','universalgoogle');
            EnquirySendSmSCallout.sendsms();
            ap.ApplicationReceived_SMS_Sent__c =True;
            System.debug('Successfully send SMS'+ap.Mobile_Number__c);
            
        }
   // }          
}



}
}



}