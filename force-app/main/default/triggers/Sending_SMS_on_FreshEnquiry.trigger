trigger Sending_SMS_on_FreshEnquiry on Enquiry__c (Before Insert,before update, after update) {

    
    List<smsgupshupTemplate__c> sms=new List<smsgupshupTemplate__c>();
    List<Enquiry__c> Enq=new List<Enquiry__c>();
    List<Gupshup_Credential__mdt> listCustomMetadata = new list<Gupshup_Credential__mdt>();
    listCustomMetadata = [Select id,Gupshup_Username__c,Gupshup_Password__c,SchoolShortCode__c from Gupshup_Credential__mdt];
    String msg;
    system.debug('listofcustomMetadata::'+listCustomMetadata.size());
    if(Trigger.isBefore && Trigger.isInsert){
        
        for(Enquiry__c e:trigger.new)
        {
            
            if(e.Stages__c == 'Enquiry' )
            {
                for(Gupshup_Credential__mdt gc : listCustomMetadata){
                    if(gc.SchoolShortCode__c.Contains(e.orgCode__c)){
                        System.debug('Enquiry_Stage::::'+e.Stages__c);
                        System.debug('shortcode'+e.orgCode__c);
                         String cphone = e.Mobile_No__c.replaceAll('\\D',''); 
                         system.debug(+cphone);
                        sms=[select id,Description__c,Name__c from smsgupshupTemplate__c where Name__c=:'Confirmation_Enquiry'];
                        system.debug('SMS Name++++'+sms);
                        
                        //msg = 'Dear Parent, Thank you for registering with Universal Education Admission Enquiry System. Your Enquiry no is '+e.Name+'. You are requested to visit the school office for an interaction with the Admission officer. Monday-Saturday : 9 am to 5 pm. Closed on 2nd and 4th Saturdays.';
                        //msg = 'Dear Parent, Thank you for registering with Universal Education. Your admission enquiry no. is '+e.Name;
                        msg = 'Dear Parent, Your Admission enquiry no. is '+e.Name+'. We shall contact you shortly.'; 
                        System.debug('NUMBER:::'+e.Mobile_No__c);
                        if(cphone!=null && e.Welcome_SMS_sent__c == false)
                        {
                            //EnquirySendSmSCallout.sendgupshupsms(sms[0].Description__c,e.Mobile_No__c,'2000045203','universalgoogle');
                           // EnquirySendSmSCallout.sendgupshupsms(msg,e.Mobile_No__c,'2000045203','universalgoogle');
                            EnquirySendSmSCallout.sendgupshupsms(msg,cphone,gc.Gupshup_Username__c,gc.Gupshup_Password__c);
                            EnquirySendSmSCallout.sendsms();
                            System.debug('Successfully send SMS on::'+cphone);
                            e.Welcome_SMS_sent__c = true;
                            
                            System.debug('gc.Gupshup_Username__c::'+gc.Gupshup_Username__c);
                            System.debug('gc.Gupshup_Username__c::'+gc.Gupshup_Password__c);
                            
                        }
                    }
                }
            }
        }
    }
    if(Trigger.isBefore){
        for(Enquiry__c e:trigger.new){
            if(e.Stages__c == 'Application Link Sent' ){
                System.debug('If ISUPDATE::::');
                Site mySite = [select Id from Site where Name = 'ApplicationProcess'];
        SiteDetail mySiteDetail = [select SecureURL from SiteDetail where DurableId = :mySite.Id];
        System.debug(mySiteDetail.SecureURL);
                String Sitelink = mySiteDetail.SecureURL+'/?eid='+e.id;
                
                //  msg = 'Dear Parent,Thank you for registering with the Universal Admission Enquiry System. Your Enquiry no. is 2020-21/III/UHM/ENQ/181.You may continue with the admission process. To access the Application form click the link : https://developer-universaleducation.cs74.force.com/?eid=a010p0000017vvd';
                 //   msg='Dear Parent, Thank you for registering with the Universal Admission Enquiry System. Your Enquiry no. is '+e.Name+'.You may continue with the admission process. To access the Application form click the link : https://newdev-universaleducation.cs57.force.com/?eid='+e.id;
                   msg='Dear Parent, Thank you for registering with the Universal Admission Enquiry System. Your Enquiry no. is '+e.Name+'.You may continue with the admission process. To access the Application form click the link : '+Sitelink;
                String cphone;
              if(cphone!=null)
                { 
                    for(Gupshup_Credential__mdt gc : listCustomMetadata){
                    if(gc.SchoolShortCode__c.Contains(e.orgCode__c)){
                   // EnquirySendSmSCallout.sendgupshupsms(msg,e.Mobile_No__c,'2000045203','universalgoogle');
                    EnquirySendSmSCallout.sendgupshupsms(msg,cphone,gc.Gupshup_Username__c,gc.Gupshup_Password__c);
                        EnquirySendSmSCallout.sendsms();
                    e.Application_link_Via_SMS__c = true;
                    System.debug('Successfully send SMS on:::'+cphone);
                    }
                    }
                }
            }
            
        }
    }
    
    
}