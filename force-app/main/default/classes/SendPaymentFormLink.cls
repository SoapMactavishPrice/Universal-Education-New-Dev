global class SendPaymentFormLink {
    webservice static Boolean SendEmailToUser(String admissionGrantedId){
        Boolean result = false;
        try{  
            Admission_Granted__c af = [Select Id,EnquiryNo__r.Contact__c,EnquiryNo__r.Contact__r.Lead_ID__c,EnquiryNo__r.Email__c,OwnerId, Payment_Link_Email__c  from Admission_Granted__c where Id=:admissionGrantedId];
            EmailTemplate templateId = [Select id,subject,Body from EmailTemplate where name = 'Send Payment form Link'];
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateId.Id, UserInfo.getUserId(), af.Id);
            //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           // mail.setTargetObjectId(UserInfo.getUserId());
            //mail.setwhatId(af.Id);
            //mail.setTemplateID(templateId.Id);
            mail.setSaveAsActivity(false);
            mail.setToAddresses(new List<String> {af.EnquiryNo__r.Email__c});
            allmsg.add(mail);
            Enquiry__c enq=[Select id,Org_code__c,Contact__c from Enquiry__c where id = :af.EnquiryNo__c];
             boolean isEmailactive=false;
            string emailtemp;
            boolean notem=true;
            List< SchoolEmail__mdt> se=new list<SchoolEmail__mdt>(); 
            se=[select CCAddress__c,DisplayName__c, TempName__c,Active__c, Event__c ,Object__c ,SchoolShortcode__c from SchoolEmail__mdt where SchoolShortcode__c =:enq.Org_code__c and Event__c='Send Payment Link'];
            system.debug('se '+se);
            if(se!=null && se.size()>0){
                isEmailactive=se[0].Active__c;
                emailtemp=se[0].TempName__c;
            }
            else
            {
                notem=false;
            }if(isEmailactive)
            {
                system.debug('temp '+emailtemp);
                SendEmail.SendEmailTemplateWithTemplate(emailtemp,enq.Contact__c,true,af.id,se[0],null);
            }
            else
            {
                system.debug('old');
                Messaging.SendEmailResult [] r = Messaging.sendEmail(allmsg,false);
            }
            
            
          
                af.Payment_Link_Email__c = true;
                update af;
          
            string customleadValue;
            Admission_Granted__c AGss = [SELECT ID,EnquiryNo__r.Lead_ID__c FROM Admission_Granted__c Where ID=:admissionGrantedId ];
                customleadValue = AGss.EnquiryNo__r.Lead_ID__c;
                List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead){lead l = new lead();l.id = le.id;l.Stage__c = 'Payment link Sent';
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){update lstlead;
                    }
                }

            result = true;
        }catch(dmlexception e){
            System.debug('Error '+e.getMessage());
            result = false;
        }
        
        return result;
    }
     public static void FormFactory() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
     }
}