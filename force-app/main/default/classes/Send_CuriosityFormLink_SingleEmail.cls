global class Send_CuriosityFormLink_SingleEmail {
    public static Boolean isTesting = false;
    webservice static Boolean SendEmailNotification(String conId){
        Boolean Ret = true;
        list<contact> conList = [SELECT Name, FirstName, LastName, Phone, MailingCity, MailingCountry,
                                 MailingPostalCode, MailingState, MailingStreet, Enquiry_Send_Date__c,Lead_ID__c, 
                                 Academic_Year__c, school_Name__c, Email, Enquiry_Link_Sent__c, Account.name,
                                 Account.School_Short_Code__c, AccountID, Account.For_Mapping_Email__c, Account.Website,
                                 Log_Status__c,Stages__c,Meeting_Done__c,Interaction_Done__c,On_Hold__c,Interested__c FROM contact
                                 WHERE Id = :conId];
        list<user> u = [Select Name, Profile.Name, Email, Phone, userrole.name
                        From User
                        Where id = :UserInfo.getUserId()];
        //   try{
        
        system.debug('the selected contacts are  ' + conList);
        list<String> emailsent;
        
        String Sname = conList[0].Account.School_Short_Code__c;
        string cid = conList[0].Id;
        System.debug('Sname' + Sname);
        datetime dt = conList[0].Enquiry_Send_Date__c;
        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        List<School_List__mdt> schoolListmeta = [SELECT Id, Enable_Stellar__c, MasterLabel, DeveloperName
                                                 FROM School_List__mdt
                                                 WHERE DeveloperName = :Sname];
        System.debug(schoolListmeta);
        System.debug('stellar api not called');
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Stellar_World_School_Curiosity_Form'];
        for (Integer i = 0; i < conList.size(); i++){
            system.debug('conList' + conList[i]);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            for (OrgWideEmailAddress owa : [SELECT Id, Address, DisplayName
                                            from OrgWideEmailAddress]){
                                                if (owa.DisplayName.contains(conList[0].Account.School_Short_Code__c)){
                                                    mail.setOrgWideEmailAddressId(owa.id);
                                                }
                                            }
            String mailSubject = 'Admission Curiosity form ' + conList[i].Academic_Year__c;
            mail.setTargetObjectId(String.valueOf(conList[i].id)); 
            mail.setTemplateID(emailTemplate.Id); 
            mail.setToAddresses(new List<String>{conList[i].email});
            mail.setSaveAsActivity(true);
            lstMsgs.add(mail);
        }
        
        system.debug('lstMsgs' + lstMsgs);
        
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(lstMsgs);
        if (results[0].isSuccess()){
            Set<String> setOfLeadIds=new Set<String>();
            for (Contact contactItr : conList){
                contactItr.Curiosity_Link_Sent__c = true;
                contactItr.Curiosity_Send_Date__c = DateTime.now();
                //contactItr.Curiosity_Submitted__c=true;
                //contactItr.Curiosity_Submitted_Date__c=DateTime.now();
                contactItr.Log_Status__c = 'New Curiosity';
                contactItr.Stages__c = 'Curiosity Sent';
                contactItr.Meeting_Done__c = false;
                contactItr.Interaction_Done__c=false;
                contactItr.On_Hold__c=false;
                contactItr.Interested__c = false; 
                setOfLeadIds.add(contactItr.Lead_ID__c);
            }
            Update conList;
            system.debug('setOfLeadIds ' + setOfLeadIds);
            if(setOfLeadIds!=null){
                Lead ld = new Lead();
                if(!Test.isRunningTest()){ld=[Select Id,Lead_ID__c From Lead Where Lead_ID__c IN:setOfLeadIds limit 1];}
                system.debug('Send_CuriosityFormLink_SingleEmail ' + ld);
                if(ld!=null){
                        ld.Stage__c='Curiosity Sent';
                    if(!Test.isRunningTest()){update ld;}
                }
            }
            system.debug('The email was sent successfully.');
        } else{
            system.debug('The email failed to send: ' + results[0].getErrors()[0].getMessage());
            ret = false;
        }
        
        return ret;
    }
}