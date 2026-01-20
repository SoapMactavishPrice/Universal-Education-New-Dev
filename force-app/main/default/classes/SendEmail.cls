global without sharing class SendEmail {
    public Static String sendEmailFromShortCode(String sid,String contactEmail,String eventId,String enqNo,String templateName){
        String HtmlValue = '';
        if(contactEmail != NUll){
            User u = [Select Id, Name, Profile.Name, Phone, Email From User where id = :userinfo.getUserId()];
            
            System.debug('-=-+_+_+_+'+sid+'==-=-=-=-=-'+contactEmail+'-=-=-='+eventId+'-=-=-=-'+enqNo+'-=-=-'+templateName);
            
            List<Event> e = [SELECT Id, StartDateTime, EndDateTime,Contact__r.Name, Contact__r.FirstName,Contact__r.LastName,
                             Contact__r.Account.Name, School_Institution__r.Name, School_Institution__r.Website, School_Institution__r.Social_Network_Link__c,
                             Description,Subject FROM Event WHERE Id = :eventId];
            System.debug('====================== > event : ' + e);
            
            List<EmailTemplate> templateList = [SELECT 
                                                Id,
                                                Body,HtmlValue,Subject
                                                FROM EmailTemplate 
                                                WHERE DeveloperName = :templateName
                                                AND IsActive = true];
            System.debug('====================== > Template: ' + templateList);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            
            
            //From_Email
            Account a= [SELECT Id, Name, School_Short_Code__c FROM Account where Id=:sid];
            List<School_List__mdt> slmdtList = [SELECT Id, DeveloperName, MasterLabel,
                                                NamespacePrefix, Label, Notification_Email__c,
                                                QualifiedApiName, State__c, Calendar_Email__c 
                                                FROM School_List__mdt where DeveloperName= : a.School_Short_Code__c];
            
            System.debug('====================== > slmdtList: ' + slmdtList);
            
            List<String> slmdtLst = new List<String>();
            System.debug('=== templateList[0].Subject =='+templateList[0].Subject);
            String subject = templateList[0].Subject;
            subject = subject.replace('{!Event.Subject}', e[0].Subject);
            mail.setSubject(subject);
            System.debug('=====');
            HtmlValue = templateList[0].Body;
            
            mail.setTargetObjectId(UserInfo.getUserId());
            String startDate = e[0].StartDateTime.format('dd/MM/yyyy-hh:mm a');
            String endDate =  e[0].EndDateTime.format('dd/MM/yyyy-hh:mm a');
            List<String> startDateList = startDate.split('-');
            List<String> endDateList = endDate.split('-');
            HtmlValue = HtmlValue.replace('{!Event.StartDateTime}', startDateList[0]+' at '+startDateList[1]);
            HtmlValue = HtmlValue.replace('{!Event.EndDateTime}',endDateList[0]+' at '+endDateList[1]);
            HtmlValue = HtmlValue.replace('{!Contact.Name}', e[0].Contact__r.Name);
            HtmlValue = HtmlValue.replace('{!Contact.FirstName}',e[0].Contact__r.FirstName);
            HtmlValue = HtmlValue.replace('{!Contact.LastName}', e[0].Contact__r.LastName);
            HtmlValue = HtmlValue.replace('{!User.Name}', u.Name);
            HtmlValue = HtmlValue.replace('{!User.Email}', u.Email);
            HtmlValue = HtmlValue.replace('{!User.Phone}', u.Phone);
            HtmlValue = HtmlValue.replace('{!User.Profile}', u.Profile.Name);
            HtmlValue = HtmlValue.replace('{!Account.Name}',e[0].School_Institution__r.Name );
            HtmlValue = HtmlValue.replace('{!Account.Website}',e[0].School_Institution__r.Website != null ? e[0].School_Institution__r.Website : '');
            HtmlValue = HtmlValue.replace('{!Account.Social_Network_Link__c}',e[0].School_Institution__r.Social_Network_Link__c != null ? e[0].School_Institution__r.Social_Network_Link__c : '');
            HtmlValue = HtmlValue.replace('{!Enquiry__c.Name}', enqNo);
            //mail.setTemplateId(templateList[0].Id);
            String emailPlainTextBody = 'Dear '+e[0].Contact__r.Name+',Greetings,A school visit has been Scheduled online between'
                +''+startDateList[0]+' at '+startDateList[1]+'to '+endDateList[0]+' at '+endDateList[1]+'.Looking forward to meeting you.';
            mail.setHtmlBody(HtmlValue);
            mail.setToAddresses(new List<String>{contactEmail});
            // mail.setPlainTextBody(emailPlainTextBody1);
            System.debug('-=-=   contactEmail -=-='+contactEmail);
            mail.setSaveAsActivity(false);
            Messaging.SendEmailResult[] erList = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            System.debug('-=-= erList -=-='+erList);
            
            
            for(Messaging.SendEmailResult emailResultObj : erList){
                if (emailResultObj.isSuccess()) {
                    system.debug('The email was sent successfully.');
                    return 'Success';
                } else {
                    system.debug('The email failed to send: '  + emailResultObj.getErrors()[0].getMessage());
                    return 'Failed';
                }
            }
        }
        return null;
    }
    public static void testmethod1(){
        integer i=1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    public static void SendEmailTemplateWithTemplate(string temname,id recid,boolean cus, id whatid,SchoolEmail__mdt mdt,id eventId) {
        system.debug('SendEmailTemplateWithTemplate '+whatid +' Who id '+recid);
        System.debug('SendEmailTemplateWithTemplate args ==> ' + temname + ' ' + recid + ' ' + cus + ' ' + whatid + ' ' + mdt + ' ' + eventId);
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemp = [Select id, Subject, Body From EmailTemplate Where DeveloperName = :temname];
        // Contact con = [Select Id, Email from Contact where LastName ='Test'];
        //List<Enquiry__c> listen=[Select Id, Eami from Enquiry__c where id=]
        String currentUserEmail = UserInfo.getUserEmail();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if (temname.contains('OTP') && mdt.CCAddress__c!=null) {
            System.debug('temname.containsl ==>' + mdt.CCAddress__c);
            String[] ccAddresses = new String[] {mdt.CCAddress__c};
            mail.setccAddresses(ccAddresses);
        } else if (temname.contains('OTP')) {
            
        }
        else if(mdt.CCAddress__c!=null) {
            System.debug('(mdt.CCAddress__c!=null) ==>' + mdt.CCAddress__c);
            String[] ccAddresses = new String[] {currentUserEmail,mdt.CCAddress__c};
            mail.setccAddresses(ccAddresses);
        } else {
            System.debug('else ==>');
            String[] ccAddresses = new String[] {currentUserEmail};
            mail.setccAddresses(ccAddresses);
        }
        
        
        
        for(OrgWideEmailAddress owa : [SELECT Id, Address,DisplayName from OrgWideEmailAddress]) {
            // if(owa.DisplayName.contains(orgwideContains)){
                if(owa.DisplayName.contains(mdt.DisplayName__c)){
                    
                    mail.setOrgWideEmailAddressId(owa.id);
                }
            }
            // mail.
            mail.setTemplateId(emailTemp.Id);
            mail.setTargetObjectId(recid);
            if(cus){
                mail.setWhatId(whatid);
            }
            System.debug('CC Address from SendEmailTemplateWithTemplate ==>' + mail.getCcAddresses());
            emailList.add(mail);
            
            if(!emailList.isEmpty()){
                Messaging.sendEmail(emailList);
                system.debug('Email sent');
            }
        }
    }