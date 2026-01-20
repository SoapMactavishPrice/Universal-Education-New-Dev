/**
* Class that is used to send emails with a particular template and email address to Mass Enquiry record for application form
* @created 19/09/2020
*/
global class send_ApplicationFormLink_MassEmail{
    webservice static Boolean SendEmailNotification (list<id> enqId){
        
        list<Enquiry__c> conList = [SELECT Id,ParentFull_Name__c,School_Institution__c, School_Name__c, Name, Contact__c, Email__c, Enquiry_No__c, FirstName__c, Gender__c, Grade__c, Last_Name__c, Seeking_Admission_in_Grade__c, Stages__c FROM Enquiry__c WHERE Application_Sent__c=false and Interaction_Done__c=true and id IN :enqId];
       
        system.debug('enqList  ' + conList);
       
        Boolean Ret=true;
      //  list<contact> conList = [SELECT name,email,Enquiry_Link_Sent__c,Account.School_Short_Code__c FROM contact WHERE Enquiry_Link_Sent__c=false and id IN : conId];
        try{
            
            system.debug('the selected contacts are  ' + conList);
            list<String> emailsent ;
            Site mySite = [select Id from Site where Name = 'ApplicationProcess'];
            SiteDetail mySiteDetail = [select SecureURL from SiteDetail where DurableId = :mySite.Id];
            system.debug('mySite  ' + mySite +'mySiteDetail  ' + mySiteDetail.SecureURL);
        
               //Email Sending
            List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
            
            
            
            for (Integer i = 0; i < conList.size(); i++) {
                system.debug('conList' +conList[i]);
                String Sname=conList[i].School_Name__c;
                string eid=conList[i].Id;
                System.debug('eid' + eid);
                
               // String Sitelink = mySiteDetail.SecureURL+'/UE_sendApplication?sname='+Sname +'&eid='+eid; 
                String Sitelink = mySiteDetail.SecureURL+'/UE_applicationForm_Site?&eid='+eid;
                system.debug('Sitelink  ' +Sitelink);
                
                //String body= 'Dear Parent,<br><br>Thank you for registering with the Universal Admission Enquiry System. Your Enquiry no. is '+ conList[i].Name +'.<br><br>Kindly <a href="'+Sitelink+'">click here.</a> to continue with the online admission process.<br>Important information: After you click on the link, fill the admission enquiry no. as it is mentioned above without any variation in space or characters.<br><br>Best Regards,<br>Universal Admission Enquiry System';
                
                String body= 'Dear ' + conList[i].ParentFull_Name__c +'<br><br>Greetings from ' + conList[i].School_Name__c +'<br><br>'+
                'Kindly <a href="'+Sitelink+'">click here</a>'+' to proceed with the Admission application process 2021-22.'+'<br><br>'+
                 'Please feel free to get in touch, should you have any queries.'+'<br><br>';    
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                for(OrgWideEmailAddress owa : [select id, Address,DisplayName from OrgWideEmailAddress]) {
                    if(owa.DisplayName.contains('Universal'))
                        mail.setOrgWideEmailAddressId(owa.id);
                } mail.setSubject('Application Proccess Started'+' '+conList[i].Name +' '+conList[i].School_Name__c);
                mail.setHtmlBody(body);
                mail.setToAddresses(new List<String>{conList[i].Email__c});
                lstMsgs.add(mail);
                
            }
            system.debug('lstMsgs'+ lstMsgs);
            
            List<Messaging.SendEmailResult> results  =  Messaging.sendEmail(lstMsgs);
            if (results[0].isSuccess()) {
                for (Integer i = 0; i < conList.size(); i++) {
                    conList[i].Application_Sent__c=true;
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