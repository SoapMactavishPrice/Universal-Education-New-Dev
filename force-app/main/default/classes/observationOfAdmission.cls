public class observationOfAdmission {
    
    public Admission_Form__c af{get;set;}
    public list<Admission_Form__c> listform{get;set;}
    public list<Admission_Granted__c> listGrant{get;set;}
    public Admission_Granted__c ag{get;set;}
    public boolean msg{get;set;}
    public List<Application_form__c> aapList{get;set;}
    public List<Enquiry__c> enqList{get;set;}
    public List<Account> acc {get;set;}
    public List<Class__c> cls{get;set;}
    List<Enquiry__c> listEnq{get;set;}
    Id pid=Apexpages.currentpage().getParameters().get('id');
    public string Enquiryidvalue{get;set;}
    public string leadidvalue{get;set;}
    public observationOfAdmission(ApexPages.StandardController Controller){
        listEnq=new List<Enquiry__c>();
        Id pid=Apexpages.currentpage().getParameters().get('id');
        system.debug('ID::::'+pid);
        msg = True;
        
        
        af=[Select id,Emergency_Contact_No__c,Name,Academic__c,First_Name__c,Last_Name__c,Lead__c,Receipt_No__c,Document_Received__c,Called_for_Observation__c,
            Status__c,Enquiry_Number__c,Address__c,Adhaar_Card_No__c,fatherAnnualincome__c,motherAnnual_Income__c,Birth_Place__c,Observation_Re_scheduled__c,
            Blood_Group__c,Business_Address__c,motherBusiness_Address__c,fatherBusiness_Contact__c,motherBusiness_Contact__c,Application_Form__c,
            Category__c,Do_have_another_child_with_us__c,Email_Address__c,GuardianEmail_Id__c,GuardianMobile_No__c,GuardianName__c,Enquiry_No__c,
            Enquiry_No__r.Contact__r.Lead_ID__c,
            Expiry_Date__c,Father_Detail_Captured__c,Father_Email_Id__c,Father_Last_Name__c,Father_occupation__c,Father_Phone__c,
            Father_Qualification__c,FatherFirst_Name__c,fatherName_of_Organisation__c,Having_Children_from_same_joint_family__c,
            Mobile_Number__c,Mother_Detail_Captured__c,Mother_Email_Id__c,motherLast_Name__c,motherFirst_Name__c,Mother_Occupation__c,
            Mother_Phone__c,Mother_Qualification__c,Mother_Tongue__c,motherName_of_Organisation__c,Nationality__c,PassPort_No__c,
            Reason_of_this_School__c,Relationship__c,Religion__c,Residence_No__c,School_Institution__c,Student_Name__c,Student_Type__c,
            Seeking_Admission_for_another_Child__c,School_Short_Code__c,Registration_Date__c,Application_No__c,
            Form_B_captured__c,Physical_disabilities__c,Other_Disabilities__c,
            Other_Medical_History__c,Allergies__c,Share_the_Allergies__c,Personalized_learning_needs__c,Personalized_learning_option__c,Enquiry_No__r.Contact__r.Lead__c,
            Other_Personalized_Option__c,Form_B_Acknowledgement__c,Disabilities_Types__c, seeking_grade__c, seeking_grade__r.name
            ,Enquiry_No__r.Lead_ID__c,Enquiry_No__r.name,Non_Stellar_Interaction_Done__c,Non_Stellar_Interaction_Scheduled__c,Non_Stellar_Attach_Interaction_Notes__c,Non_Stellar_Reject_After_Interaction__c,Non_Stellar_Document_Incomplete__c from Admission_Form__c where id=: pid ];
        
        system.debug('AdmissionForm_Record:::::'+af);
        Enquiryidvalue =af.Enquiry_No__c;
        leadidvalue =af.Enquiry_No__r.Lead_ID__c;
        acc = [Select id,Name from Account where id =: af.School_Institution__c Limit 1];
        system.debug('SCHOOL Name::'+acc[0].Name+' School ID :'+acc[0].Id);
        try{
            cls = [Select id,Name,School_Name__c from Class__c where School_Name__c =:acc[0].id AND id=:af.Seeking_Grade__c];
            system.debug('Class::'+cls[0].Name+' school'+cls[0].School_Name__c);
        }catch(Exception exp){
            system.debug('EROOR::'+exp.getMessage()+' ::LIne::'+exp.getLineNumber());
            system.debug('EROOR::'+exp.getCause());
        } 
        
        
    }
    
    public PageReference shortlistedForAdmission()
    {
        PageReference pg; 
        ag = new Admission_Granted__c(); 
        
       try{
            system.debug('Application'+ag);
            listGrant = [select id,Name,Admission_Form__c,Admission_Code__c,Status__c,Date_of_Admission__c,Confirmation_Date__c,Fee_Applicable_Date__c,Section__c,User_Id__c,Enrollment_No__c from Admission_Granted__c where Admission_Form__c=: af.Id];
            system.debug('list of Admission Granted::'+listGrant);
            
            
            
            if(listGrant.size()>0){
                system.debug('Admission Granted LIST(Inside IF) Size:::'+listGrant.size());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Admission already Granted!'));
                //msg=False;
            }
            If(af.Non_Stellar_Interaction_Scheduled__c ==False && af.Document_Received__c == False){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction-Scheduled and Documentation is Pending'));
                
                
            }
            If(af.Non_Stellar_Interaction_Scheduled__c ==true && af.Document_Received__c == False){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Documentation is Pending'));
                
                
            }
            
            If(af.Non_Stellar_Interaction_Scheduled__c ==True && listGrant.size()==0 && af.Document_Received__c == true){
                ag.Admission_Form__c = af.Id;
                ag.Application_Form__c = af.Application_Form__c;
                ag.EnquiryNo__c = af.Enquiry_No__c;
                if(af.lead__c != null){
                ag.Lead__c = af.lead__c;
                }else{
                   ag.Lead__c = af.Enquiry_No__r.Contact__r.Lead__c ;
                }
                ag.Academic_Year__c=af.Academic__c;
                ag.Address__c=af.Address__c;                
                ag.First_Name__c=af.First_Name__c;
                ag.Last_Name__c=af.Last_Name__c;
                ag.Receipt_No__c=af.Receipt_No__c;
                //ag.Status__c=af.Status__c;
                
                ag.Enquiry_Number__c=af.Enquiry_Number__c;
                ag.Adhaar_Card_No__c=af.Adhaar_Card_No__c;
                ag.father_Annual_Income__c=af.fatherAnnualincome__c;
                ag.mother_Annual_Income__c=af.motherAnnual_Income__c;
                ag.father_Business_Address__c=af.Business_Address__c;
                ag.mother_Business_Address__c=af.motherBusiness_Address__c;
                ag.father_Business_Contact__c=af.fatherBusiness_Contact__c;
                ag.mother_Business_Contact__c=af.motherBusiness_Contact__c;
                ag.father_Email_Id__c=af.Father_Email_Id__c;
                ag.mother_Email_Id__c=af.Mother_Email_Id__c;
                ag.Father_First_Name__c=af.FatherFirst_Name__c;
                ag.Father_Last_Name__c=af.Father_Last_Name__c;
                ag.mother_First_Name__c=af.motherFirst_Name__c;
                ag.mother_Last_Name__c=af.motherLast_Name__c;
                ag.father_Mobile_No__c=af.Father_Phone__c;
                ag.father_Name_of_Organisation__c=af.fatherName_of_Organisation__c;
                ag.mother_Mobile_No__c=af.Mother_Phone__c;
                ag.mother_Name_of_Organisation__c=af.motherName_of_Organisation__c;
                ag.father_Occupation__c=af.Father_occupation__c;
                ag.father_Qualification__c=af.Father_Qualification__c;
                ag.mother_Occupation__c=af.Mother_Occupation__c;
                ag.mother_Qualification__c=af.Mother_Qualification__c;
                ag.Mother_Tongue__c=af.Mother_Tongue__c;
                ag.Blood_Group__c=af.Blood_Group__c;
                ag.Birth_Place__c=af.Birth_Place__c;
                ag.Residence_No__c=af.Residence_No__c;
                ag.Registration_Date__c=af.Registration_Date__c;
                ag.Name=af.Name;
                ag.Relationship__c=af.Relationship__c;
                ag.Religion__c=af.Religion__c;
                ag.Category__c=af.Category__c;
                ag.guardianEmail_Id__c=af.GuardianEmail_Id__c;
                ag.GuardianName__c=af.GuardianName__c;
                ag.guardianMobile_No__c=af.GuardianMobile_No__c;
                ag.Nationality__c=af.Nationality__c;
                ag.Passport_No__c=af.PassPort_No__c;
                ag.Expiry_Date__c=af.Expiry_Date__c;
                ag.Email_Address__c=af.Email_Address__c;
                ag.School_Institution__c=af.School_Institution__c;
                ag.School_Short_Code__c=af.School_Short_Code__c;
                ag.Student_s_Name__c=af.Student_Name__c;
                ag.Student_Type__c=af.Student_Type__c;
                ag.Mobile_Number__c=af.Mobile_Number__c;
                ag.Emergency_Contact_No__c=af.Emergency_Contact_No__c;
                
                ag.Original_Document__c = 'Pending';
                ag.Application_No__c = af.Application_No__c;
                
                ag.Form_B_captured__c= af.Form_B_captured__c;
                ag.Physical_disabilities__c=af.Physical_disabilities__c;
                ag.Disabilities_Types__c=af.Disabilities_Types__c;
                ag.Other_Disabilities__c=af.Other_Disabilities__c;
                ag.Other_Medical_History__c=af.Other_Medical_History__c;
                ag.Allergies__c=af.Allergies__c;
                ag.Share_the_Allergies__c=af.Share_the_Allergies__c;
                ag.Personalized_learning_needs__c= af.Personalized_learning_needs__c;
                ag.Personalized_learning_option__c= af.Personalized_learning_option__c;
                ag.Other_Personalized_Option__c=af.Other_Personalized_Option__c;
                ag.Form_B_Acknowledgement__c= af.Form_B_Acknowledgement__c;
                ag.Grade_lookup__c = af.seeking_grade__c;
                //form.School_Short_Code__c = adf.SchoolShort_Code__c;
                //if(cls.size()>0){
                //ag.Grade_lookup__c = cls[0].id;
                // }
                // listGrant.add(ag);
                system.debug(' _+_+_+_+_+_ In side Observation page Enrollment_No__c-=-=-=-  ' + ag.Enrollment_No__c);
                
                
                
                // Stellar API for "Shortlisted for Admission"
                if(StellarAPICallouts.checkIfStellarAPIEnabled(af.School_Short_Code__c)){
                    String parentFirstName = String.isNotBlank(af.FatherFirst_Name__c) ? af.FatherFirst_Name__c : af.motherFirst_Name__c;
                    String parentLastName = String.isNotBlank(af.Father_Last_Name__c) ? af.Father_Last_Name__c : af.motherLast_Name__c;
                    Map<String, Object> dataMap = StellarAPICallouts.createBody(
                        new List<String>{'parentFirstname', 'parentLastname'},
                        new List<Object>{parentFirstName, parentLastName}
                    );
                    Map<String, Object> requestBody = StellarAPICallouts.createBody(
                        new List<String>{
                            'stage', 'status', 'email', 'data'
                                },
                        new List<Object>{
                            'SHORTLISTED', 'INTERACTION_DONE', af.Email_Address__c, dataMap
                                }
                    );
                    StellarAPICallouts.makeCallout('https://admission.stellarworldschool.com/leads', StellarAPICallouts.PUT_METHOD, requestBody);
                }
                
                insert ag;
                // system.debug('CLass::::::::'+ag.Grade_lookup__c);
                
                af.Status__c ='Shortlisted for Admission';
                update af;
                
                if(af.Enquiry_No__r!=null && af.Enquiry_No__r.Contact__r!=null && af.Enquiry_No__r.Contact__r.Lead_ID__c!=null){
                    Lead ld=[Select Id,Lead_ID__c,Stage__c From Lead Where Lead_ID__c=:af.Enquiry_No__r.Contact__r.Lead_ID__c];
                    ld.Stage__c='Shortlisted for Admission';
                    update ld;
                }
                
                
                aapList = [Select Id,Name,Status__c,Enquiry__c from Application_form__c where ID =:af.Application_Form__c Limit 1 ];
                system.debug('Application_Update_Status:::'+aapList[0].Status__c);
                Application_form__c app = new Application_form__c();
                app.id = aapList[0].ID;
                app.Status__c = 'Shortlisted';
                aapList.add(app);
                
                map<id,Application_form__c> appMap = new map<id,Application_form__c>();
                
                //put all the values from the list to map. 
                appMap.putall(aapList);
                if(appMap.size()>0){
                    update appMap.values();
                }
                Id devRecordTypeId = Schema.SObjectType.Enquiry__c.getRecordTypeInfosByName().get('Enquiry Locked').getRecordTypeId();
				system.debug('devRecordTypeId  ' + devRecordTypeId);
                enqList = [Select id,Name,Stages__c from Enquiry__c where id =: aapList[0].Enquiry__c Limit 1 ];
                system.debug('enqList:::'+enqList);
                Enquiry__c enq = new Enquiry__c();
                enq.id = enqList[0].id;
                //enq.RecordTypeId = devRecordTypeId;
                enq.Stages__c = 'Shortlisted';
                enqList.add(enq);
                
                map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();
                
                //put all the values from the list to map. 
                enqMap.putall(enqList);
                if(enqMap.size()>0){
                    update enqMap.values();
                }
                List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
                List<ContentDocumentLink> newCDLList = new List<ContentDocumentLink>();
                for(ContentDocumentLink cdl : [SELECT LinkedEntityId,ContentDocumentID FROM ContentDocumentLink WHERE LinkedEntityId=: af.Id]){
                    ContentDocumentLink newCDL = new ContentDocumentLink();
                    newCDL.LinkedEntityId = ag.id;
                    newCDL.ContentDocumentID = cdl.ContentDocumentID;
                    newCDLList.add(newCDL);
                    cdlList.add(cdl);
                }
                
                System.debug('newCDLList -> '+newCDLList);
                System.debug('cdlList -> '+cdlList);
                if(newCDLList.size()>0)
                    insert newCDLList;
                if(cdlList.size()>0)
                    delete cdlList;
                
                
                pg = new PageReference('/'+af.Id);
            }            
        }catch(Exception exp){
            pg = new PageReference('/'+af.Id);
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Something Went Wrong! Please inform to the Adminstrator!'));
            system.debug('WHILE INSERTION GETING EXCEPTION:::'+exp.getMessage());
            
        }
        return  pg;
    }
    
    public PageReference rejectedAfterObservation(){
        PageReference pg;
        Admission_Form__c adf = [SELECT id,Enquiry_No__r.name,Non_Stellar_Interaction_Scheduled__c,Non_Stellar_Interaction_Reschedule__c,Enquiry_No__c,Non_Stellar_Reject_After_Interaction__c,Enquiry_No__r.Lead_ID__c,Enquiry_No__r.Contact__c,Rejected_After_Interaction__c,Enquiry_No__r.Contact__r.Lead_ID__c,Name,Application_Form__c,Document_Received__c,Academic__c,Status__c,Called_for_Observation__c,Observation_Re_scheduled__c,School_Short_Code__c, School_Institution__r.School_Short_Code__c,FatherFirst_Name__c,Father_Last_Name__c,motherFirst_Name__c,motherLast_Name__c,Email_Address__c FROM Admission_Form__c WHERE id=: pid];
        
        listGrant = [select id,Name,Admission_Form__c,Admission_Code__c,Status__c,Date_of_Admission__c,Confirmation_Date__c,Fee_Applicable_Date__c,Section__c,User_Id__c,Enrollment_No__c from Admission_Granted__c where Admission_Form__c=: af.Id];
        system.debug('list of Admission Granted::'+listGrant);
        
        if(adf.Status__c =='Shortlisted for Admission' && listGrant.size()>0){
            system.debug('Admission Granted LIST(Inside IF) Size:::'+listGrant.size());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Admission already Granted!'));
            
        }
        
        /*   if(adf.Status__c =='Shortlisted for Admission' && listGrant.size()>0 ){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Admission form is already shortlisted you can not change the Reject the application.'));
}*/
        if(adf.Non_Stellar_Interaction_Scheduled__c == false && adf.Non_Stellar_Interaction_Reschedule__c ==false  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Observation is Pending! You can not reject the Form.'));  
        }
        
        if(adf.Non_Stellar_Interaction_Scheduled__c == true && adf.Status__c !='Shortlisted for Admission' ){
            adf.Status__c ='Rejected after Interaction';
            if(adf.Enquiry_No__r.name.Contains('ENQ')){
            	adf.Non_Stellar_Reject_After_Interaction__c = true;
            }else{
                adf.Rejected_After_Interaction__c = true;
            }
            /*if(adf.Enquiry_No__c!=null){
Lead ld=[Select Id,Lead_ID__c,Stage__c From Lead Where Lead_ID__c=:leadidvalue];
ld.Stage__c='Rejected After interaction';
update ld;
}*/
            
            // Stellar API for "Rejected After Observation"
            // School_Institution__r.School_Short_Code__c,FatherFirst_Name__c,Father_Last_Name__c,motherFirst_Name__c,motherLast_Name__c, Email_Address__c
            if(StellarAPICallouts.checkIfStellarAPIEnabled(adf.School_Short_Code__c)){
                String parentFirstName = String.isNotBlank(adf.FatherFirst_Name__c) ? adf.FatherFirst_Name__c : adf.motherFirst_Name__c;
                String parentLastName = String.isNotBlank(adf.Father_Last_Name__c) ? adf.Father_Last_Name__c : adf.motherLast_Name__c;
                Map<String, Object> dataMap = StellarAPICallouts.createBody(
                    new List<String>{'parentFirstname', 'parentLastname'},
                    new List<Object>{parentFirstName, parentLastName}
                );
                Map<String, Object> requestBody = StellarAPICallouts.createBody(
                    new List<String>{
                        'stage', 'status', 'email', 'data'
                            },
                    new List<Object>{
                        'OBSERVATION_REJECTED', 'INTERACTION_DONE', adf.Email_Address__c, dataMap
                            }
                );
                StellarAPICallouts.makeCallout('https://admission.stellarworldschool.com/leads', StellarAPICallouts.PUT_METHOD, requestBody);
            }
            System.debug('leadidvalue >> @@@ >>> ' + leadidvalue);
            if(!Test.isRunningTest()){
                Lead ld=[Select Id,Lead_ID__c,Stage__c From Lead Where Lead_ID__c=:leadidvalue];
                ld.Stage__c='Rejected After interaction';
                update ld;}
            update adf;            
            aapList = [Select Id,Name,Status__c,Enquiry__c from Application_form__c where ID =:adf.Application_Form__c Limit 1 ];
            system.debug('Application_Update_Status:::'+aapList[0].Status__c);
            Application_form__c app = new Application_form__c();
            app.id = aapList[0].ID;
            app.Status__c = 'Application Rejected';
            aapList.add(app);
            
            map<id,Application_form__c> appMap = new map<id,Application_form__c>();
            
            //put all the values from the list to map. 
            appMap.putall(aapList);
            if(appMap.size()>0){
                update appMap.values();
            }
            
            enqList = [Select id,Name,Stages__c from Enquiry__c where id =:Enquiryidvalue Limit 1 ];
            system.debug('enqList:::'+enqList);
            Enquiry__c enq = new Enquiry__c();
            enq.id = enqList[0].id;
            if(enqList[0].name.Contains('ENQ')){
            	enq.Non_Stellar_Reject_After_Interaction__c = true;
            }else{
                enq.Rejected_After_Interaction__c = true;
            }
            enq.Stages__c = 'Rejected After Interaction';
            enqList.add(enq);
            
            map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();
            
            //put all the values from the list to map. Observation Scheduled
            enqMap.putall(enqList);
            if(enqMap.size()>0){
                update enqMap.values();
            }
            
            
            
            system.debug('Application_Update_Status:::'+app.Status__c);
            pg = new PageReference('/'+adf.Id);
        }
        
        return pg;
    }
    
    public PageReference absentForObservation(){
        PageReference pg;
        Admission_Form__c adf1 = [Select id,Name,Academic__c,Absent_for_Interaction__c,Status__c,Application_Form__c,Called_for_Observation__c,Non_Stellar_Interaction_Scheduled__c,Observation_Re_scheduled__c,
                                  FatherFirst_Name__c, Father_Last_Name__c,motherFirst_Name__c ,motherLast_Name__c,
                                  Enquiry_No__r.Stages__c, Enquiry_No__r.Email__c, Enquiry_No__r.Log_Status__c
                                  ,Enquiry_No__r.Lead_ID__c,Enquiry_No__r.name,Non_Stellar_Absent_For_Interaction__c,Non_Stellar_Interaction_Done__c,Non_Stellar_Attach_Interaction_Notes__c,Non_Stellar_Reject_After_Interaction__c,Non_Stellar_Document_Incomplete__c from Admission_Form__c where id=: pid];
        
        listGrant = [select id,Name,Admission_Form__c,Admission_Code__c,Status__c,Date_of_Admission__c,Confirmation_Date__c,Fee_Applicable_Date__c,Section__c,User_Id__c,Enrollment_No__c from Admission_Granted__c where Admission_Form__c=: af.Id];
        system.debug('list of Admission Granted::'+listGrant);
        
        if(adf1.Status__c =='Shortlisted for Admission' && listGrant.size()>0){
            system.debug('Admission Granted LIST(Inside IF) Size:::'+listGrant.size());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Admission already Granted!'));
            
        }
        if(adf1.Status__c =='Absent for Interaction'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'You have already updated the Status')); 
        }
        
        if(adf1.Non_Stellar_Interaction_Scheduled__c == false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction-Scheduled is not scheduled yet. you can not change the Status of record!'));
        }
        
        if(adf1.Non_Stellar_Interaction_Scheduled__c == true && adf1.Status__c !='Shortlisted for Admission'){
            adf1.Status__c ='Absent for Interaction';
            if(adf1.Enquiry_No__r.name.Contains('ENQ')){
                adf1.Non_Stellar_Absent_For_Interaction__c = true;
            }else{
				adf1.Absent_for_Interaction__c = true;
			}
            String endpoint = 'https://admission.stellarworldschool.com/leads';
            String parentFName = String.isNotBlank(adf1.FatherFirst_Name__c) ? adf1.FatherFirst_Name__c : adf1.motherFirst_Name__c;
            String parentLName = String.isNotBlank(adf1.Father_Last_Name__c) ? adf1.Father_Last_Name__c : adf1.motherLast_Name__c;
            Map<String, Object> dataMap = StellarAPICallouts.createBody(
                new List<String>{
                    'parentFirstname',
                        'parentLastname'
                        },
                new List<String>{
                    parentFName,
                        parentLName
                        }
            );
            Map<String, Object> bodyMap = StellarAPICallouts.createBody(
                new List<String>{
                    'stage',
                        'status',
                        'email',
                        'data'
                        },
                new List<Object>{
                    adf1.Status__c,
                        adf1.Enquiry_No__r.Log_Status__c, // Enquiry. Log Status
                        adf1.Enquiry_No__r.Email__c,
                        dataMap
                        }
            );
            String responseBody = StellarAPICallouts.makeCallout(endpoint, StellarAPICallouts.PUT_METHOD, bodyMap);
            system.debug('adf1.Enquiry_No__r.name.Contains' + adf1.Enquiry_No__r.name.Contains('ENQ'));
            if(adf1.Enquiry_No__r.name.Contains('ENQ')){
                adf1.Non_Stellar_Absent_For_Interaction__c = true;
                system.debug('a leadidvalue ' + leadidvalue);
                Lead ld=[Select Id,Lead_ID__c,Stage__c From Lead Where Lead_ID__c=:leadidvalue];
                system.debug('ld ' + ld);
                ld.Stage__c='Absent For Interaction';
                update ld;
            }else{
                Lead ld=[Select Id,Lead_ID__c,Stage__c From Lead Where Lead_ID__c=:leadidvalue];
                ld.Stage__c='Absent For Interaction';
                update ld;
            }
            
            update adf1;
            
            aapList = [Select Id,Name,Status__c,Enquiry__c from Application_form__c where ID =:adf1.Application_Form__c Limit 1 ];
            system.debug('Application_Update_Status:::'+aapList[0].Status__c);
            Application_form__c app = new Application_form__c();
            app.id = aapList[0].ID;
            app.Status__c = 'Absent for Observation';
            aapList.add(app);
            
            map<id,Application_form__c> appMap = new map<id,Application_form__c>();
            
            //put all the values from the list to map. 
            appMap.putall(aapList);
            if(appMap.size()>0){
                update appMap.values();
            }
            
            enqList = [Select id,Name,Stages__c,Absent_for_Interaction__c,Non_Stellar_Absent_For_Interaction__c from Enquiry__c where id =:Enquiryidvalue Limit 1 ];
            system.debug('enqList:::'+enqList);
            Enquiry__c enq = new Enquiry__c();
            enq.id = enqList[0].id;
            system.debug('enq.Name.Contains():::'+ enqList[0].Name.Contains('ENQ'));
            if(enqList[0].Name.Contains('ENQ')){
                enq.Non_Stellar_Absent_For_Interaction__c = true;
            }else{
				enq.Absent_for_Interaction__c = true;
			}
            enq.Stages__c = 'Absent for Interaction';
            enqList.add(enq);
            
            map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();
            //put all the values from the list to map. 
            enqMap.putall(enqList);
            if(enqMap.size()>0){
                update enqMap.values();
            }
            pg = new PageReference('/'+adf1.Id);
        }
        
        return pg;
    }
    public PageReference goToPageTwo(){
        PageReference pg;
        af.Status__c ='Attach Interaction Notes'; 
        if(af.Enquiry_No__r.name.Contains('ENQ')){
            af.Non_Stellar_Attach_Interaction_Notes__c = true;
        }else{
            af.Attach_Interaction_Notes__c = true;
        }
        update af;
        List<Enquiry__c> Enquiry=[SELECT Id,Name, Attach_Interaction_Notes__c,Non_Stellar_Attach_Interaction_Notes__c,Lead_ID__c FROM Enquiry__c where id=: Enquiryidvalue ];
        system.debug('AdmissionForm_Record:::::'+Enquiry);
        
        for(Enquiry__c sEnquiry :Enquiry){
            Enquiry__c sEnquirys = new Enquiry__c();
            sEnquirys.id = sEnquiry.id;
            sEnquirys.Stages__c ='Attach Interaction Notes';
            if(sEnquiry.name.Contains('ENQ')){
                sEnquirys.Non_Stellar_Attach_Interaction_Notes__c = true;
            }else{
                sEnquirys.Attach_Interaction_Notes__c = true;
            }
            listEnq.add(sEnquirys);
        }
        system.debug('listEnq::'+ listEnq);
        if(!listEnq.isEmpty()){
            update listEnq;
            if(!Test.isRunningTest()){
                Lead ld=[Select Id,Lead_ID__c,Stage__c From Lead Where Lead_ID__c=:leadidvalue];
                ld.Stage__c='Attach Interaction Notes';
                update ld;}
        }
        pg = new PageReference('/p/attach/NoteAttach?pid='+pid+'&parentname='+af.Name+'&retURL='+pid);
        return pg;
    }
    public PageReference goBack(){
        return new PageReference('/'+af.Id);
    }
          /*  public static void fakeMethod() {
            Integer j = 0;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;    
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;    
                
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;    
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;    
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
        }
*/
}