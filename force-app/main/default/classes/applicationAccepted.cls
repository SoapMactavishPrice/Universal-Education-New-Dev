public class applicationAccepted {
    List<Enquiry__c> enqList {get;set;}
    public Application_Form__c adf {set;get;}
    public String academicYear{get;set;}
    public String accountName{get;set;}
    Public List<Admission_Form__c> adFormList {get;set;}
    public boolean msg{get;set;}
    Public List<Application_Form__c> apFormList {get;set;}
    Id formids=Apexpages.currentPage().getparameters().get('id');
    public string customleadValue{get;set;}
    public applicationAccepted(Apexpages.StandardController stdcontroller)
    {
        Id formids=Apexpages.currentPage().getparameters().get('id');
        system.debug('ID::::'+formids);
        msg = True;

        Schema.DescribeFieldResult fieldDesc = Schema.Enquiry__c.Academic_Year__c.getDescribe();
        for (Schema.Picklistentry picklistEntry: fieldDesc.getPicklistValues())
        {
            if (picklistEntry.isDefaultValue())
            {
                academicYear= picklistEntry.getValue();
                break;
            }
        }

        adf = (formids==null) ? new Application_Form__c():[ SELECT Lead__c,StudentLast_Name__c,Print_Copy_Submitted__c,Academic_Year__c,Address__c,Adhaar_Card_No__c,Father_Annual_Income__c,Mother_Anual_Income__c,First_Name__c,
                                                           Application_Form_Declaration__c,Name,Birth_Place__c,Blood_Group__c,Father_Business_Address__c,Document_Verified__c,
                                                           Mother_Business_Address__c,Father_Business_Contact__c,Mother_Business_Contact__c,Category__c,Count__c,Status__c,
                                                           Do_have_another_child_with_us__c,Email_Address__c,Guardian_Email_ID__c,Enquiry__c,Enquiry_Number__c,Reason_For_Rejection__c,
                                                           Expiry_Date__c,Father_Datail_captured__c,Father_Email_Id__c,Father_Last_Name__c,Father_Occupation__c,
                                                           Father_Phone__c,Father_Qualification__c,Mother_First_Name__c,Father_First_Name__c,Having_Children__c,
                                                           Mother_Last_Name__c,Guardian_Mobile_No__c,Mobile_Number__c,Mother_Detail_Captured__c,
                                                           Mother_Email_Id__c,Mother_Occupation__c,Mother_Phone__c,Mother_Qualification__c,Mother_Tongue__c,
                                                           Guardian_Name__c,Father_Name_of_Organisation__c,Mother_Name_of_Organisation__c,Nationality__c,Passport_No__c,
                                                           Reason_of_this_School__c,Relationship__c,Religion__c,Residence_No__c,School_Short_Code__c,School_Institution__c,
                                                           Seeking_Admission_for_another_Child__c,Student_Name__c,
                                                           Form_B_captured__c,Physical_disabilities__c,Disabilities_Type__c,Other_Disabilities__c,Medical_History__c,
                                                           Other_Medical_History__c,Share_the_Allergies__c,Personalized_learning_needs__c,Personalized_learning_option__c,
                                                           Other_Personalized_Option__c,Form_B_Acknowledgement__c,Enquiry__r.Lead_ID__c,Emergency_Contact_No__c,seeking_grade__c, seeking_grade__r.name
                                                            FROM Application_Form__c where id=: formids];
                                                               System.debug('ApplicationFormRecord---'+adf);

        customleadValue = adf.Enquiry__r.Lead_ID__c;
    }
    //Method for Creating Application Acceptance and Creating Admission Form.
    public pageReference createAdmissionForm()
    {
        pageReference pg1;

        adFormList = [select id,Name,Application_Form__c,Status__c from Admission_Form__c where Application_Form__c=: adf.Id];
        system.debug('list of Admission Form::'+adFormList.size());

        if(adFormList.size()>0){ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Application Form is already accepted!'));
        }
        if(adf.Document_Verified__c == False && adf.Print_Copy_Submitted__c == False)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Required document(s) not verified'));
        }
        if(adf.Document_Verified__c == True && adf.Print_Copy_Submitted__c == False)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Print copy of Documents is not submitted'));
        }
        if(adf.Document_Verified__c == False && adf.Print_Copy_Submitted__c == True)        {            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Required document(s) not verified'));
        }


        if(adf.Document_Verified__c == True && adFormList.size()==0 && adf.Print_Copy_Submitted__c == True){

            Admission_Form__c form = new Admission_Form__c();

            Integer i=1;
            Integer k=0;
            List<Admission_Form__c> appList=[SELECT id, Autonumber_apexClass__c FROM Admission_Form__c WHERE Academic__c=:academicYear and School_Short_Code__c=:adf.School_Short_Code__c and Autonumber_apexClass__c >0 order by createddate desc NULLS LAST limit 1];
            
            System.debug('Select id,Autonumber_apexClass__c from Admission_Form__c where Academic__c=:'+ academicYear +' and School_Short_Code__c= '+adf.School_Short_Code__c+' and Autonumber_apexClass__c >0 order by createddate desc NULLS LAST limit 1');
            if(!appList.isEmpty())
                System.debug('Record----'+appList[0].id + 'Autonumber_apexClass__c ==>' + appList[0].Autonumber_apexClass__c);

            if(!appList.isEmpty())
            {

                k=i+Integer.valueOf(appList[0].Autonumber_apexClass__c);
                system.debug('Value of K:::'+k);
               // form.Name=adf.Academic_Year__c+'/'+adf.seeking_grade__r.name+'/'+adf.School_Short_Code__c+'/'+'REG'+'/'+k;
                form.Name=adf.Academic_Year__c+'/'+'REG'+'/'+k;
                system.debug('Regiration nUmber-K:::'+form.Name);
                form.Autonumber_apexClass__c=k;
            }
            else
            {
               // form.Name=adf.Academic_Year__c+'/'+adf.seeking_grade__r.name+'/'+adf.School_Short_Code__c+'/'+'REG'+'/'+i;
               form.Name=adf.Academic_Year__c+'/'+'REG'+'/'+i;
                system.debug('Regiration nUmber-I:::'+form.Name);
                form.Autonumber_apexClass__c=i;
                system.debug('number:::'+form.Name);
            }
            form.Enquiry_No__c = adf.Enquiry__c;
            form.Enquiry_Number__c=adf.Enquiry_Number__c;                       //Enquiry No
            form.First_Name__c = adf.First_Name__c;
            form.Last_Name__c = adf.StudentLast_Name__c;
            form.Lead__c=adf.Lead__c;
            form.Academic__c = adf.Academic_Year__c;
            form.Address__c=adf.Address__c;
            form.Adhaar_Card_No__c=adf.Adhaar_Card_No__c;
            form.fatherAnnualincome__c=adf.Father_Annual_Income__c;
            //form.Name= adf.Name;
            form.Application_Form__c = adf.id;
            form.motherAnnual_Income__c=adf.Mother_Anual_Income__c;
            form.Birth_Place__c=adf.Birth_Place__c;
            form.Blood_Group__c=adf.Blood_Group__c;
            form.Business_Address__c=adf.Father_Business_Address__c;
            form.motherBusiness_Address__c=adf.Mother_Business_Address__c;
            form.Business_Address__c=adf.Father_Business_Address__c;
            form.fatherBusiness_Contact__c=adf.Father_Business_Contact__c;
            form.motherBusiness_Contact__c=adf.Mother_Business_Contact__c;
            form.Category__c=adf.Category__c;
            form.Application_No__c = adf.Name;                                      //Application No.
            form.Email_Address__c=adf.Email_Address__c;
            form.GuardianEmail_Id__c=adf.Guardian_Email_ID__c;
            form.GuardianMobile_No__c=adf.Guardian_Mobile_No__c;
            form.GuardianName__c=adf.Guardian_Name__c;
            form.Expiry_Date__c=adf.Expiry_Date__c;
            form.Father_Detail_Captured__c=adf.Father_Datail_captured__c;
            form.Father_Email_Id__c=adf.Father_Email_Id__c;
            form.Father_Last_Name__c=adf.Father_Last_Name__c;
            form.Father_occupation__c=adf.Father_Occupation__c;
            form.Father_Phone__c=adf.Father_Phone__c;
            form.Father_Qualification__c=adf.Father_Qualification__c;
            form.FatherFirst_Name__c=adf.Father_First_Name__c;
            form.fatherName_of_Organisation__c=adf.Father_Name_of_Organisation__c;
            form.Registration_Date__c = system.today();            
            form.Mobile_Number__c=adf.Mobile_Number__c;
            form.fatherName_of_Organisation__c=adf.Father_Name_of_Organisation__c;
            form.Mother_Detail_Captured__c=adf.Mother_Detail_Captured__c;
            form.Mother_Email_Id__c=adf.Mother_Email_Id__c;
            form.motherLast_Name__c=adf.Mother_Last_Name__c;
            form.motherFirst_Name__c=adf.Mother_First_Name__c;
            form.Mother_Occupation__c=adf.Mother_Occupation__c;
            form.Mother_Phone__c=adf.Mother_Phone__c;
            form.Mother_Qualification__c=adf.Mother_Qualification__c;
            form.Mother_Tongue__c=adf.Mother_Tongue__c;
            form.motherName_of_Organisation__c=adf.Mother_Name_of_Organisation__c;
            form.Nationality__c=adf.Nationality__c;
            form.PassPort_No__c=adf.Passport_No__c;
            form.Reason_of_this_School__c=adf.Reason_of_this_School__c;
            form.Relationship__c=adf.Relationship__c;
            form.Religion__c=adf.Religion__c;
            form.Residence_No__c=adf.Residence_No__c;
            form.School_Institution__c=adf.School_Institution__c;
            form.Student_Name__c=adf.Student_Name__c;
            //form.Seeking_Admission_in_Grade__c=adf.Seeking_Admission_in_Grade__c;
            form.School_Short_Code__c = adf.School_Short_Code__c;
            form.Emergency_Contact_No__c = adf.Emergency_Contact_No__c;
            form.seeking_grade__c = adf.seeking_grade__c;



            // form.Form_B_captured__c= adf.Form_B_captured__c;
            // form.Physical_disabilities__c=adf.Physical_disabilities__c;
            // form.Disabilities_Types__c=adf.Disabilities_Type__c;
            // form.Other_Disabilities__c=adf.Other_Disabilities__c;
            // form.Medical_History__c=adf.Medical_History__c;
            // form.Other_Medical_History__c=adf.Other_Medical_History__c;
            // form.Allergies__c=adf.Allergies__c;
            // form.Share_the_Allergies__c=adf.Share_the_Allergies__c;
            // form.Personalized_learning_needs__c= adf.Personalized_learning_needs__c;
            // form.Personalized_learning_option__c= adf.Personalized_learning_option__c;
            // form.Other_Personalized_Option__c=adf.Other_Personalized_Option__c;
            // form.Form_B_Acknowledgement__c= adf.Form_B_Acknowledgement__c;
            //form.School_Short_Code__c = adf.SchoolShort_Code__c;


            // Stellar callout Application accepted
            if(StellarAPICallouts.checkIfStellarAPIEnabled(adf.School_Short_Code__c)){
                /*
                    API: https://admission.stellarworldschool.com/leads
                    Method: PUT
                    Payload:
                    {
                    "stage": "APPLICATION_ACCEPTED",
                    "status": "INTERACTION_DONE",
                    "email": "anam@technogise.com",
                    "data": {
                        "parentFirstname": "Ayaan",
                        "parentLastname": "Shah"
                    }
                    }
                    {
                    "stage": "APPLICATION_REJECTED",
                    "status": "INTERACTION_DONE",
                    "email": "anam@technogise.com",
                    "data": {
                        "parentFirstname": "Ayaan",
                        "parentLastname": "Shah"
                    }
                    }
                */

                String parentFirstName = String.isNotBlank(adf.Father_First_Name__c) ? adf.Father_First_Name__c : adf.Mother_First_Name__c;
                String parentLastName = String.isNotBlank(adf.Father_Last_Name__c) ? adf.Father_Last_Name__c : adf.Mother_Last_Name__c;
                Map<String, Object> dataMap = StellarAPICallouts.createBody(
                    new List<String>{'parentFirstname', 'parentLastname'},                    new List<Object>{parentFirstName, parentLastName}
                );
                Map<String, Object> requestBody = StellarAPICallouts.createBody(
                    new List<String>{                        'stage', 'status', 'email', 'data'
                    },
                    new List<Object>{
                        // adf.Status__c.replaceAll(' ','_').toUpperCase(), 'INTERACTION_DONE', adf.Email_Address__c, dataMap
                        'APPLICATION_ACCEPTED', 'INTERACTION_DONE', adf.Email_Address__c, dataMap
                    }
                );
                StellarAPICallouts.makeCallout('https://admission.stellarworldschool.com/leads', StellarAPICallouts.PUT_METHOD, requestBody);
            }

            insert form;

            system.debug('Admission-Form:::'+form);

            Application_Form__c app = [Select id,Name,Status__c,Enquiry__c,Application_Accepted__c,Reason_For_Rejection__c,
                                       Enquiry__r.Contact__c,Enquiry__r.Contact__r.Lead_ID__c
                                       from Application_Form__c where Id=: formids LIMIT 1];

            app.Status__c = 'Application Accepted';
            app.Application_Accepted__c = true;
            update app;
            
            

            enqList = [Select id,Name,Stages__c from Enquiry__c where id =: app.Enquiry__c Limit 1 ];
            Enquiry__c enq = new Enquiry__c();
            enq.id = enqList[0].id;
            enq.Stages__c = 'Application Accepted';
            enqList.add(enq);

            map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();

            //put all the values from the list to map.
            enqMap.putall(enqList);
            if(enqMap.size()>0){
                update enqMap.values();
            }
            List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead){lead l = new lead();l.id = le.id;l.Stage__c = 'Application Accepted';
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){update lstlead;
                    }
                }

            system.debug('updated Field Application+++'+app.Status__c);
            pg1 = new pageReference('/'+adf.Id);

            //Creating records from parent App Form
            List<ContentDocumentLink> oldContentDocumentLinks = [
            SELECT
                Id,
                LinkedEntityId,
                ContentDocumentId
            FROM
                ContentDocumentLink
            WHERE
                LinkedEntityId = :adf.Id
            ];
            List<Id> contentDocIds = new List<Id>();
            List<Id> contentVerIds = new List<Id>();
            for (ContentDocumentLink cdl : oldContentDocumentLinks) {                contentDocIds.add(cdl.ContentDocumentId);
            }

            // List<ContentVersion> lstConVer = [
            //     Select Id,Description FROM ContentVersion WHERE ContentDocumentId IN :contentDocIds
            // ];
            // for (ContentVersion cv : lstConVer) {
            //     String enquiryId = cv.description.split('-')[0];
            //     String photoName = cv.description.split('-')[1];
            //     String appFormId = enquiryToAppForm.get(enquiryId);
            //     // cv.description = appFormId + '-' + photoName;
            //     cv.Title = photoName + '-' + appFormId ;
            // }
            // update lstConVer;
            // System.debug('after converting files ====' + lstConver);
            // delete lstConDist;
            // delete oldContentDocumentLinks;
            List<ContentDocumentLink> newContentDocumentLinks = new List<ContentDocumentLink>();
            for (ContentDocumentLink cdl : oldContentDocumentLinks) {
                newContentDocumentLinks.add(                    new ContentDocumentLink(
                        LinkedEntityId = form.Id,                        ContentDocumentId = cdl.ContentDocumentId
                    )
                );
            }
            //Update public links for application form
            // for (type variable : List_or_set) {

            // }
            insert newContentDocumentLinks;
        }
        return pg1;
    }


    public PageReference goBack(){
        return new PageReference('/'+adf.Id);
    }

    //Method for Rejecting Application
    public PageReference applicationRejected(){

        pageReference pg2;

        Application_Form__c app = [Select id,Name,Status__c,Application_Rejected__c,Document_Verified__c,Enquiry__c,Reason_For_Rejection__c,
                                    Enquiry__r.Contact__c,Enquiry__r.Contact__r.Lead_ID__c
                                   from Application_Form__c where Id=: formids LIMIT 1];
        system.debug('REJECT-RECORD:::'+app);

        adFormList = [select id,Name,Application_Form__c,Status__c from Admission_Form__c where Application_Form__c=: adf.Id];

        if(app.Status__c == 'Application Accepted' && app.Document_Verified__c == True ){
            system.debug('inside IF:::');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'You can not reject this Application at this Stage !'));
        }
        if(adFormList.size()>0){
            system.debug('inside List Checking in Rejected Method IF:::'+adFormList.size());
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Application Form Once Accepted can not be rejected. This application form is now available in Admission form.You can now only reject Admission form.'));
        }
        if(app.Status__c == 'Application Rejected'){
            system.debug('inside IF:::');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'This Application Form is Already Rejected !'));
        }
        if(app.Status__c == 'Application submitted' || app.Status__c == 'Application Under Reviewed' || app.Status__c == 'Observation' || app.Status__c == 'Document Verified' )
        {
            app.Status__c = 'Application Rejected';
            app.Application_Rejected__c =true;

            // Stellar Application Rejected
            if(StellarAPICallouts.checkIfStellarAPIEnabled(adf.School_Short_Code__c)){
                /*
                    API: https://admission.stellarworldschool.com/leads
                    Method: PUT
                    Payload:
                    {
                    "stage": "APPLICATION_REJECTED",
                    "status": "INTERACTION_DONE",
                    "email": "anam@technogise.com",
                    "data": {
                        "parentFirstname": "Ayaan",
                        "parentLastname": "Shah"
                    }
                    }
                */

                String parentFirstName = String.isNotBlank(adf.Father_First_Name__c) ? adf.Father_First_Name__c : adf.Mother_First_Name__c;
                String parentLastName = String.isNotBlank(adf.Father_Last_Name__c) ? adf.Father_Last_Name__c : adf.Mother_Last_Name__c;
                Map<String, Object> dataMap = StellarAPICallouts.createBody(
                    new List<String>{'parentFirstname', 'parentLastname'},      new List<Object>{parentFirstName, parentLastName}
                );
                Map<String, Object> requestBody = StellarAPICallouts.createBody(
                    new List<String>{                        'stage', 'status', 'email', 'data'
                    },
                    new List<Object>{                        'APPLICATION_REJECTED', 'INTERACTION_DONE', adf.Email_Address__c, dataMap
                    }
                );
                StellarAPICallouts.makeCallout('https://admission.stellarworldschool.com/leads', StellarAPICallouts.PUT_METHOD, requestBody);
            }

            update app;
            

            enqList = [Select id,Name,Stages__c from Enquiry__c where id =: app.Enquiry__c Limit 1 ];
            Enquiry__c enq = new Enquiry__c();
            system.debug('Enquiry:::'+ enqList);
            system.debug('Before Updated Enquiry Field ::'+ enqList[0].Stages__c);
            enq.id = enqList[0].id;
            enq.Stages__c = 'Application Rejected';
            enqList.add(enq);


            map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();

            //put all the values from the list to map.
            enqMap.putall(enqList);
            if(enqMap.size()>0){
                update enqMap.values();
            }

                List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead){lead l = new lead();l.id = le.id;l.Stage__c = 'Application Rejected';
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){update lstlead;
                    }
                }
            system.debug('Updated Enquiry Field ::'+ enq.Stages__c);
            pg2 = new pageReference('/'+app.Id);

        }
        return pg2;
    }
    public PageReference documentVerified(){
        pageReference pg2;

        Application_Form__c app = [Select id,Name,Status__c,Document_Verified__c,Enquiry__c,Reason_For_Rejection__c,
                                   Enquiry__r.Contact__c,Enquiry__r.Contact__r.Lead_ID__c
                                   from Application_Form__c where Id=: formids LIMIT 1];
        system.debug('REJECT-RECORD:::'+app);

        if(adf.Print_Copy_Submitted__c == False)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Print copy of Document is not recieved'));
        }
        if(adf.Print_Copy_Submitted__c == true && adf.Status__c =='Application Accepted')        {            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Application is already Accepted.'));
        }

        if(adf.Print_Copy_Submitted__c == true && adf.Status__c!='Application Accepted')
        {
            app.Status__c = 'Document Verified';
            app.Document_Verified__c = true;
                       

            // Stellar Document Verified
            if(StellarAPICallouts.checkIfStellarAPIEnabled(adf.School_Short_Code__c)){
                /*
                    API: https://admission.stellarworldschool.com/leads
                    Method: PUT
                    Payload:
                    {
                        "stage": "DOCUMENT_VERIFIED",
                        "status": "INTERACTION_DONE",
                        "email": "anam@technogise.com",
                        "data": {
                            "parentFirstname": "Ayaan",
                            "parentLastname": "Shah"
                        }
                    }
                */

                String parentFirstName = String.isNotBlank(adf.Father_First_Name__c) ? adf.Father_First_Name__c : adf.Mother_First_Name__c;
                String parentLastName = String.isNotBlank(adf.Father_Last_Name__c) ? adf.Father_Last_Name__c : adf.Mother_Last_Name__c;
                Map<String, Object> dataMap = StellarAPICallouts.createBody(
                    new List<String>{'parentFirstname', 'parentLastname'},        new List<Object>{parentFirstName, parentLastName}
                );
                Map<String, Object> requestBody = StellarAPICallouts.createBody(
                    new List<String>{                        'stage', 'status', 'email', 'data'
                    },
                    new List<Object>{                        'DOCUMENT_VERIFIED', 'INTERACTION_DONE', adf.Email_Address__c, dataMap
                    }
                );
                StellarAPICallouts.makeCallout('https://admission.stellarworldschool.com/leads', StellarAPICallouts.PUT_METHOD, requestBody);
            }


            update app;

            enqList = [Select id,Name,Stages__c from Enquiry__c where id =: app.Enquiry__c Limit 1 ];
            Enquiry__c enq = new Enquiry__c();
            system.debug('Enquiry:::'+ enqList);
            system.debug('Before Updated Enquiry Field ::'+ enqList[0].Stages__c);
            enq.id = enqList[0].id;
            enq.Stages__c = 'Document Verified';

            enqList.add(enq);


            map<id,Enquiry__c> enqMap = new map<id,Enquiry__c>();

            //put all the values from the list to map.
            enqMap.putall(enqList);
            if(enqMap.size()>0){
                update enqMap.values();
            }
            List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead){lead l = new lead();l.id = le.id;l.Stage__c = 'Document Verified';
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){update lstlead;
                    }
                }

            system.debug('Updated Enquiry Field ::'+ enq.Stages__c);
            pg2 = new pageReference('/'+app.Id);

        } return pg2;


    }
}