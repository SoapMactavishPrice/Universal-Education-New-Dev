trigger sending_SMS_on_newApplicationForm on Application_Form__c (after insert) {

    ApplicationFormHandler.changeParentOfAttachments();
    // List<smsgupshupTemplate__c> sms=new List<smsgupshupTemplate__c>();
    // List<Application_Form__c> Enq=new List<Application_Form__c>();
    // String msg;

    // if(Trigger.isInsert){
    //     for(Application_Form__c ap:trigger.new)
    //     {
    //         if(ap.Mobile_Number__c !=null )
    //         {
    //             System.debug('Applcation Mobile Number::::'+ap.Mobile_Number__c);

    //             msg = 'Dear Parent, Thank you for submitting your application. Your Application no. is '+ap.Name;

    //             System.debug('NUMBER:::'+ap.Mobile_Number__c);
    //             if(ap.Mobile_Number__c!=null)
    //                 {
    //                     EnquirySendSmSCallout.sendgupshupsms(msg,ap.Mobile_Number__c,'2000045203','universalgoogle');
    //                     EnquirySendSmSCallout.sendsms();
    //                     UE_SendApplicationFormPDF.sendPDF(ap.id);
    //                     System.debug('Successfully send SMS'+ap.Mobile_Number__c);

    //                 }
    //             }

    //      }

    // }
    //     if(Trigger.isUpdate){

    //     }
}