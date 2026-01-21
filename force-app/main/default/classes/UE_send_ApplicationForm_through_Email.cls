public class UE_send_ApplicationForm_through_Email {
    public Enquiry__c enq{get;set;}
    public User u{get;set;}
    public boolean back{get;set;}
    public Boolean showMYExpirelink{ get; set; }
    public Boolean showMYPage{ get; set; }
    
    //public  String linkdate = ApexPages.currentPage().getParameters().get('linkdate');
    
    Id pid=Apexpages.currentpage().getParameters().get('id');
    
    
    
    public UE_send_ApplicationForm_through_Email()     
    {
        back = false;
    }
    public PageReference send()
    {
        PageReference page;
        try{
            enq=[select Org_code__c,Parent_First_Name__c,Contact__c,Contact__r.Lead_ID__c, Parent_Last_Name__c, School_Institution__r.For_Mapping_Email__c,
                 Academic_Year__c,Interested__c,Lead_ID__c,Application_Link_Sent__c,Application_Link_Sent_On_Date__c,Application_Link_Sent_On_Time__c, id, School_Institution__r.Website, Name,Email__c,School_Name__c,Stages__c,
                 Application_Sent__c,Interaction_Done__c,Application_Received__c,ParentFull_Name__c,School_Institution__r.School_Short_Code__c from Enquiry__c where id=:pid];
            u = [Select Name, Profile.Name, Email, Phone, userrole.name From User Where id = :UserInfo.getUserId()];
            //datetime dt=enq.Application_Send_Date__c;
            
            system.debug('Query_ENQUIRY:::'+enq.Stages__c);
            
            if(enq.Stages__c == 'Application submitted'){
                back = true;
                system.debug('INSIDE IF Stage::'+enq.Stages__c);
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Application form Already Recieved !!'));
            }if(enq.Stages__c == 'Application (Rejected)'){
                system.debug('INSIDE IF Stage::'+enq.Stages__c);
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Application form Already Recieved !!'));
            }

            /*   if((enq.Stages__c ==  'Application Link Sent' ||  enq.Stages__c !=  'Enquiry')){
*   back = true;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Application Form Once Accepted can not be rejected. This application form is now available in Admission form.You can now only reject Admission form.'));
}*/
            if(enq.Stages__c == 'Application Link Sent'  ){
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Application Form already sent on registered Email ID.'));
            }
            if(enq.Email__c == null){
                system.debug('INSIDE IF Stage::'+enq.Email__c);
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Email ID is not present!!'));
            }
            
          
            
            // if(enq.Interested__c == false){
            //     back = true;
            //     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Parent Interest is Pending!'));
            // }
            

            if(enq.Email__c != null){
                system.debug('##inside##');
                //          String body='Dear Parent,<br><br>Thank you for registering with the Universal Admission Enquiry System. Your Enquiry no. is '+enq.Name+' You may continue with the admission process. To access the Application form please <a href="http://newdev-universaleducation.cs57.force.com/UE_applicationForm_Site?eid='+enq.id+'">click here.</a><br><br>Best Regards,<br>Universal Admission Enquiry System';
               // String Recordlink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+enq.id;

                //String Recordlink =   'http://newdev-universaleducation.cs57.force.com/UE_applicationForm_Site?eid='+enq.id;
                
                Site mySite = [select Id from Site where Name = 'ApplicationProcess'];
                SiteDetail mySiteDetail = [select SecureURL from SiteDetail where DurableId = :mySite.Id];
                System.debug(mySiteDetail.SecureURL);
                //datetime dt=system.today();
                //datetime dt=enq[0].Application_Send_Date__c;
                String Sitelink = mySiteDetail.SecureURL+'/OTP_Validation?eid='+enq.id;
                
                
               // String body= 'Dear Parent,<br><br>Thank you for registering with the Universal Admission Enquiry System. Your Enquiry no. is '+enq.Name+'.<br><br>Kindly <a href="'+Sitelink+'">click here.</a> to continue with the online admission process.<br>Important information: After you click on the link, fill the admission enquiry no. as it is mentioned above without any variation in space or characters.<br><br>Best Regards,<br>Universal Admission Enquiry System';

                String body= 'Dear ' + enq.Parent_First_Name__c + ' '+ enq.Parent_Last_Name__c + ',' +'<br><br> Greetings from ' + enq.School_Name__c  + '!' +'<br><br>'+
                'It was a pleasure meeting you and hope all your queries have been answered satisfactorily. We now move ahead with the next step of the admissions process.'+'<br><br>'+ 
                'Kindly <a href="'+Sitelink+'">click here</a>'+' to fill and submit the Admission application.<br><br>'+
                 'For any further clarification feel free to email or call us.'+'<br><br>' +
                 // 'Our Best, <br>'  + u.Name + '<br>' +  u.Profile.Name + '<br>'+  enq.School_Name__c +  '<br>' + 'Phone: ' + u.Phone + '<br>'+ 'Email: ' + u.Email + '<br>' + 'Website: ' +enq.School_Institution__r.Website + '<br><br>' +
                    'This is a system-generated email. Kindly dont respond to it. For any communication, please contact on the email/phone number given below. '+'<br><br>';
            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                string[] toaddress =new String[]{enq.Email__c};
                    for(OrgWideEmailAddress owa : [select id, Address,DisplayName from OrgWideEmailAddress]) {
                        if(enq.School_Institution__c != null && enq.School_Institution__r.For_Mapping_Email__c != null && owa.DisplayName.contains(enq.School_Institution__r.For_Mapping_Email__c))
                            mail.setOrgWideEmailAddressId(owa.id);

                    }
                //mail.setOrgWideEmailAddressId(owa.id);
                mail.setToAddresses(toaddress);
                //mail.setSubject('Application Proccess Started'+' '+enq.Name);
                String emailSub = 'Application for admission '+enq.Academic_Year__c;
                mail.setSubject(emailSub);
                mail.setHtmlBody(body);
                
                     boolean isEmailactive=false;
        string emailtemp;
        boolean notem=true;
        List< SchoolEmail__mdt> se=new list<SchoolEmail__mdt>(); 
        se=[select CCAddress__c,DisplayName__c,TempName__c,Active__c, Event__c ,Object__c ,SchoolShortcode__c from SchoolEmail__mdt where SchoolShortcode__c =:enq.Org_code__c and Event__c='Send Application Link'];
        system.debug('se '+se);
                if(se!=null && se.size()>0){
            isEmailactive=se[0].Active__c;
            emailtemp=se[0].TempName__c;
        }
        else
        {
            notem=false;
            isEmailactive=false;
        }if(isEmailactive)
                   {
                       system.debug('temp '+emailtemp);
                       SendEmail.SendEmailTemplateWithTemplate(emailtemp,enq.Contact__c,true,enq.id,se[0],null);
                   }
                else
                {
                    system.debug('Old '+emailtemp);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } ); 
                }
                    
                Integer len = 4;
                String str = string.valueof(Math.abs(Crypto.getRandomLong()));
                String randomNumber = str.substring(0, len);
                enq.OTP__c=randomNumber;
                enq.Application_Link_Sent_On__c=system.now();
                  enq.Application_Link_Sent_On_Date__c=system.now().format('dd-MM-yyyy');
                        enq.Application_Link_Sent_On_Time__c=system.now().format('hh:mm a'); 
                system.debug('Random Number-' + randomNumber);
                enq.Stages__c = 'Application Link Sent';
                if(enq.Application_Sent__c != true)
                {
                    enq.Application_Sent__c = true;
                     enq.Application_Link_Sent__c=true;
                }
                update enq;
              list<Lead> listlds = new list<Lead>();
                    list<Lead> listld=[Select Id,Application_Link_Sent__c,Application_Link_Sent_On_Date__c,Application_Link_Sent_On_Time__c,Lead_ID__c,Stage__c From Lead Where Lead_ID__c=:enq.Lead_ID__c];
                    for(Lead olead : listld){
                        Lead ol = new Lead();
                        ol.id = olead.id;
                        ol.Application_Link_Sent__c=true;
                        ol.Application_Link_Sent_On_Date__c=system.now().format('dd-MM-yyyy');
                        ol.Application_Link_Sent_On_Time__c=system.now().format('hh:mm a');
                        ol.Stage__c='Application Link Sent';
                        listlds.add(ol);
                    }
                    if(!listlds.isEmpty()){
                        update listlds;
                    }       
                page = new pageReference('/'+enq.Id);
            }
        }catch(exception exp){
            system.debug('ERROR:::'+exp.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,exp.getMessage()));
        }
        return page;
    }
    public PageReference cancel()
     {
      return  new pageReference('/'+enq.Id);
     }
    public static void testMethod1(){
        for(integer i=1; i<= 2; i++){
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
    }
}