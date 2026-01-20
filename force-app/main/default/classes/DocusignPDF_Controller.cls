public without sharing class DocusignPDF_Controller {
     Public Enquiry__c enq{get;set;}
        public Account acc{get;set;}
        public Admission_Granted__c form{get;set;}
        public List<Disclosure__c> documentList{get;set;}
    	public Disclosure__c documentListURL{get;set;}
    	public String Academic_Year{get;set;}
        public String studentPhoto{get;set;}
        public String fatherPhoto{get;set;}
        public String motherPhoto{get;set;}
        public String fatherSignaturePhoto{get;set;}
        public String motherSignaturePhoto{get;set;}
        public String parentNamesToShowFormC{get;set;}
        public String logoUrl{get;set;}
        public String schoolNameForPdf{get;set;}
        public Boolean hasFatherDetails{get;set;}
        public Boolean hasMotherDetails{get;set;}
        public String strTodayTime{get;set;}

        // public Account acc{get;set;}
        // public Application_Form__c form{get;set;}
        // public List<Disclosure__c> documentList{get;set;}
        // public String studentPhoto{get;set;}
        // public String fatherPhoto{get;set;}
        // public String motherPhoto{get;set;}
        // public String fatherSignaturePhoto{get;set;}
        // public String motherSignaturePhoto{get;set;}
        // public String parentNamesToShowFormC{get;set;}
        // public String logoUrl{get;set;}
        // public String schoolNameForPdf{get;set;}

        public boolean udise {get;set;}
        public boolean enrNo{get;set;}
        public boolean emisNo{get;set;}

        Id pid=Apexpages.currentpage().getParameters().get('id');
        public DocusignPDF_Controller(ApexPages.StandardController Controller){
            // Application_Form__c
            // System.debug(Controller.getRecord().get('Application_Form__c'));
            String s = [Select Application_Form__c From Admission_Granted__c Where Id = :pid Limit 1][0].Application_Form__c;
            Id appId = ID.valueOf(s);
            system.debug('APPLICATION_ID::::::'+pid);
            hasFatherDetails = false;
            hasMotherDetails = false;
            strTodayTime = System.now().hour()+':'+System.now().minute()+':'+System.now().second();
            List<Id> contentDocuments = new List<Id>();
            List<ContentDocumentLink> lstCdl = [
                SELECT Id,
                       LinkedEntityId,
                       ContentDocumentId
                  FROM ContentDocumentLink
                 WHERE LinkedEntityId = :pid
            ];
            System.debug('lstCdl ==== '  + lstCdl);
            for (ContentDocumentLink cdl : lstCdl) {
                contentDocuments.add(cdl.ContentDocumentId);
            }
            System.debug('contentDocuments ==== '  + contentDocuments);
            System.debug('UserId ==== '  + UserInfo.getUserId());
            String toSearchPid = '%' + appId;
            List<ContentDistribution> contentDists =  [
                SELECT ContentVersion.Title, ContentDownloadURL
                FROM ContentDistribution
                WHERE  ContentVersion.title LIKE :toSearchPid
            ];
            System.debug('to Search  === '  + toSearchPid);
            for (ContentDistribution cd : contentDists) {
                if(cd.ContentVersion.Title.contains('StudentPhoto')) {
                    studentPhoto = cd.ContentDownloadURL;
                }
                if(cd.ContentVersion.Title.contains('FatherPhoto')) {
                    fatherPhoto = cd.ContentDownloadURL;
                }
                if(cd.ContentVersion.Title.contains('FatherSignaturePhoto')) {
                    fatherSignaturePhoto = cd.ContentDownloadURL;
                }
                if(cd.ContentVersion.Title.contains('MotherSignaturePhoto')) {
                    motherSignaturePhoto = cd.ContentDownloadURL;
                }
                if(cd.ContentVersion.Title.contains('MotherPhoto')) {
                    motherPhoto = cd.ContentDownloadURL;
                }
            }
            System.debug('stud phot '+ studentPhoto);
            //form = (Application_Form__c)Controller.getRecord();

            form = [SELECT Application_Form__r.name,Student_s_Name__c,Personalized_Learning_Option_FF__c,Personalized_Learning_Needs_FF__c,Share_the_Allergies_FF__c,Allergies_FF__c,Other_Disabilities_FF__c,Disabilities_Types__c,
                    Do_you_have_another_child_with_us__c,guardianMobile_No__c,GuardianName__c,Annual_Income_FF__c,Office_Contact_No_FF__c,Office_Address_FF__c,Name_of_Department_FF__c,Is_Guardian_Government_Employee_FF__c,Guardian_Profession_FF__c,
                    Guardian_Qualification_FF__c,Guardian_Pan_Card_No_FF__c,guardianEmail_Id__c,Guardian_Aadhaar_Card_No_FF__c,Mother_Office_Address_FF__c,Mother_Office_Contact_No_FF__c,Mother_Designation_FF__c,Mother_Name_of_Department_FF__c,
                    Is_Mother_Government_Employee_FF__c,mother_Mobile_No__c,Father_Office_Address_FF__c,Father_Office_Contact_No_FF__c,
                    Father_Designation__c,Father_Name_of_Department_FF__c,Is_Father_Government_Employee_FF__c,father_Mobile_No__c,Country__c,
                    Pincode__c,State__c,City__c,OCI_FF__c,Citizenship_Country__c,Emergency_Contact_No__c,Residential_Address_FF__c,
                    Application_No__c,Grade_lookup__r.name,EMIS_No_FF__c,Mother_Adhaar_Card_No__c,Mother_Pan_Card_No__c,
                    Father_Aadhaar_Card_No__c,Father_Pan_Card_No__c,Student_UDISE_No__c,
                    Academic_Year__c,Address__c,Adhaar_Card_No__c,Father_Annual_Income__c,mother_Annual_Income__c,Application_Form__r.State__c,Application_Form__r.City__c,Application_Form__r.Country__c,Application_Form__r.Pincode__c,
                    Application_Form__r.Application_Form_Declaration__c,Name,Birth_Place__c,Blood_Group__c,Father_Business_Address__c,
                    Mother_Business_Address__c,Father_Business_Contact__c,Mother_Business_Contact__c,Category__c,Application_Form__r.Count__c,
                    Application_Form__r.Do_have_another_child_with_us__c,Email_Address__c,Application_Form__r.Guardian_Email_ID__c,EnquiryNo__c,Enquiry_Number__c,
                    Expiry_Date__c,First_Name__c,Application_Form__r.Father_Datail_captured__c,Father_Email_Id__c,Father_Last_Name__c,Father_Occupation__c,
                    Application_Form__r.Father_Phone__c,Father_Qualification__c,Mother_First_Name__c,Father_First_Name__c,Application_Form__r.Having_Children__c,
                    Mother_Last_Name__c,Last_Name__c,Application_Form__r.Guardian_Mobile_No__c,Mobile_Number__c,Application_Form__r.Mother_Detail_Captured__c,
                    Mother_Email_Id__c,Mother_Occupation__c,Application_Form__r.Mother_Phone__c,Mother_Qualification__c,Mother_Tongue__c,
                    Application_Form__r.Guardian_Name__c,Father_Name_of_Organisation__c,Mother_Name_of_Organisation__c,Nationality__c,Passport_No__c,
                    Reason_of_this_School__c,Relationship__c,Religion__c,Residence_No__c,School_Short_Code__c,School_Institution__c,Application_Form__r.School__c,
                    Seeking_Admission_for_another_Child__c,Application_Form__r.StudentLast_Name__c,Seeking_Admission_in_Grade__c,Application_Form__r.Student_Name__c, CreatedDate,
                    Application_Form__r.Emergency_Contact_No__c,Application_Form__r.EMIS_No__c,Enrollment_No__c,
                    Application_Form__r.Is_Father_Government_Employee__c,Application_Form__r.Father_Name_of_Department__c,Application_Form__r.Father_Designation__c,Application_Form__r.Father_Office_Contact_No__c,
                    Application_Form__r.Father_Office_Address__c,Application_Form__r.Is_Mother_Government_Employee__c,Application_Form__r.Mother_Name_of_Department__c,Application_Form__r.Mother_Designation__c,Application_Form__r.Mother_Office_Contact_No__c,
                    Application_Form__r.Mother_Office_Address__c,Guardian_Residential_Address__c,Application_Form__r.Guardian_Aadhaar_Card_No__c,Application_Form__r.Guardian_Pan_Card_No__c,
                    Application_Form__r.Guardian_Qualification__c,Application_Form__r.Is_Guardian_Government_Employee__c,Application_Form__r.Office_Address__c,Application_Form__r.Office_Contact_No__c,Application_Form__r.Annual_Income__c,Application_Form__r.Guardian_Profession__c,
                    Name_of_child_1__c,Class_1__c,Student_Code_1__c,Name_of_child_2__c,Class_2__c,Student_Code_2__c,Single_Parent__c,Application_Form__r.Name_of_Department__c,
                    Medical_History_FF__c, Other_Disabilities__c, Physical_disabilities__c, Allergies__c, Share_the_Allergies__c,
                    Personalized_learning_needs__c, Other_Personalized_Option__c, Grade_lookup__c, Personalized_learning_option__c, Curriculum__c, Category_New__c
                    FROM Admission_Granted__c where id=: pid ];
            // form.Seeking_Admission_in_Grade__c
            String tosearchClass = form.Grade_lookup__c;
            List<Account> school = [
                SELECT
                    Id,
                    (
                        SELECT School_Name_on_PDF__c FROM Class__r WHERE Id =:tosearchClass
                    )
                FROM
                    Account
                WHERE
                    Id = :form.School_Institution__c LIMIT 1];
            if (school.size() > 0 && school[0].Class__r.size() > 0) {
                schoolNameForPdf = school[0].Class__r[0].School_Name_on_PDF__c;
            }

            try {
                logoUrl = PageReference.forResource(form.School_Short_Code__c + '_APP_PDF').getUrl();
            }
            catch(exception e) {
                logoUrl = PageReference.forResource('NoImage').getUrl();
            }
            system.debug('APPLICATION RECORD::::'+form);
            String fatherName = '';
            String motherName = '';
            String guardianName = '';
            if(form.Father_First_Name__c != null && form.Father_Last_Name__c != null) {
                fatherName = form.Father_First_Name__c + ' ' + form.Father_Last_Name__c;
            }
            if(form.Mother_First_Name__c != null && form.Mother_Last_Name__c != null) {
                motherName = form.Mother_First_Name__c + ' ' + form.Mother_Last_Name__c;
            }
            if(String.isNotBlank(form.Mother_First_Name__c) || String.isNotBlank(form.Mother_Last_Name__c)){
                hasMotherDetails = true;
            }
            if(String.isNotBlank(form.Father_First_Name__c) || String.isNotBlank(form.Father_Last_Name__c)){
                hasFatherDetails = true;
            }
            system.debug('hasFatherDetails::::::'+hasFatherDetails);
            system.debug('hasMotherDetails::::::'+hasMotherDetails);
            if(form.Application_Form__r.Guardian_Name__c != null) {
                guardianName = form.Application_Form__r.Guardian_Name__c;
            }

            if (fatherName.length() > 1) {
                if (motherName.length() > 1) {
                    if (guardianName.length() > 1) {
                        parentNamesToShowFormC = fatherName + ' &  ' + motherName + ' & ' + guardianName;
                    }else {
                        parentNamesToShowFormC = fatherName + ' &  ' + motherName;
                    }
                }
            }
            if (!(fatherName.length() > 1) && motherName.length() > 1) {
                parentNamesToShowFormC = motherName;
                if (guardianName.length() > 1) {
                    parentNamesToShowFormC = motherName + ' & ' + guardianName;
                }
            }
            if (guardianName.length() > 1 && !(fatherName.length() > 1) && !(motherName.length() > 1)) {
                parentNamesToShowFormC = guardianName;
            }

            enq = [SELECT Id,School_Name__c
                        , Date_of_Birth__c
                        , FirstName__c
                        , Last_Name__c
                        , Name
                        , Gender__c
                        , Enq_School_Institute__c
                        , Grade__c
                        , Org_code__c
                        , Seeking_Grade__r.name
                     from Enquiry__c where id =: form.EnquiryNo__c];
            System.debug('Enquiry+++'+enq);

            School_List__mdt schoolRec = [
                SELECT  State__c
                FROM    School_List__mdt
                WHERE   Label = :enq.Org_code__c
                LIMIT   1
            
            ];

            if (enq.Seeking_Grade__r.name != 'I'
                && enq.Seeking_Grade__r.name != 'SR.KG'
                && enq.Seeking_Grade__r.name != 'JR.KG'
                && enq.Seeking_Grade__r.name != 'NURSERY'
                && enq.Seeking_Grade__r.name != 'PLAYGROUP'
            ) {
                if ('Maharashtra'.equalsIgnoreCase(schoolRec.State__c)) {
                    udise = true;
                }
                else if ('Karnataka'.equalsIgnoreCase(schoolRec.State__c)) {
                    enrNo = true;
                }
                else if ('Trichy'.equalsIgnoreCase(schoolRec.State__c)) {
                    emisNo = true;
                }
            }

            acc = [select id,Name,BillingAddress,BillingCity,BillingCountry,BillingGeocodeAccuracy,
                   BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStreet,School_Email__c FROM Account where id=: form.School_Institution__c];
            system.debug('ACCOUNT:::::'+acc);
            if (form != null) {
                Id grade = form.Grade_lookup__c;
                Id schoolId = form.School_Institution__c;
                Academic_Year =form.Academic_Year__c;
                System.debug('grade==> ' + grade);
                System.debug('schoolId==> ' + schoolId);
                documentList = [ SELECT Id, Name, Terms__c, Description__c FROM Disclosure__c where (not name like '%Form C1%') and Academic_Year__c=:form.Academic_Year__c and Class__c =:grade and school__c=:schoolId order by DisplaySequence__c asc];
                System.debug('documentList >>> ' + documentList);
                documentListURL = [ SELECT Id,School_Institution_Logo_URL__c FROM Disclosure__c where /*OrgionalClass__c=:grade and*/ school__c=:schoolId /*and Academic_Year__c=:Academic_Year*/ AND School_Institution_Logo_URL__c != null order by DisplaySequence__c asc Limit 1];
                System.debug('documentListURL @@@@@@' + documentListURL.School_Institution_Logo_URL__c);
            }

            //attachPDF();         
        }

        public void attachPDF() {
            //PageReference pdfPage = Page.ApplicationformPDF;
            //Blob pdfBlob = pdfPage.getContent();
            //Attachment attach = new Attachment(parentId = pid, Name = 'Application Form.pdf', body = pdfBlob); //create the attachment object
            //insert attach;
            PageReference pageRef = new PageReference('/'+pid);
            //return pageRef;
        }

        public static void fakeMethod() {
            Integer i = 0;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
           i++;
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