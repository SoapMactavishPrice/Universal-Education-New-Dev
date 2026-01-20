/**
* Class that is used to send emails with a particular template and email address to Mass contact for EnquiryForm Link
* @author  Himanshu Nimje (ZuesForce.com)
* @created 12/09/2020
*/
global class Send_EnquiryFormLink_MassEmail{
    webservice static Boolean SendEmailNotification (list<id> conId){
        Boolean Ret=true;
        list<contact> conList = [SELECT name,FirstName,LastName,Phone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,school_Name__c,email,Account.Name,Enquiry_Link_Sent__c,Account.School_Short_Code__c FROM contact WHERE Enquiry_Link_Sent__c=false and id IN : conId];
        try{
            
            system.debug('the selected contacts are  ' + conList);
            list<String> emailsent ;
            Site mySite = [select Id from Site where Name = 'enquiryForm'];
            SiteDetail mySiteDetail = [select SecureURL from SiteDetail where DurableId = :mySite.Id];
            system.debug('mySite  ' + mySite +'mySiteDetail  ' + mySiteDetail.SecureURL);
           // String Sitelink = mySiteDetail.SecureURL+'/normalEnquiryForm'; //'/enquiry/UE_AdmissionFormVF';
            
            
         //   String body= 'Dear Parent,<br><br>Thank you for registering with the Universal Admission Enquiry System. .<br><br>Kindly <a href="'+Sitelink+'">click here.</a> to continue with the online Enquiry Form.<br>Important information: After you click on the link, fill the enquiry form. as it is mentioned above without any variation in space or characters.<br><br>Best Regards,<br>Universal Admission Enquiry System';
            
            //Email Sending
            List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
            
            
            
            for (Integer i = 0; i < conList.size(); i++) {
                system.debug('conList' +conList[i]);
                String Sname=conList[i].Account.School_Short_Code__c;
                string cid=conList[i].Id;
              /*  string lname=conList[0].FirstName;
                string fname=conList[0].LastName;
                string cphone=conList[0].Phone;
                string cemail=conList[0].Email;
                string cstreet=conList[0].MailingStreet;
                string ccity=conList[0].MailingCity;
               string cstate=conList[0].MailingState;
               string cpin=conList[0].MailingPostalCode;
               string ccountry=conList[0].MailingCountry;*/
                System.debug('Sname' + Sname);
                //Adding Sname 
                String Sitelink = mySiteDetail.SecureURL+'/normalEnquiryForm?sname='+Sname +'&cid='+cid ;
                system.debug('Sitelink  ' +Sitelink);
                
               // String body= 'Dear Parent,<br><br>Thank you for registering with the Universal Admission Enquiry System. .<br><br>Kindly <a href="'+Sitelink+'">click here.</a> to continue with the online Enquiry Form.<br>Important information: After you click on the link, fill the enquiry form. as it is mentioned above without any variation in space or characters.<br><br>Best Regards,<br>Universal Admission Enquiry System';
                                
                 String body= 'Dear ' + conList[0].Name +'<br><br>Greetings from ' +conList[0].Account.Name +'<br><br>'+
                'Thank you for your interest with regards to the admission of your ward. Please fill the '+ '<a href="'+Sitelink+'">Admission enquiry form </a>  2021-22.<br><br>'+
                'An Admissions team member will get in touch with you after this form is submitted. '+'<br><br>';
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                for(OrgWideEmailAddress owa : [SELECT Id, Address,DisplayName from OrgWideEmailAddress]) {
                    // if(owa.DisplayName.contains(orgwideContains)){
                    if( conList[i].school_Name__c.contains(owa.DisplayName.substring(0,4))){
                        mail.setOrgWideEmailAddressId(owa.id);
                    }
                }
                mail.setSubject('Admission enquiry form 2021-22');
                mail.setHtmlBody(body);
                mail.setToAddresses(new List<String>{conList[i].email});
                lstMsgs.add(mail);
                
            }
            system.debug('lstMsgs'+ lstMsgs);
            
            List<Messaging.SendEmailResult> results  =  Messaging.sendEmail(lstMsgs);
            if (results[0].isSuccess()) {
                for (Integer i = 0; i < conList.size(); i++) {
                    conList[i].Enquiry_Link_Sent__c=true;
                }
                Update conList;
                system.debug('The email was sent successfully.');
            } else {
                system.debug('The email failed to send: '  + results[0].getErrors()[0].getMessage());
                ret= false;
            }
            
        }catch(exception exp){
            system.debug('ERROR:::'+exp.getMessage());
             ret =false;
        }
        return ret;
    }
}