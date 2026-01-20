/**
* Class that is used to send emails with a particular template and email address to particular contact for EnquiryForm Link
* @created 13/09/2020
*/
global class Send_EnquiryFormLink_SingleEmail{
    webservice static Boolean SendEmailNotification (String conId){
        Boolean Ret=true;
        list<contact> conList = [SELECT Name,FirstName,LastName,Phone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Enquiry_Send_Date__c,Academic_Year__c,school_Name__c,Email,Enquiry_Link_Sent__c,Account.name,Account.School_Short_Code__c,AccountID,Account.For_Mapping_Email__c, Account.Website FROM contact WHERE Enquiry_Link_Sent__c = false AND Id = :conId];
        list<user> u = [Select Name, Profile.Name, Email, Phone, userrole.name From User Where id = :UserInfo.getUserId()];
        try{

            system.debug('the selected contacts are  ' + conList);
            list<String> emailsent ;
            Site mySite = [select Id from Site where Name = 'enquiryForm'];
            SiteDetail mySiteDetail = [select SecureURL from SiteDetail where DurableId = :mySite.Id];
            system.debug('mySite  ' + mySite +'mySiteDetail  ' + mySiteDetail.SecureURL);
            String Sname=conList[0].Account.School_Short_Code__c;
                string cid=conList[0].Id;
                //string lname=conList[0].FirstName;
                //string fname=conList[0].LastName;
               // string cphone=conList[0].Phone;
               // string cemail=conList[0].Email;
               // string cstreet=conList[0].MailingStreet;
               // string ccity=conList[0].MailingCity;
              // string cstate=conList[0].MailingState;
              // string cpin=conList[0].MailingPostalCode;
              // string ccountry=conList[0].MailingCountry;
                System.debug('Sname' + Sname);
              conList[0].Enquiry_Send_Date__c = System.today();
            update conList;
           // String Sitelink = mySiteDetail.SecureURL+'/normalEnquiryForm'+'?sname='+sname +'&cid='+cid;  //'/enquiry/UE_AdmissionFormVF';
             String Sitelink = mySiteDetail.SecureURL+'/normalEnquiryForm'+'?sname='+sname +'&cid='+cid;  //'/enquiry/UE_AdmissionFormVF';
            system.debug('Sitelink  ' +Sitelink);

          //Commented by Himanshu for new Template 25/09/2020
          /*  String body= 'Dear Parent,<br><br>Thank you for registering with the Universal Admission Enquiry System. .<br><br>Kindly'+
                '<a href="'+Sitelink+'">click here.</a> to continue with the online Enquiry Form.<br>Important information: After you click on the link, '+
                'fill the enquiry form. as it is mentioned above without any variation in space or characters.<br><br>'+
                'Best Regards,<br>Universal Admission Enquiry System';
            */

            String body= 'Dear '+conList[0].Name + ','+'<br><br> Greetings from ' +conList[0].Account.Name +'!'+'<br><br>'+
                'Thank you for your interest with regards to the admission of your Child at ' +conList[0].Account.Name + '.'+'<br><br>'+
                'As the first step towards your child’s academic journey with ' +conList[0].Account.Name +','+' we would request you to fill in the Online Admission Enquiry form for Academic Year '+conList[0].Academic_Year__c +'.<br><br>'+
                 '<a href="'+Sitelink+'">Click here</a> to fill & submit the Admission enquiry form.<br><br>'+
                'Once your admission enquiry form is received, our admissions team will review it and will get in touch with you to take the process further.<br><br>'+ 'If you require further information, feel free to contact me.<br><br>'+
                
               // 'Our Best, <br>'  + u[0].Name + '<br>' +  u[0].Profile.Name + '<br>'+  +conList[0].Account.Name +  '<br>' + 'Phone: ' + u[0].Phone + '<br>'+ 'Email: ' + u[0].Email + '<br>' + 'Website: ' +conList[0].Account.Website + '<br><br>' +
            	'This is a system-generated email. Kindly dont respond to it. For any communication, please contact on the email/phone number given below.<br><br>';
            //Email Sending
            List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();



            for (Integer i = 0; i < conList.size(); i++) {
                system.debug('conList' +conList[i]);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                for(OrgWideEmailAddress owa : [SELECT Id, Address,DisplayName from OrgWideEmailAddress]) {
                    // if(owa.DisplayName.contains(orgwideContains)){
                    // if( conList[0].school_Name__c.contains(owa.DisplayName.substring(0,4))){
                    if( owa.DisplayName.contains(conList[0].Account.For_Mapping_Email__c)){
                        mail.setOrgWideEmailAddressId(owa.id);
                    }
                }
				String mailSubject = 'Admission enquiry form '+conList[i].Academic_Year__c;
                mail.setSubject(mailSubject);
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