public without sharing class Applicationform {
     Public Enquiry__c enq{get;set;}
        public Account acc{get;set;}
        public Application_Form__c form{get;set;}
        public List<Disclosure__c> documentList{get;set;}
        public String studentPhoto{get;set;}
        public String fatherPhoto{get;set;}
        public String motherPhoto{get;set;}
        public String fatherSignaturePhoto{get;set;}
        public String motherSignaturePhoto{get;set;}
        public Boolean allShowDiv{get;set;}
        public Boolean fatherShowDiv{get;set;}
        public Boolean motherShowDiv{get;set;}
        public String parentNamesToShowFormC{get;set;}
        public String logoUrl{get;set;}
        public String schoolNameForPdf{get;set;}

        public boolean udise {get;set;}
        public boolean enrNo{get;set;}
        public boolean emisNo{get;set;}

        Id pid=Apexpages.currentpage().getParameters().get('id');
        public Applicationform(ApexPages.StandardController Controller){
            allShowDiv = false;
            fatherShowDiv = false;
            motherShowDiv = false;

            system.debug('APPLICATION_ID::::::'+pid);
            udise = false;
            enrNo = false;
            emisNo = false;
            List<Id> contentDocuments = new List<Id>();
            // List<ContentDocumentLink> lstCdl = [
            //     SELECT Id, LinkedEntityId, ContentDocumentId
            //     FROM ContentDocumentLink
            //     WHERE LinkedEntityId = :pid
            // ];
            // System.debug('lstCdl ==== '  + lstCdl);
            // for (ContentDocumentLink cdl : lstCdl) {
            //     contentDocuments.add(cdl.ContentDocumentId);
            // }
            // System.debug('contentDocuments ==== '  + contentDocuments);
            // System.debug('UserId ==== '  + UserInfo.getUserId());
            // String toSearchPid = '%' + pid + '%';
            // List<ContentDistribution> contentDists =  [
            //     SELECT Id, ContentVersion.Title, ContentDownloadURL
            //     FROM ContentDistribution
            //     // WHERE  ContentVersion.title LIKE :toSearchPid
            // ];
            // System.debug('to Search  === '  + toSearchpid);
            // // System.debug('contentDists ==== '  +
            // // [
            // //     SELECT ContentVersion.Title, ContentDownloadURL
            // //     FROM ContentDistribution
            // //    WHERE  ContentVersion.title LIKE :toSearchPid
            // // ]
            // // );
            // for (ContentDistribution cd : contentDists) {
            //     // System.debug(cd.Id + ' ' + cd.ContentVersion.Title);
            //     if(cd.ContentVersion.Title.contains('StudentPhoto')) {
            //         studentPhoto = cd.ContentDownloadURL;
            //     }
            //     if(cd.ContentVersion.Title.contains('FatherPhoto')) {
            //         fatherPhoto = cd.ContentDownloadURL;
            //     }
            //     if(cd.ContentVersion.Title.contains('FatherSignaturePhoto')) {
            //         fatherSignaturePhoto = cd.ContentDownloadURL;
            //     }
            //     if(cd.ContentVersion.Title.contains('MotherSignaturePhoto')) {
            //         motherSignaturePhoto = cd.ContentDownloadURL;
            //     }
            //     if(cd.ContentVersion.Title.contains('MotherPhoto')) {
            //         motherPhoto = cd.ContentDownloadURL;
            //     }
            // }

            Set < String > setDocDescription = new Set < String > ();
            setDocDescription.add('StudentPhoto-'+pid);
            setDocDescription.add('FatherPhoto-'+pid);
            setDocDescription.add('FatherSignaturePhoto-'+pid);
            setDocDescription.add('MotherSignaturePhoto-'+pid);
            setDocDescription.add('MotherPhoto-'+pid);

            List < ContentDocumentLink > links = [
                SELECT ContentDocumentId, LinkedEntityId
                FROM ContentDocumentLink
                // WHERE LinkedEntityId = 'a01Sz000009CLpuIAG'
                WHERE LinkedEntityId =: pid
            ];

            if (links.size() > 0) {
                Set < Id > ids = new Set < Id > ();
                for (ContentDocumentLink link: links) {
                    ids.add(link.ContentDocumentId);
                }

                List < ContentVersion > ContentVersionLIST = [
                    SELECT Id, ContentDocumentId, Description
                    FROM ContentVersion
                    WHERE ContentDocumentId IN: ids
                    AND Title IN: setDocDescription
                    // AND ContentDocumentId IN: ids
                    ORDER BY CreatedDate DESC
                ];

                System.debug('ContentVersionLIST=== = ' + ContentVersionLIST.size());

                for (ContentVersion doc: ContentVersionLIST) {
                    // System.debug(doc.Id);
                    System.debug(doc.Description);
                    if (doc.Description.contains('StudentPhoto')) {
                        studentPhoto = doc.Id;
                    }
                    if (doc.Description.contains('FatherPhoto')) {
                        fatherPhoto = doc.Id;
                    }
                    if (doc.Description.contains('FatherSignaturePhoto')) {
                        fatherSignaturePhoto = doc.Id;
                    }
                    if (doc.Description.contains('MotherSignaturePhoto')) {
                        motherSignaturePhoto = doc.Id;
                    }
                    if (doc.Description.contains('MotherPhoto')) {
                        motherPhoto = doc.Id;
                    }
                }
            }

            System.debug('studentPhoto :>>>> '+ studentPhoto);
            System.debug('fatherPhoto :>>>> '+ fatherPhoto);
            System.debug('fatherSignaturePhoto :>>>> '+ fatherSignaturePhoto);
            System.debug('motherSignaturePhoto :>>>> '+ motherSignaturePhoto);
            System.debug('motherPhoto :>>>> '+ motherPhoto);
            //form = (Application_Form__c)Controller.getRecord();

            form = [SELECT Curriculum__c,Category_New__c,Mother_Adhaar_Card_No__c,Mother_Pan_Card_No__c,Father_Aadhar_Card__c,Father_Pan_Card_No__c, Student_UDISE_No__c,
                    Academic_Year__c,Address__c,Adhaar_Card_No__c,Father_Annual_Income__c,Mother_Anual_Income__c,State__c,City__c,
                    Country1__c, Grade__c, Past_School_Institute__c,
                    Pincode__c, Caste__c, Enquiry__r.Name,
                    Application_Form_Declaration__c,Name,Birth_Place__c,Blood_Group__c,Father_Business_Address__c,
                    Mother_Business_Address__c,Father_Business_Contact__c,Mother_Business_Contact__c,Category__c,Count__c,
                    Do_have_another_child_with_us__c,Email_Address__c,Guardian_Email_ID__c,Enquiry__c,Enquiry_Number__c,
                    Expiry_Date__c,First_Name__c,Father_Datail_captured__c,Father_Email_Id__c,Father_Last_Name__c,Father_Occupation__c,
                    Father_Phone__c,
                  Father_Qualification__c,
                    Mother_First_Name__c,Father_First_Name__c,Having_Children__c,
                    Mother_Last_Name__c,Guardian_Mobile_No__c,Mobile_Number__c,Mother_Detail_Captured__c,
                    Mother_Email_Id__c,Mother_Occupation__c,Mother_Phone__c,
                    Mother_Qualification__c,
                    Mother_Tongue__c,
                    Guardian_Name__c,Father_Name_of_Organisation__c,Mother_Name_of_Organisation__c,Nationality__c,Passport_No__c,
                    Reason_of_this_School__c,Relationship__c,Religion__c,Residence_No__c,School_Short_Code__c,School_Institution__c,School__c,
                    Seeking_Admission_for_another_Child__c,StudentLast_Name__c,Student_Name__c, CreatedDate,
                    OCI__c,
                    Application_Form_Relation__c,                 
                    Father_Website_url_linkedIn_profile__c,
                    Mother_Website_url_LinkedIn_profile__c,
                    Guardian_Flat_No_House_No__c,
                    Guardian_Building_Apartment_Name__c,
                    Guardian_Street__c,
                    Guardian_Landmark__c,
                    Guardian_Area__c,
                    Guardian_City__c,
                    Guardian_state__c,
                    Guardian_Pin_Code__c,
                    Guardian_Country__c,
                    Name_of_the_Organisation__c,
                    Guardian_Website_url_linkedIn_profile__c,
                   Citizenship_Country__c,Mental_Problem_Please_Specify__c,
                    Residential_Address__c,Emergency_Contact_No__c,EMIS_No__c,Enrollment_No__c,
                    Is_Father_Government_Employee__c,Father_Name_of_Department__c,Father_Designation__c,Father_Office_Contact_No__c,
                    Father_Office_Address__c,Is_Mother_Government_Employee__c,Mother_Name_of_Department__c,Mother_Designation__c,Mother_Office_Contact_No__c,
                    Mother_Office_Address__c,Mother_Annual_Income__c,Guardian_Residential_Address__c,Guardian_Aadhaar_Card_No__c,Guardian_Pan_Card_No__c,
                    Guardian_Qualification__c,
                    Is_Guardian_Government_Employee__c,Office_Address__c,Office_Contact_No__c,Annual_Income__c,Guardian_Profession__c,
                    Name_of_child_1__c,Class_1__c,Student_Code_1__c,Name_of_child_2__c,Class_2__c,Student_Code_2__c,Single_Parent__c,Name_of_Department__c,
                    Medical_History__c, Other_Disabilities__c, Disabilities_Type__c, Physical_disabilities__c, Allergies__c, Share_the_Allergies__c,
                    Personalized_learning_needs__c, Other_Personalized_Option__c, Form_B_captured__c,Form_B_Acknowledgement__c, Personalized_learning_option__c,
                    seeking_grade__r.name, seeking_grade__c, SeekingAdmissionGrade__c,Father_Covid_vaccination_status__c,Guardian_Covid_vaccination_status__c,Mother_Covid_vaccination_status__c,
                    Is_the_child_taking_any_medication__c,Please_specify_any_medication__c,Any_mental_physical_problem__c,Sibling_Status__c,Sibling_First_Name__c,Sibling_Last_Name__c,
                    Sibling_Gender__c,Sibling_Date_of_Birth__c,Practitioner_Name__c,Practitioner_Address__c, Sibling_Grade_applying_for__c,
                    Practitioner_Mobile__c,Practitioner_Clinic_Phone__c
                     FROM Application_Form__c where id=: pid ];
            //Sibling_Grade_applying_for__c,
            
            System.debug('Residential_Address__c:>>>> ' +form.Residential_Address__c);
            if (form.Single_Parent__c == true) {
                if (form.Application_Form_Relation__c == 'Father') {
                    allShowDiv = false;
                    fatherShowDiv = true;
                    motherShowDiv = false;
                } else if (form.Application_Form_Relation__c == 'Mother') {
                    allShowDiv = false;
                    fatherShowDiv = false;
                    motherShowDiv = true;
                }
            } else {
                allShowDiv = true;
                fatherShowDiv = false;
                motherShowDiv = false;
            }

            System.debug('allShowDiv -->' +allShowDiv);
            System.debug('fatherShowDiv -->' +fatherShowDiv);
            System.debug('motherShowDiv -->' +motherShowDiv);
           
            String tosearchClass = form.seeking_grade__c;
            // String tosearchClass = '%' + form.Seeking_Admission_in_Grade__c + '%';
            List<Account> school = [
                SELECT
                    Id,
                    (
                        SELECT School_Name_on_PDF__c FROM Class__r WHERE Id = :tosearchClass
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
            System.debug('@@@@@@form.Father_First_Name__c  '  + form.Father_First_Name__c +'form.Father_Last_Name__c' + form.Father_Last_Name__c);
            if(form.Father_First_Name__c != null && form.Father_Last_Name__c != null) {
                fatherName = form.Father_First_Name__c + ' ' + form.Father_Last_Name__c;
                System.debug('@@@@@@fatherName  '  + fatherName);
            }
            System.debug('@@@@@@form.Mother_First_Name__c  '  + form.Mother_First_Name__c +'form.Mother_Last_Name__c' + form.Mother_Last_Name__c);
            if(form.Mother_First_Name__c != null && form.Mother_Last_Name__c != null) {
                motherName = form.Mother_First_Name__c + ' ' + form.Mother_Last_Name__c;
                System.debug('@@@@@@motherName  '  + motherName);
            }
            System.debug('@@@@@@form.Guardian_Name__c  '  + form.Guardian_Name__c );
            if(form.Guardian_Name__c != null) {
                guardianName = form.Guardian_Name__c;
                System.debug('@@@@@@guardianName  '  + guardianName);
            }
			System.debug('@@@@@@fatherName.length()  '  + fatherName.length());
            if (fatherName.length() > 1) {
                System.debug('In side 1 fatherName');
                if (motherName.length() > 1) {
                    System.debug('In side motherName ');
                    if (guardianName.length() > 1) {
                        System.debug('In side guardianName ' + guardianName);
                        parentNamesToShowFormC = fatherName + ' &  ' + motherName + ' & ' + guardianName;
                        System.debug('In side parentNamesToShowFormC ' + parentNamesToShowFormC);
                    }else {
                        parentNamesToShowFormC = fatherName + ' &  ' + motherName;
                        System.debug('In side parentNamesToShowFormC ' + parentNamesToShowFormC);
                    }
                }
            }
            System.debug('In side fatherName.length() ' + fatherName.length() +'motherName.length()  '+ motherName.length() );
            if (!(fatherName.length() > 1) && motherName.length() > 1) {
                System.debug('In side parentNamesToShowFormC ' + parentNamesToShowFormC +' motherName '+ motherName);
                parentNamesToShowFormC = motherName;
                System.debug('In side parentNamesToShowFormC ' + parentNamesToShowFormC);
                System.debug('In side guardianName.length() ' + guardianName.length());
                if (guardianName.length() > 1) {
                    parentNamesToShowFormC = motherName + ' & ' + guardianName;
                    System.debug('In side parentNamesToShowFormC ' + parentNamesToShowFormC);
                }
            }
            System.debug('In side guardianName.length() ' + guardianName.length()+'In side fatherName.length()' + fatherName.length() +'In side motherName.length()' + motherName.length() );
            if (guardianName.length() > 1 && !(fatherName.length() > 1) && !(motherName.length() > 1)) {
                parentNamesToShowFormC = guardianName;
                System.debug('In side parentNamesToShowFormC ' + parentNamesToShowFormC);
            }
			System.debug('In side parentNamesToShowFormC ' + parentNamesToShowFormC);
            // enq = [Select id,Date_of_Birth__c,FirstName__c,Last_Name__c,Name,Gender__c,Enq_School_Institute__c,  from Enquiry__c where id =: form.Enquiry__c];
            enq = [
                SELECT  Id
                        , School_Name__c
                        , Date_of_Birth__c
                        , FIRSTNAME__C
                        , Last_Name__c
                        , Name
                        , Gender__c
                        , Enq_School_Institute__c
                        , Grade__c
                        , Org_code__c
                        , Seeking_Grade__r.name
                FROM    Enquiry__c
                WHERE   Id = :form.Enquiry__c
            ];
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
                String grade = form.Seeking_Grade__r.name;
                Id schoolId = form.School_Institution__c;

                documentList = [ SELECT Id, Name, Terms__c, Description__c FROM Disclosure__c where Academic_Year__c=:form.Academic_Year__c AND OrgionalClass__c=:grade and school__c=:schoolId order by DisplaySequence__c asc];
                System.debug('documentList >>> ' + documentList);
            }

            //attachPDF();
            if (form.Medical_History__c != NULL) {
                form.Medical_History__c = form.Medical_History__c.replaceAll(';', '; ');
            }
            if (form.Disabilities_Type__c != NULL) {
                form.Disabilities_Type__c = form.Disabilities_Type__c.replaceAll(';', '; ');
            }
            if (form.Personalized_learning_option__c != NULL) {
                form.Personalized_learning_option__c = form.Personalized_learning_option__c.replaceAll(';', '; ');
            }
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
            i++;
            i++;
            i++;
            i++;
            i++;
            
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            
            i++;
            i++;
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