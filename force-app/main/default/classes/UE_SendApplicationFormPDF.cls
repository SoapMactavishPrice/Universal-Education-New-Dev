public without sharing class UE_SendApplicationFormPDF {
    
    Public Enquiry__c enq{get;set;}
    public Account acc{get;set;}
    public Application_Form__c form{get;set;}
    public LIST<Application_Form__c> Afd{get;set;}
    public boolean editMode{get;set;}
    public static blob b;
    
    public Id pid=Apexpages.currentpage().getParameters().get('id');
    public UE_SendApplicationFormPDF(){
        
    }
    public PageReference Send(){
        system.debug('APPLICATION_ID::::::'+pid);
        
        form = [SELECT Academic_Year__c,Address__c,Adhaar_Card_No__c,Father_Annual_Income__c,Mother_Anual_Income__c,State__c,City__c,Country__c,Pincode__c,
                Application_Form_Declaration__c,Name,Birth_Place__c,Blood_Group__c,Father_Business_Address__c,
                Mother_Business_Address__c,Father_Business_Contact__c,Mother_Business_Contact__c,Category__c,Count__c,
                Do_have_another_child_with_us__c,Email_Address__c,Guardian_Email_ID__c,Enquiry__c,Enquiry_Number__c,
                Expiry_Date__c,First_Name__c,Father_Datail_captured__c,Father_Email_Id__c,Father_Last_Name__c,Father_Occupation__c,
                Father_Phone__c,Father_Qualification__c,Mother_First_Name__c,Father_First_Name__c,Having_Children__c,
                Mother_Last_Name__c,Last_Name__c,Guardian_Mobile_No__c,Mobile_Number__c,Mother_Detail_Captured__c,
                Mother_Email_Id__c,Mother_Occupation__c,Mother_Phone__c,Mother_Qualification__c,Mother_Tongue__c,
                Guardian_Name__c,Father_Name_of_Organisation__c,Mother_Name_of_Organisation__c,Nationality__c,Passport_No__c,
                Reason_of_this_School__c,Relationship__c,Religion__c,Residence_No__c,School_Short_Code__c,School_Institution__c,School_Name__c,		
                Seeking_Admission_for_another_Child__c,StudentLast_Name__c,Seeking_Admission_in_Grade__c,Student_Name__c, CreatedDate FROM Application_Form__c where id=: pid ];
        system.debug('APPLICATION RECORD::::'+form);
        
        enq = [Select id,Date_of_Birth__c,FirstName__c,Last_Name__c,Name,Gender__c,Enq_School_Institute__c,Grade__c  from Enquiry__c where id =: form.Enquiry__c];
        System.debug('Enquiry+++'+enq);
        
        acc = [select id,Name,BillingAddress,BillingCity,BillingCountry,BillingGeocodeAccuracy,
               BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStreet,School_Email__c FROM Account where id=: form.School_Institution__c];
        system.debug('ACCOUNT:::::'+acc);
        
        PageReference pdf =new PageReference('/apex/ApplicationformPDF?id='+pid);
        
        //System.debug('PDF:::::'+pdf.getContent());
        pdf.setRedirect(true);
        
        if(Test.isRunningTest()){
            //b = pdf.getContent();
            b = Test.isRunningTest() ? Blob.valueOf('Test') : pdf.getContent();
        } 
        system.debug('Check Content'+b);
        //--------create a mail object to send a single email.--------
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        string[] Bccaddress =String.valueOf(form.Email_Address__c).Split(',');
        system.debug('@@@@@@@@@@@@@@@@@@@@@@'+Bccaddress);
        
        mail.setBccAddresses(Bccaddress);
        
        mail.setBccSender(true);
        //mail.setSenderDisplayName(qt.Account_Name__c);
        
        mail.setSubject('Application Form Number : '+form.Name);
        
        //------------- Create the email attachment-----------------
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(form.Name+'.pdf');
        efa.setBody(b);
        system.debug('SIZEOFAttACHMENT'+efa);
        //-----------------------------------------------------------
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        system.debug('$$$$$$$'+efa);
        
        
        String emailBody = 'Dear Parents,<br><br>We are in receipt of your Application Form A No. '+form.Name+'.<br><br>Kindly <a href="https://drive.google.com/drive/folders/0BytcqackBE1jRmZZVEp5eDZuVm8">click here.</a> to access the other forms<br><br>Please take prints of Forms A to E and fill them in CAPITAL LETTERS ONLY. Submit them along with the photocopies of necessary documents mentioned below within 3 working days, either at the school office or scan and send an email (email id mentioned below) with the subject mentioned as Application Form No.'+form.Name+'.<br>List of documents to be annexed along with duly filled Application Forms.<br><br>All documents are to be attested by either of the parent/guardian. Please carry original documents for verification.<br><br>1. A recent photograph of the child & parents/guardian has to be pasted on the Application Form A. (Size: 3.5 cm × 4.5 cm as per Schengen – Europe Visa norms).<br>2. Photocopy of the Birth certificate ( if not in English, kindly get it translated in English by an approved translator).<br>3. Photocopy of Child’s Aadhaar Card<br>4. Photocopy of Parent’s Aadhaar Card<br>5. Photocopy of the latest report card (if applicable)<br>6. Photocopy of the child’s valid passport and visa pages if the child is a foreign national.<br><br>Should you have any queries please feel free to contact us.<br><br>For security reasons, all visitors are required to carry a government-issued photo ID for entry into the school premises.';
        
        for(OrgWideEmailAddress owa : [select id, Address,DisplayName from OrgWideEmailAddress]) {
            if(owa.DisplayName.contains('Universal'))
                mail.setOrgWideEmailAddressId(owa.id);
            
        }
        
        // mail.setPlainTextBody(emailBody);
        mail.setHtmlBody(emailBody);
        //------------------------Attach sales order to a contract--------------------
        Attachment formAttach = new Attachment();
        formAttach.Name = form.Name+'.pdf';
        formAttach.body = b;
        formAttach.ContentType='application/pdf';
        formAttach.parentId =pid;
        
        if (!Test.isRunningTest())
        {
            insert formAttach;
            
        }
        //send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );
        
        return new pageReference('/'+form.id);
    }
    
    
    
    @future(callout=true)
    Public Static void sendPDF(String recID){
        Application_form__c form1 = [select id,Name,Email_Address__c,School_Form_Links__c,School_Institution__c,
                                     School_Email_ID__c,Enquiry__c,School_Social_Link__c,School_Contact_No__c,School_Website__c 
                                     from Application_form__c where id =: recID];                
        
        Enquiry__c enq = [Select id,Date_of_Birth__c,FirstName__c,Last_Name__c,Name,Gender__c,Enq_School_Institute__c,Grade__c  
                          from Enquiry__c where id =: form1.Enquiry__c];
        System.debug('Enquiry+++'+enq);
        
        Account acc = [select id,Name,BillingAddress,BillingCity,BillingCountry,BillingGeocodeAccuracy,
                       BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStreet,School_Email__c
                       FROM Account where id=: form1.School_Institution__c];
        system.debug('ACCOUNT:::::'+acc);
        //'.<br><br>Kindly <a href="https://drive.google.com/drive/folders/0BytcqackBE1jRmZZVEp5eDZuVm8">click here.</a>'+
        
        String emailBody = 'Dear Parents,<br><br>We are in receipt of your Application Form A No. '+form1.Name+
             ' to access the other forms<br><br>Please take prints of Forms A '+
            ' Submit them along with the photocopies of necessary documents mentioned below within 3 working days, either '+
            'at the school office or scan and send an email (email id mentioned below) with the subject mentioned as Application Form No. '+form1.Name+
            '.<br>List of documents to be annexed along with duly filled Application Forms.<br><br>All documents are to be attested by either of the parent/guardian. '+
            'Please carry original documents for verification.<br><br>1. A recent photograph of the child & parents/guardian has to be pasted on the Application Form A. '+
            '(Size: 3.5 cm × 4.5 cm as per Schengen – Europe Visa norms).<br>2. Photocopy of the Birth certificate ( if not in English, kindly get it translated in English by an approved translator).<br>3. '+
            'Photocopy of Child’s Aadhaar Card<br>4. Photocopy of Parent’s Aadhaar Card<br>5. Photocopy of the latest report card (if applicable)<br>6. Photocopy of the child’s valid passport and visa pages '+
            'if the child is a foreign national.<br><br>Should you have any queries please feel free to contact us.<br><br>For security reasons, all visitors are required to carry a government-issued photo ID '+
            'for entry into the school premises.<br><br>Our Best<br>Authorised Personnel<br><br>Contact No : '+form1.School_Contact_No__c+'<br>Email : '+form1.School_Email_ID__c+'<br>Website : <a href="'+form1.School_Website__c+
            '">'+form1.School_Website__c+'</a><br>Facebook : <a href="'+form1.School_Social_Link__c+'">'+form1.School_Social_Link__c+'</a>';
        
        Site mySite = [select Id from Site where Name = 'ApplicationProcess'];
		SiteDetail mySiteDetail = [select SecureURL from SiteDetail where DurableId = :mySite.Id];
        PageReference pdf1 =  new pageReference(mySiteDetail.SecureURL+'/ApplicationformPDF?id='+form1.Id);//Page.ApplicationformPDF;
        pdf1.getParameters().put('id',form1.Id);
        // Take the PDF content
        // if (!Test.isRunningTest()){
        // b = Test.isRunningTest() ? Blob.valueOf('Test') : pdf.getContent();
        Blob b = Test.isRunningTest()? Blob.valueOf('Test') : pdf1.getContent();
        //}
        
       	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        string[] Bccaddress =String.valueOf(form1.Email_Address__c).Split(',');
        system.debug('EmailID::'+Bccaddress);
        mail.setBccAddresses(Bccaddress);
        mail.setBccSender(true);
        mail.setSubject('Confirmation: Application Form Number : '+form1.Name);
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(form1.Name+'.pdf');
        efa.setBody(b);
        
        system.debug('SIZEOFAttACHMENT'+efa);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        for(OrgWideEmailAddress owa : [select id, Address,DisplayName from OrgWideEmailAddress]) {
            if(owa.DisplayName.contains('Universal'))
                mail.setOrgWideEmailAddressId(owa.id);
            
        }
        
        mail.setHtmlBody(emailBody);
        //------------------------Attach Application PDF to Respective to record--------------------
        //Attachment formAttach = new Attachment();
        //formAttach.Name = form1.Name+'.pdf';
        //formAttach.body = b;
        //formAttach.ContentType='application/pdf';
        //formAttach.parentId =form1.Id;
        
        if (!Test.isRunningTest())
            
            // insert formAttach;
            //send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );
        
        
        //------end here-------------------------------
    }
    
    
}