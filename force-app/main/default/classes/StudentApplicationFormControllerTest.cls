@isTest
public class StudentApplicationFormControllerTest {

    @isTest
    public static void testSetupMethod() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        // Create test school
        RecursiveTriggerHandler.skipTrigger = true;
        Account school = new Account(
            Name = 'Test School',
            School_Short_Code__c = 'TS'
        );
        insert school;
        
        // Create test class/grade
        Class__c grade = new Class__c(
            Name = 'Grade 1',
            School_Name__c = school.Id
        );
        insert grade;
        
        // Create test lead
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Email = 'test@example.com',
            Phone = '1234567890'
        );
        insert testLead;
        
        // Create test enquiry
        Enquiry__c enquiry = new Enquiry__c(
            Name = 'Test Enquiry',
            Lead__c = testLead.Id,
            School_Institution__c = school.Id,
            Gender__c = 'Male',
            Curriculum__c = 'CBSE',
            Seeking_Grade__c = grade.Id,
            Email__c = 'student@example.com',
            Mobile_No__c = '9876543210',
            Academic_Year__c = '2023-2024',
            orgCode__c = 'TS'
        );
        insert enquiry;
        
        // Create test application form
        Application_Form__c appForm = new Application_Form__c(
            Name = 'APP/2023-2024/1',
            Enquiry__c = enquiry.Id,
            Lead__c = testLead.Id,
            Academic_Year__c = '2023-2024',
            Student_Name__c = 'Test Student',
            School_Institution__c = school.Id,
            Gender__c = 'Male',
            Curriculum__c = 'CBSE',
            Seeking_Grade__c = grade.Id,
            Email_Address__c = 'student@example.com',
            Mobile_Number__c = '9876543210',
            Autonumber_apexClass__c = 1
        );
        insert appForm;
        
        // Create test disclosure forms
        Disclosure__c formC = new Disclosure__c(
            Name = 'Form C',
            School__c = school.Id,
            Class__c = grade.Id,
            Academic_Year__c = '2023-2024',
            Terms__c = 'Test Terms for Form C',
            Description__c = 'Form E2'
        );
        
        Disclosure__c formD = new Disclosure__c(
            Name = 'Form D',
            School__c = school.Id,
            Class__c = grade.Id,
            Academic_Year__c = '2023-2024',
            Terms__c = 'Test Terms for Form D',
            Description__c = 'Form E2'
        );
        
        Disclosure__c formE1 = new Disclosure__c(
            Name = 'Form E1',
            School__c = school.Id,
            Class__c = grade.Id,
            Academic_Year__c = '2023-2024',
            Terms__c = 'Test Terms for Form E1',
            Description__c = 'Form E2'
        );
        
        Disclosure__c formE2 = new Disclosure__c(
            Name = 'Form E2',
            School__c = school.Id,
            Class__c = grade.Id,
            Academic_Year__c = '2023-2024',
            Terms__c = 'Test Terms for Form E2',
            Description__c = 'Form E2'
        );

        // Create CC_Avenue_Settings__c custom setting
        CC_Avenue_Settings__c ccSettings = new CC_Avenue_Settings__c(
            SF_Site_URL__c = 'https://test.salesforce.com/'
        );
        insert ccSettings;

        // Create List_of_Document__c records with exact spelling from apex class
        List<List_of_Document__c> listDocs = new List<List_of_Document__c>();

        listDocs.add(new List_of_Document__c(
            Name = 'Student\'s photo',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'Student\'s Birth Certificate',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'Father\'s photo',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'Father\'s signature',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'Mother\'s photo',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'Mother\'s signature',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'Father\'s identity proof',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'Mother\'s identity proof',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'Guardian affidavit',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'Single parent custody',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'Student\'s Caste Certificate',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'OCI/Visa',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        listDocs.add(new List_of_Document__c(
            Name = 'Student\'s Passport',
            isOptional__c = false,
            isSubmitted__c = false
        ));

        insert listDocs;
        
        insert new List<Disclosure__c>{formC, formD, formE1, formE2};
        testGetApplicationFormId();
        testGetApplicationFormObj();
        testGetEnquiryObject();
        testSaveStudentInfo();
        testGetStudentInfo();
        testGetNationality();
        testGetStudentInfoPage2();
        testSaveStudentInfoPage2();
        testSaveStudentInfoPage3();
        testGetDocumentValidations();
        testGetDisclosure();
        testGetUploadedDocumentsInPage3();
        testGetGrade();
        testIsChildBelowGrade1();
        testCloseApplicationForm();
        testCamelCaseToLabel();
        testRedirectToPaymentPage();
        RecursiveTriggerHandler.skipTrigger = false;
    }

    static void testRedirectToPaymentPage() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Enquiry__c enquiry = [SELECT Id FROM Enquiry__c LIMIT 1];
        
        String result = StudentApplicationFormController.redirectToPaymentPage(enquiry.Id);
    }
    
    
    static void testGetApplicationFormId() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Enquiry__c enquiry = [SELECT Id FROM Enquiry__c LIMIT 1];
        
        
        String formId = StudentApplicationFormController.getApplicationFormId(enquiry.Id);
        
    }
    
    
    static void testGetApplicationFormObj() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Enquiry__c enquiry = [SELECT Id FROM Enquiry__c LIMIT 1];
        
        
        Application_Form__c form = StudentApplicationFormController.getApplicationFormObj(enquiry.Id);
        
        
        
    }
    
    
    static void testGetEnquiryObject() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Enquiry__c enquiry = [SELECT Id FROM Enquiry__c LIMIT 1];
        
        
        Enquiry__c result = StudentApplicationFormController.getEnquiryObject(enquiry.Id);
        
        
        
    }
    
    
    static void testSaveStudentInfo() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Enquiry__c enquiry = [SELECT Id, Academic_Year__c FROM Enquiry__c LIMIT 1];
        Application_Form__c appForm = [SELECT Id FROM Application_Form__c LIMIT 1];
        
        Map<String, Object> studentData = new Map<String, Object>{
            'id' => appForm.Id,
            'leadRecordId' => [SELECT Id FROM Lead LIMIT 1].Id,
            'enquiryId' => enquiry.Id,
            'academicYear' => enquiry.Academic_Year__c,
            'studentName' => 'Updated Student',
            'gender' => 'Female',
            'curriculum' => 'ICSE',
            'category' => 'General',
            'email' => 'updated@example.com',
            'mobileNumber' => '9876543211',
            'nationality' => 'Indian',
            'doesChildHaveMentalProblem' => 'No',
            'country' => 'India',
            'dob' => '2000-01-01',
            'birthPlace' => 'Test City',
            'religion' => 'Hindu',
            'caste' => 'Gen',
            'motherTongue' => 'Hindi',
            'aadharNo' => '123456789012',
            'udiseNo' => 'UDISE123',
            'contactName' => 'Test Contact',
            'contactMobile' => '9876543210',
            'contactRelation' => 'Father',
            'currentGrade' => 'KG',
            'currentSchool' => 'Test School',
            'currentPlace' => 'Test City',
            'isSiblingInformation' => false,
            'bloodGroup' => 'A+',
            'isChildTakingMedicine' => 'No',
            'isChildHavingAllergy' => 'No',
            'countryCode' => '+91'
        };
        
        
        String result = StudentApplicationFormController.saveStudentInfo(studentData);
        
        
        
        
        Application_Form__c updatedForm = [SELECT Student_Name__c, Gender__c FROM Application_Form__c WHERE Id = :appForm.Id];
        
        
    }
    
    
    static void testGetStudentInfo() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = [SELECT Id FROM Application_Form__c LIMIT 1];
        
        
        Map<String, Object> result = StudentApplicationFormController.getStudentInfo(appForm.Id);
        
        
        
        
    }
    
    
    static void testGetNationality() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = [SELECT Id FROM Application_Form__c LIMIT 1];
        
        
        String nationality = StudentApplicationFormController.getNationality(appForm.Id);
        
        
        
    }
    
    
    static void testGetStudentInfoPage2() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = [SELECT Id FROM Application_Form__c LIMIT 1];
        
        
        StudentApplicationFormController.ApplicationFormPage2Wrapper wrapper = 
            StudentApplicationFormController.getStudentInfoPage2(appForm.Id);
        
        
        
    }
    
    
    static void testSaveStudentInfoPage2() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = [SELECT Id, Country_Code__c FROM Application_Form__c LIMIT 1];
        
        StudentApplicationFormController.ApplicationFormPage2Wrapper wrapper = 
            new StudentApplicationFormController.ApplicationFormPage2Wrapper();
        wrapper.studentId = appForm.Id;
        wrapper.countryCode = appForm.Country_Code__c;
        wrapper.isSingleParent = false;
        wrapper.fatherFirstName = 'Test Father';
        wrapper.fatherLastName = 'Last';
        wrapper.fatherMobileNo = '9876543210';
        wrapper.fatherEmailId = 'father@example.com';
        wrapper.fatherAadhaarNo = '123456789012';
        wrapper.fatherPAN = 'ABCDE1234F';
        wrapper.fatherEducationalQualification = 'Graduate';
        wrapper.fatherProfession = 'Engineer';
        wrapper.fatherNameOfTheOrganisation = 'Test Org';
        wrapper.fatherDesignation = 'Manager';
        wrapper.fatherOfficeContactNo = '9876543210';
        wrapper.fatherOfficeAddress = 'Test Address';
        wrapper.fatherWebsiteLinkedinProfile = 'test.com';
        wrapper.fatherAnnualIncome = 100000;
        wrapper.fatherGovernmentEmployee = 'No';
        wrapper.fatherCovidVaccinationStatus = 'Fully';
        
        wrapper.motherFirstName = 'Test Mother';
        wrapper.motherLastName = 'Last';
        wrapper.motherMobileNo = '9876543211';
        wrapper.motherEmail = 'mother@example.com';
        wrapper.motherAadhaar = '123456789013';
        wrapper.motherPAN = 'ABCDE1234G';
        wrapper.motherEducationalQualification = 'Graduate';
        wrapper.motherProfession = 'Teacher';
        wrapper.motherNameOfTheOrganisation = 'Test School';
        wrapper.motherDesignation = 'Teacher';
        wrapper.motherOfficeContactNo = '9876543211';
        wrapper.motherOfficeAddress = 'Test Address';
        wrapper.motherWebsiteLinkedInProfile = 'test.com';
        wrapper.motherAnnualIncome = 80000;
        wrapper.motherGovernmentEmployee = 'No';
        wrapper.motherCovidVaccinationStatus = 'Fully';

        wrapper.isGuardian = true;
        wrapper.guardianName = 'Ramesh Kumar';
        wrapper.guardianRelation = 'Uncle';
        wrapper.guardianCity = 'Bengaluru';
        wrapper.guardianState = 'Karnataka';
        wrapper.guardianCountry = 'India';
        wrapper.guardianMobileNo = '9876543210';
        wrapper.guardianEmailId = 'ramesh.kumar@example.com';
        wrapper.guardianAadhaarNo = '1234-5678-9012';
        wrapper.guardianGradeApplyingFor = 'Grade 5';
        wrapper.guardianPAN = 'ABCDE1234F';
        wrapper.guardianEducationalQualification = 'MBA';
        wrapper.guardianProfession = 'Businessman';
        wrapper.guardianNameOfTheOrganisation = 'Kumar Enterprises Pvt Ltd';
        wrapper.guardianDesignation = 'Managing Director';
        wrapper.guardianOfficeContactNo = '080-23456789';
        wrapper.guardianOfficeAddress = '123 MG Road, Bengaluru';
        wrapper.guardianFloorBuildingName = 'Flat 201, Green Residency';
        wrapper.guardianStreetLocality = 'Indiranagar';
        wrapper.guardianPinCode = '560038';
        wrapper.guardianWebsiteLinkedinProfile = 'https://www.linkedin.com/in/ramesh-kumar';
        wrapper.guardianAnnualIncome = 1500000; // 15 Lakhs
        wrapper.guardianGovernmentEmployee = 'No';
        wrapper.guardianNameOfDepartment = null; // not applicable
        wrapper.guardianCovidVaccinationStatus = 'Fully';
        
        String wrapperJson = JSON.serialize(wrapper);
        
        
        String result = StudentApplicationFormController.saveStudentInfoPage2(wrapperJson);
        
        
        
        
        Application_Form__c updatedForm = [SELECT Father_First_Name__c, Mother_First_Name__c FROM Application_Form__c WHERE Id = :appForm.Id];
        
        
    }
    
    
    static void testSaveStudentInfoPage3() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = [SELECT Id FROM Application_Form__c LIMIT 1];
        
        // Create test content version
        ContentVersion cv = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'TestDocument.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true,
            Identifier__c = 'studentPhoto'
        );
        insert cv;
        
        // Get the content document ID
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        // Create content document link
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = appForm.Id,
            ContentDocumentId = cv.ContentDocumentId,
            ShareType = 'V'
        );
        insert cdl;
        
        Map<String, Object> filesToUpload = new Map<String, Object>{
            'fatherPhoto' => new Map<Object, Object>{
                'fileName' => 'father.jpg',
                'base64' => EncodingUtil.base64Encode(Blob.valueOf('Test Father Photo'))
            }
        };
        
        
        String result = StudentApplicationFormController.saveStudentInfoPage3(filesToUpload, appForm.Id);
        
        
        
        
        // Verify the document was uploaded
        List<ContentDocumentLink> links = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :appForm.Id];
        
    }
    
    
    static void testGetDocumentValidations() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = [SELECT Id FROM Application_Form__c LIMIT 1];
        
        
        StudentApplicationFormController.DocumentValidationWrapper wrapper = 
            StudentApplicationFormController.getDocumentValidations(appForm.Id);
        
        
        
    }
    
    
    static void testGetDisclosure() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Account school = [SELECT Id FROM Account LIMIT 1];
        Class__c grade = [SELECT Id FROM Class__c LIMIT 1];
        Application_Form__c appForm = [SELECT Id FROM Application_Form__c LIMIT 1];
        
        
        StudentApplicationFormController.FormWrapper wrapper = 
            StudentApplicationFormController.getDisclosure(appForm.Id, school.Id, grade.Id, '2023-2024');
        
        
    }
    
    
    static void testGetUploadedDocumentsInPage3() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = [SELECT Id FROM Application_Form__c LIMIT 1];
        
        // Create test content version
        ContentVersion cv = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'TestDocument.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true,
            Identifier__c = 'studentPhoto'
        );
        insert cv;
        
        // Get the content document ID
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        // Create content document link
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = appForm.Id,
            ContentDocumentId = cv.ContentDocumentId,
            ShareType = 'V'
        );
        insert cdl;
        
        
        StudentApplicationFormController.DocumentUploadWrapper wrapper = 
            StudentApplicationFormController.getUploadedDocumentsInPage3(appForm.Id);
        
        
        
        
    }
    
    
    static void testGetGrade() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Account school = [SELECT Id FROM Account LIMIT 1];
        
        
        List<Map<String, String>> grades = StudentApplicationFormController.getGrade(school.Id);
        
        
        
    }
    
    
    static void testIsChildBelowGrade1() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = [SELECT Id FROM Application_Form__c LIMIT 1];
        
        
        Boolean result = StudentApplicationFormController.isChildBelowGrade1(appForm.Id);
        
        
        
    }
    
    
    static void testCloseApplicationForm() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Enquiry__c enquiry = [SELECT Id FROM Enquiry__c LIMIT 1];
        
        
        StudentApplicationFormController.closeApplicationForm(enquiry.Id);
        
        
        Enquiry__c updatedEnquiry = [SELECT Application_Received__c FROM Enquiry__c WHERE Id = :enquiry.Id];
        
    }
    
    
    static void testCamelCaseToLabel() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        
        String result = StudentApplicationFormController.camelCaseToLabel('testCamelCase');
        
        
        
    }
}