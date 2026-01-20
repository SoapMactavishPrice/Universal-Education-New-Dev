public class SendEmailForMeeting {
    public Static String sendEmailMeetingToParent(List <String> contactEmail,String eventId,String enqNo,String templateName){
      String HtmlValue = '';
        if(contactEmail != NUll){
            User u = [Select Id, Name, Profile.Name, Phone, Email From User where id = :userinfo.getUserId()];
             
           
            
            System.debug('-=-=-'+contactEmail+'-=-=-='+eventId+'-=-=-=-'+enqNo+'-=-=-'+templateName);
            List<Event> e = [SELECT Id, StartDateTime, EndDateTime,Contact__r.Name,Contact__r.FirstName,Contact__r.LastName,
                            Contact__r.Account.Name, School_Institution__r.BillingState, School_Institution__r.BillingStreet, School_Institution__r.BillingCity,
                             School_Institution__r.BillingCountry, School_Institution__r.BillingPostalCode, School_Institution__r.Name, School_Institution__r.Website,School_Institution__r.Social_Network_Link__c, School_Institution__r.For_Mapping_Email__c,
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

            for(OrgWideEmailAddress owa : [SELECT Id, Address,DisplayName from OrgWideEmailAddress]) {
               // if(owa.DisplayName.contains(orgwideContains)){
               if(owa.DisplayName.contains(e[0].School_Institution__r.For_Mapping_Email__c)){
                   System.debug('-=-=--='+e[0].Contact__r.Account.Name);
                   System.debug('-=-=--='+e[0].School_Institution__r.Name);
                    System.debug('-=-=--='+owa.DisplayName.substring(0,4));
                    System.debug('-=-=-=-=+++-=--=-=-='+owa.id+'-=-=-=-=-'+owa);
                    mail.setOrgWideEmailAddressId(owa.id);
                }
            }
            List<String> slmdtLst = new List<String>();
            System.debug('=== templateList[0].Subject =='+templateList[0].Subject);
            String subject = templateList[0].Subject;
            subject = subject.replace('{!Event.Subject}', e[0].Subject);
            System.debug('@@@@@@@@@@@@@@@@@@@@@@  subject  @@@@@@@@@@@@@');
            mail.setSubject(subject);
            System.debug('=====');
            HtmlValue = templateList[0].Body;

            //mail.setTargetObjectId(UserInfo.getUserId());
            String startDate = e[0].StartDateTime.format('dd/MM/yyyy-hh:mm a');
            String endDate =  e[0].EndDateTime.format('dd/MM/yyyy-hh:mm a');
            List<String> startDateList = startDate.split('-');
            List<String> endDateList = endDate.split('-');
            HtmlValue = HtmlValue.replace('{!Contact.Account}', e[0].School_Institution__r.Name);
            HtmlValue = HtmlValue.replace('{!Event.StartDateTime}', startDateList[0]+' at '+startDateList[1]);
            HtmlValue = HtmlValue.replace('{!Event.EndDateTime}',endDateList[0]+' at '+endDateList[1]);
            if(e[0].Contact__r.Name!=null){
            HtmlValue = HtmlValue.replace('{!Contact.Name}', e[0].Contact__r.Name);
            }
            HtmlValue = HtmlValue.replace('{!User.Name}', u.Name);
            HtmlValue = HtmlValue.replace('{!User.Email}', u.Email);
            HtmlValue = HtmlValue.replace('{!User.Phone}', u.Phone);
            HtmlValue = HtmlValue.replace('{!User.Profile}', u.Profile.Name);           
            HtmlValue = HtmlValue.replace('{!Account.Name}',e[0].School_Institution__r.Name );
            HtmlValue = HtmlValue.replace('{!Account.Website}',e[0].School_Institution__r.Website);
            HtmlValue = HtmlValue.replace('{!Account.BillingStreet}' ,e[0].School_Institution__r.BillingStreet);
            HtmlValue = HtmlValue.replace('{!Account.BillingState}' ,e[0].School_Institution__r.BillingState);
            HtmlValue = HtmlValue.replace('{!Account.BillingCity}' ,e[0].School_Institution__r.BillingCity);
            HtmlValue = HtmlValue.replace('{!Account.BillingCountry}' ,e[0].School_Institution__r.BillingCountry);
            HtmlValue = HtmlValue.replace('{!Account.BillingPostalCode}' ,e[0].School_Institution__r.BillingPostalCode);
            if(e[0].School_Institution__r.Social_Network_Link__c != null){
                 HtmlValue = HtmlValue.replace('{!Account.Social_Network_Link__c}',e[0].School_Institution__r.Social_Network_Link__c );
            }
           
           if(e[0].Contact__r.LastName!=null)
           {
               HtmlValue = HtmlValue.replace('{!Contact.LastName}', e[0].Contact__r.LastName);
           }
            if(e[0].Contact__r.FirstName!=null)
           {
               HtmlValue = HtmlValue.replace('{!Contact.FirstName}', e[0].Contact__r.FirstName);
           }
           
            HtmlValue = HtmlValue.replace('{!Enquiry__c.Name}', enqNo);
            
            //mail.setTemplateId(templateList[0].Id);
            String emailPlainTextBody = 'Dear '+e[0].Contact__r.Name+',Greetings,A school visit has been Scheduled online between'
                +''+startDateList[0]+' at '+startDateList[1]+'to '+endDateList[0]+' at '+endDateList[1]+'.Looking forward to meeting you.';
            mail.setHtmlBody(HtmlValue);
            mail.setToAddresses(contactEmail);
           // mail.setPlainTextBody(emailPlainTextBody1);
            System.debug('-=-=   contactEmail -=-='+contactEmail);
            mail.setSaveAsActivity(false);
            Messaging.SendEmailResult[] erList = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            System.debug('-=-= erList -=-='+erList);
            for(Messaging.SendEmailResult emailResultObj : erList){
                if (emailResultObj.isSuccess()) {
                    system.debug('The email was sent successfully.');
                    return emailPlainTextBody;
                } else {
                    system.debug('The email failed to send: '  + emailResultObj.getErrors()[0].getMessage());
                }
            }

        }
        return null;
    }

}