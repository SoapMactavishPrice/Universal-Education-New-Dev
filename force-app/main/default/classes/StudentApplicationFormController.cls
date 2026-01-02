public without sharing class StudentApplicationFormController {
    
    @AuraEnabled
    public static String getApplicationFormId(String enquiryId) {
        try {
            List<Application_Form__c> forms = [
                SELECT Id
                FROM Application_Form__c
                WHERE Enquiry__c = :enquiryId 
                LIMIT 1
            ];
            
            if (!forms.isEmpty()) {
                System.debug('Found Application Form Id: ' + forms[0].Id);
                return forms[0].Id;
            } else {
                System.debug('No Application Form found for Enquiry Id: ' + enquiryId);
                return null;
            }
        } catch (Exception e) {
            System.debug('Error fetching Application Form: ' + e.getMessage());
            throw new AuraHandledException('Failed to get Application Form Id: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static Application_Form__c getApplicationFormObj(String enquiryId) {
        try {
            List<Application_Form__c> forms = [
                SELECT Id, Name
                FROM Application_Form__c
                WHERE Enquiry__c = :enquiryId 
                LIMIT 1
            ];
            
            if (!forms.isEmpty()) {
                return forms[0];
            } else {
                System.debug('No Application Form found for Enquiry Id: ' + enquiryId);
                return null;
            }
        } catch (Exception e) {
            System.debug('Error fetching Application Form: ' + e.getMessage());
            throw new AuraHandledException('Failed to get Application Form Id: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Enquiry__c getEnquiryObject(String enquiryId) {
        try {
            List<Enquiry__c> enquiryList = [
                SELECT Id, Name, Lead__c, School_Institution__c, School_Institution__r.School_Short_Code__c, Student_Full_Name__c, 
                    Gender__c, Curriculum__c, Seeking_Grade__c, Email__c, Mobile_No__c, Academic_Year__c, Application_Received__c,
                    Apartment_Society__c, Locality__c, Demographic_Pin_code__c, Current_school__c, Date_of_Birth__c
                FROM Enquiry__c 
                WHERE Id =: enquiryId
                ];
            
            if (!enquiryList.isEmpty()) {
                return enquiryList[0];
            } else {
                System.debug('No enquiry found with Id: ' + enquiryId);
                return null;
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static String saveStudentInfo(Map<String, Object> studentData) {
        System.debug('curriculam ==>'+(String)studentData.get('curriculum'));
        // Validate required fields
        if (!studentData.containsKey('leadRecordId') || studentData.get('leadRecordId') == null) {
            throw new AuraHandledException('Lead reference is required to create or update an application form');
        }

        Enquiry__c enq = [SELECT Id, OwnerId, Academic_Year__c, orgCode__c, School_Institution__r.School_Short_Code__c FROM Enquiry__c WHERE Id = :(String)studentData.get('enquiryId')];
        
        String academicYear = enq.Academic_Year__c;

        Application_Form__c applicationForm = new Application_Form__c();
        
        if (studentData.containsKey('id') && studentData.get('id') != null) {
            applicationForm.Id = (String)studentData.get('id');
        }
        System.debug('curriculam ==>'+(String)studentData.get('curriculum'));
        System.debug('mental picklist ==>'+(String)studentData.get('doesChildHaveMentalProblem'));
        applicationForm.Lead__c = (String)studentData.get('leadRecordId');
        applicationForm.Enquiry__c = (String)studentData.get('enquiryId');
        applicationForm.Academic_Year__c = (String)studentData.get('academicYear');
        applicationForm.Student_Name__c = (String)studentData.get('studentName');
        applicationForm.Gender__c = (String)studentData.get('gender');
        applicationForm.Curriculum__c = (String)studentData.get('curriculum');
        applicationForm.Category__c = (String)studentData.get('category');
        applicationForm.School_Institution__c = (String) studentData.get('gradeApplyingForSchool');
        applicationForm.Seeking_Grade__c = (String)studentData.get('gradeApplyingFor');
        applicationForm.Email_Address__c = (String)studentData.get('email');
        applicationForm.Mobile_Number__c = (String)studentData.get('mobileNumber');
        applicationForm.Nationality__c = (String)studentData.get('nationality');
        applicationForm.Any_mental_physical_problem__c = (String)studentData.get('doesChildHaveMentalProblem');
        applicationForm.Mental_Problem_Please_Specify__c = (String)studentData.get('specifyMentalProblem');
        if (applicationForm.Nationality__c == 'Indian') {
            applicationForm.Country_Code__c = '+91';
        }
        applicationForm.Country1__c = (String)studentData.get('country');
        applicationForm.Passport_No__c = (String)studentData.get('passportNo');
        if (studentData.get('expiryDate') == null || String.valueOf(studentData.get('expiryDate')).trim() == '') {
            applicationForm.Expiry_Date__c = null;
        }
        else {
            System.debug('expiryDate ==>'+studentData.get('expiryDate'));
            applicationForm.Expiry_Date__c = Date.valueOf((String)studentData.get('expiryDate'));
        }
        applicationForm.OCI_Visa__c = (String)studentData.get('ociVisa');
        applicationForm.Student_Flat_No_House_No__c = (String)studentData.get('flatNo');
        applicationForm.Student_Building_Apartment_Name__c = (String)studentData.get('buildingName');
        applicationForm.Student_Street__c = (String)studentData.get('street');
        applicationForm.Student_Landmark__c = (String)studentData.get('landmark');
        applicationForm.Address__c =
            (String.isNotBlank(applicationForm.Student_Flat_No_House_No__c)
                ? applicationForm.Student_Flat_No_House_No__c + ', '
                : '') +
            (String.isNotBlank(applicationForm.Student_Building_Apartment_Name__c)
                ? applicationForm.Student_Building_Apartment_Name__c + ', '
                : '') +
            (String.isNotBlank(applicationForm.Student_Street__c)
                ? applicationForm.Student_Street__c + ', '
                : '') +
            (String.isNotBlank(applicationForm.Student_Landmark__c)
                ? applicationForm.Student_Landmark__c + ', '
                : '') +
            (String.isNotBlank(applicationForm.City__c)
                ? applicationForm.City__c
                : '') +
            (String.isNotBlank(applicationForm.Pincode__c)
                ? ' - ' + applicationForm.Pincode__c
                : '') +
            (String.isNotBlank(applicationForm.State__c)
                ? ', ' + applicationForm.State__c
                : '');

        applicationForm.Residential_Address__c = applicationForm.Address__c;
        applicationForm.Student_Area__c = (String)studentData.get('area');
        applicationForm.City__c = (String)studentData.get('city');
        applicationForm.State__c = (String)studentData.get('state');
        applicationForm.Pincode__c = (String)studentData.get('pinCode');
        // applicationForm.Date_of_Birth__c = (Date)studentData.get('dob');
        if (studentData.get('dob') == null || String.valueOf(studentData.get('dob')).trim() == '') {
            applicationForm.Date_of_Birth__c = null;
        }
        else {
            String dobString = String.valueOf(studentData.get('dob'));
            applicationForm.Date_of_Birth__c = Date.valueOf(dobString);
            
            // applicationForm.Date_of_Birth__c = (Date)studentData.get('dob');
        }
        applicationForm.Birth_Place__c = (String)studentData.get('birthPlace');
        applicationForm.Religion__c = (String)studentData.get('religion');
        applicationForm.Caste__c = (String)studentData.get('caste');
        applicationForm.Mother_Tongue__c = (String)studentData.get('motherTongue');
        applicationForm.Is_Sibling__c = (Boolean)studentData.get('isSiblingInformation');
        applicationForm.Sibling_Status__c = (String)studentData.get('siblingStatus');
        // applicationForm.Adhaar_Card_No__c = Decimal.valueOf((String)studentData.get('aadharNo'));
        //
        applicationForm.Adhaar_Card_No__c = (String)studentData.get('aadharNo');
        //
        applicationForm.Student_UDISE_No__c = (String)studentData.get('udiseNo');
        applicationForm.Name_of_the_person__c = (String)studentData.get('contactName');
        applicationForm.Emergency_Contact_No__c = (String)studentData.get('countryCode')+(String)studentData.get('contactMobile');
        applicationForm.Relationship_with_the_Student__c = (String)studentData.get('contactRelation');
        applicationForm.Grade__c = (String)studentData.get('currentGrade');
        // applicationForm.Curriculum__c = (String)studentData.get('currentCurriculum');
        applicationForm.Past_School_Institute__c = (String)studentData.get('currentSchool');
        applicationForm.Past_School_Place__c = (String)studentData.get('currentPlace');
        applicationForm.Sibling_First_Name__c = (String)studentData.get('siblingFirstName');
        applicationForm.Sibling_Last_Name__c = (String)studentData.get('siblingLastName');
        applicationForm.Sibling_Gender__c = (String)studentData.get('siblingGender');
        if (String.isNotBlank((String) studentData.get('siblingDob'))) {
            applicationForm.Sibling_Date_of_Birth__c = Date.valueOf((String)studentData.get('siblingDob'));
        }
        applicationForm.Sibling_Current_School_Grade__c = (String)studentData.get('siblingGrade');
        applicationForm.Sibling_Grade_Applying_For__c = (String)studentData.get('siblingGradeApplyingFor');
        applicationForm.Sibling_Enrollment_Number__c = (String)studentData.get('siblingEnrollmentNumber');
        applicationForm.Sibling_School_Name__c = (String)studentData.get('siblingCurrentSchool');
        // applicationForm.Previous_First_Name__c = (String)studentData.get('previousFirstName');
        // applicationForm.Previous_Last_Name__c = (String)studentData.get('previousLastName');
        // applicationForm.Previous_Grade__c = (String)studentData.get('previousGrade');
        // applicationForm.Previous_Enrollment_No__c = (String)studentData.get('previousEnrollmentNo');
        applicationForm.Blood_Group__c = (String)studentData.get('bloodGroup');
        applicationForm.Is_the_child_taking_any_medication__c = (String)studentData.get('isChildTakingMedicine');
        applicationForm.Please_specify_any_medication__c = (String)studentData.get('specifyMedication');
        applicationForm.Allergies__c = (String)studentData.get('isChildHavingAllergy');
        applicationForm.Share_the_Allergies__c = (String)studentData.get('specifyAllergy');
        applicationForm.Practitioner_Name__c = (String)studentData.get('doctorName');
        applicationForm.Practitioner_Address__c = (String)studentData.get('doctorAddress');
        applicationForm.Practitioner_Clinic_Phone__c = (String)studentData.get('countryCode')+(String)studentData.get('doctorClinicPhone');
        applicationForm.Practitioner_Mobile__c = (String)studentData.get('countryCode')+(String)studentData.get('doctorMobile');
        applicationForm.IP_Address__c = (String)studentData.get('ipAddress');
        applicationForm.OS_Version_Name__c = (String)studentData.get('osVersionName');
        applicationForm.OS_Version__c = (String)studentData.get('osVersion');
        applicationForm.OS_Name__c = (String)studentData.get('osName');
        applicationForm.Platform_Used__c = (String)studentData.get('platform');
        applicationForm.Browser_Version__c = (String)studentData.get('browserVersion');
        applicationForm.Browser_Name__c = (String)studentData.get('browserName');
        applicationForm.SchoolShort_Code__c = enq.School_Institution__r.School_Short_Code__c;
        
        if (applicationForm.Id == null) {
            Integer i = 1;
            Integer k = 0;
            List < Application_Form__c > appList = [Select id, Autonumber_apexClass__c, School_Short_Code__c from Application_Form__c where Academic_Year__c =: academicYear and School_Short_Code__c =: enq.orgCode__c and Autonumber_apexClass__c > 0 order by createddate desc NULLS LAST limit 1];
            if (!appList.isEmpty())
                System.debug('Record----' + appList[0].id);
    
            if (!appList.isEmpty()) {
                k = i + Integer.valueOf(appList[0].Autonumber_apexClass__c);
                applicationForm.Name = 'APP/' + enq.Academic_Year__c + '/' + k;
                applicationForm.Autonumber_apexClass__c = k;
            } else {
                applicationForm.Name = 'APP/' + enq.Academic_Year__c + '/' + i;
                applicationForm.Autonumber_apexClass__c = i;
            }
        }
        
        UPSERT applicationForm;
        
        return applicationForm.Id;
        
    }
    
    @AuraEnabled
    public static Map<String, Object> getStudentInfo(String studentId) {
        try {
            Application_Form__c student = [
                SELECT Id, Academic_Year__c, Name,Student_Name__c, Gender__c, Curriculum__c, Seeking_Grade__c, Country1__c, Mental_Problem_Please_Specify__c,
                       Category__c, Sibling_Grade_applying_for__c, Email_Address__c, Mobile_Number__c,Lead__c, Is_Sibling__c, Sibling_Status__c, Sibling_Current_School_Grade__c,
                       Enquiry__c,Nationality__c, Country__c, Passport_No__c, Expiry_Date__c, OCI_Visa__c,Student_Flat_No_House_No__c,Student_Building_Apartment_Name__c,Student_Street__c,Student_Landmark__c, Student_Area__c, City__c,State__c,Pincode__c,Date_of_Birth__c,Birth_Place__c,Caste__c,Mother_Tongue__c, Country_Code__c,
                       Adhaar_Card_No__c,Student_UDISE_No__c,Religion__c,Name_of_the_person__c,Emergency_Contact_No__c,Relationship_with_the_Student__c,Grade__c,Past_School_Institute__c,Past_School_Place__c,Sibling_First_Name__c,Sibling_Last_Name__c,Sibling_Gender__c,Sibling_Date_of_Birth__c,Sibling_School_Name__c,Sibling_Enrollment_Number__c,Blood_Group__c,Is_the_child_taking_any_medication__c,Please_specify_any_medication__c,Allergies__c,Share_the_Allergies__c,Any_mental_physical_problem__c,Practitioner_Name__c,Practitioner_Address__c,Practitioner_Clinic_Phone__c,Practitioner_Mobile__c
                FROM Application_Form__c 
                WHERE Id = :studentId 
                LIMIT 1
            ];
            
            return new Map<String, Object>{
                'id' => student.Id,
                'academicYear' => student.Academic_Year__c,
                'studentName' => student.Student_Name__c,
                'gender' => student.Gender__c,
                'curriculum' => student.Curriculum__c,
                'countryCode' => student.Country_Code__c,
                'category' => student.Category__c,
                // 'gradeApplyingFor' => student.Seeking_Grade__c,
                'email' => student.Email_Address__c,
                'mobileNumber' => student.Mobile_Number__c,
                'leadRecordId' => student.Lead__c,
                'enquiryId' => student.Enquiry__c,
                'nationality' => student.Nationality__c,
                'country' => student.Country1__c,
                'passportNo' => student.Passport_No__c,
                'expiryDate' => student.Expiry_Date__c,
                'ociVisa' => student.OCI_Visa__c,
                // Residential and Personal Info
                'flatNo' => student.Student_Flat_No_House_No__c,
                'buildingName' => student.Student_Building_Apartment_Name__c,
                'street' => student.Student_Street__c,
                'landmark' => student.Student_Landmark__c,
                'area' => student.Student_Area__c,
                'city' => student.City__c,
                'state' => student.State__c,
                'pinCode' => student.Pincode__c,
                'dob' => student.Date_of_Birth__c,
                'birthPlace' => student.Birth_Place__c,
                'religion' => student.Religion__c,
                'caste' => student.Caste__c,
                'motherTongue' => student.Mother_Tongue__c,
                'aadharNo' => student.Adhaar_Card_No__c,
                'udiseNo' => student.Student_UDISE_No__c,
                'contactName' => student.Name_of_the_person__c,
                'contactMobile' => student.Emergency_Contact_No__c,
                'contactRelation' => student.Relationship_with_the_Student__c,
                'currentGrade' => student.Grade__c,
                // 'currentCurriculum' => student.Curriculum__c,
                'currentSchool' => student.Past_School_Institute__c,
                'currentPlace' => student.Past_School_Place__c,
                'siblingFirstName' => student.Sibling_First_Name__c,
                'siblingLastName' => student.Sibling_Last_Name__c,
                'siblingGender' => student.Sibling_Gender__c,
                'siblingDOB' => student.Sibling_Date_of_Birth__c,
                'siblingGradeApplyingFor' => student.Sibling_Grade_applying_for__c,
                'siblingGrade' => student.Sibling_Current_School_Grade__c,
                'isSiblingInformation' => student.Is_Sibling__c,
                'siblingStatus' => student.Sibling_Status__c,
                'siblingEnrollmentNumber' => student.Sibling_Enrollment_Number__c,
                'siblingCurrentSchool' => student.Sibling_School_Name__c,
                // 'previousFirstName' => student.Previous_First_Name__c,
                // 'previousLastName' => student.Previous_Last_Name__c,
                // 'previousGrade' => student.Previous_Grade__c,
                // 'previousEnrollmentNo' => student.Previous_Enrollment_No__c,
                'bloodGroup' => student.Blood_Group__c,
                'isChildTakingMedicine' => student.Is_the_child_taking_any_medication__c,
                'isChildHavingAllergy' => student.Allergies__c,
                'doesChildHaveMentalProblem' => student.Any_mental_physical_problem__c,
                'specifyMedication' => student.Please_specify_any_medication__c,
                'specifyAllergy' => student.Share_the_Allergies__c,
                'specifyMentalProblem' => student.Mental_Problem_Please_Specify__c,
                'doctorName' => student.Practitioner_Name__c,
                'doctorAddress' => student.Practitioner_Address__c,
                'doctorClinicPhone' => student.Practitioner_Clinic_Phone__c,
                'doctorMobile' => student.Practitioner_Mobile__c
            };
            
        } catch (Exception e) {
            throw new AuraHandledException('Error loading student information: ' + e.getMessage());
        }
    }
    
    private static ApplicationFormPage2Wrapper parseHeader(string js){
        return (ApplicationFormPage2Wrapper)system.JSON.deserialize(js,ApplicationFormPage2Wrapper.class);
    }
    
    @AuraEnabled
    public static String getNationality(String studentId) {
        return [SELECT Nationality__c FROM Application_Form__c WHERE Id =: studentId].Nationality__c;
    }
    
    @AuraEnabled
    public static ApplicationFormPage2Wrapper getStudentInfoPage2 (String studentId) {
        Application_Form__c student = [SELECT Father_First_Name__c, Father_Last_Name__c, Father_Phone__c, Father_Email_Id__c, Father_Aadhar_Card__c, Father_Pan_Card_No__c, Father_Qualification__c, Father_Occupation__c, Father_Name_of_Organisation__c, Father_Designation__c, Father_Office_Contact_No__c, Father_Office_Address__c, Father_Website_url_linkedIn_profile__c, Father_Annual_Income__c, Is_Father_Government_Employee__c, Father_Covid_vaccination_status__c, Relationship__c, Guardian_Country__c, Office_Address__c, Is_Guardian__c,
            Mother_First_Name__c, Mother_Last_Name__c, Mother_Phone__c, Mother_Email_Id__c, Mother_Adhaar_Card_No__c, Mother_Pan_Card_No__c, Mother_Qualification__c, Mother_Occupation__c, Mother_Name_of_Organisation__c, Mother_Designation__c, Mother_Office_Contact_No__c, Mother_Office_Address__c, Mother_Website_url_LinkedIn_profile__c, Mother_Annual_Income__c, Is_Mother_Government_Employee__c, Mother_Covid_vaccination_status__c, Office_Contact_No__c, Guardian_City__c, Annual_Income__c, Father_Name_of_Department__c, Name_of_Department__c,
            Guardian_Mobile_No__c, Guardian_Email_ID__c, Guardian_Aadhaar_Card_No__c, Guardian_Pan_Card_No__c, Guardian_Qualification__c, Guardian_Profession__c, Guardian_Designation__c, Guardian_Flat_No_House_No__c, Guardian_Street__c, Guardian_Pin_Code__c, Guardian_Website_url_linkedIn_profile__c, Is_Guardian_Government_Employee__c, Guardian_Covid_vaccination_status__c, Single_Parent__c, Application_Form_Relation__c, Country_Code__c, Guardian_Name__c, Guardian_state__c, Name_of_the_Organisation__c, Mother_Name_of_Department__c,
            Enquiry__r.Father_s_Educational_Qualifications__c, Enquiry__r.Mother_s_Educational_Qualifications__c, Enquiry__r.Father_s_Occupation__c, Enquiry__r.Mother_s_Occupation__c 
            FROM Application_Form__c WHERE Id = :studentId];
        
        return new ApplicationFormPage2Wrapper(student);
    }
    
    @AuraEnabled
    public static String saveStudentInfoPage2 (String studentWrapperStringObject) {
        
        ApplicationFormPage2Wrapper studentWrapper = parseHeader(studentWrapperStringObject);

        String countryCode = [SELECT Country_Code__c FROM Application_Form__c WHERE Id = :studentWrapper.studentId].Country_Code__c;
        
        Application_Form__c applicationForm = new Application_Form__c();
        
        applicationForm.Id = studentWrapper.studentId;
        applicationForm.Single_Parent__c = studentWrapper.isSingleParent;
        applicationForm.Application_Form_Relation__c = studentWrapper.singleParentRelation;
        
        applicationForm.Father_First_Name__c = studentWrapper.fatherFirstName;
        applicationForm.Father_Last_Name__c = studentWrapper.fatherLastName;
        if (String.isNotBlank(studentWrapper.fatherMobileNo)) {
            applicationForm.Father_Phone__c = countryCode + studentWrapper.fatherMobileNo;
        }
        applicationForm.Father_Email_Id__c = studentWrapper.fatherEmailId;
        applicationForm.Father_Aadhar_Card__c = studentWrapper.fatherAadhaarNo;
        applicationForm.Father_Pan_Card_No__c = studentWrapper.fatherPAN;
        applicationForm.Father_Qualification__c = studentWrapper.fatherEducationalQualification;
        applicationForm.Father_Occupation__c = studentWrapper.fatherProfession;
        applicationForm.Father_Name_of_Organisation__c = studentWrapper.fatherNameOfTheOrganisation;
        applicationForm.Father_Designation__c = studentWrapper.fatherDesignation;
        if (String.isNotBlank(studentWrapper.fatherOfficeContactNo)) {
            applicationForm.Father_Office_Contact_No__c = countryCode + studentWrapper.fatherOfficeContactNo;
        }
        applicationForm.Father_Office_Address__c = studentWrapper.fatherOfficeAddress;
        applicationForm.Father_Website_url_linkedIn_profile__c = studentWrapper.fatherWebsiteLinkedinProfile;
        applicationForm.Father_Annual_Income__c = studentWrapper.fatherAnnualIncome;
        applicationForm.Is_Father_Government_Employee__c = studentWrapper.fatherGovernmentEmployee;
        applicationForm.Father_Name_of_Department__c = studentWrapper.fatherNameOfDepartment;
        applicationForm.Father_Covid_vaccination_status__c = studentWrapper.fatherCovidVaccinationStatus;
        
        applicationForm.Mother_First_Name__c = studentWrapper.motherFirstName;
        applicationForm.Mother_Last_Name__c = studentWrapper.motherLastName;
        if (String.isNotBlank(studentWrapper.motherMobileNo)) {
            applicationForm.Mother_Phone__c = countryCode + studentWrapper.motherMobileNo;
        }
        applicationForm.Mother_Email_Id__c = studentWrapper.motherEmail;
        applicationForm.Mother_Adhaar_Card_No__c = studentWrapper.motherAadhaar;
        applicationForm.Mother_Pan_Card_No__c = studentWrapper.motherPAN;
        applicationForm.Mother_Qualification__c = studentWrapper.motherEducationalQualification;
        applicationForm.Mother_Occupation__c = studentWrapper.motherProfession;
        applicationForm.Mother_Name_of_Organisation__c = studentWrapper.motherNameOfTheOrganisation;
        applicationForm.Mother_Designation__c = studentWrapper.motherDesignation;
        if (String.isNotBlank(studentWrapper.motherOfficeContactNo)) {
            applicationForm.Mother_Office_Contact_No__c = countryCode + studentWrapper.motherOfficeContactNo;
        }
        applicationForm.Mother_Office_Address__c = studentWrapper.motherOfficeAddress;
        applicationForm.Mother_Website_url_LinkedIn_profile__c = studentWrapper.motherWebsiteLinkedInProfile;
        applicationForm.Mother_Annual_Income__c = studentWrapper.motherAnnualIncome;
        applicationForm.Is_Mother_Government_Employee__c = studentWrapper.motherGovernmentEmployee;
        applicationForm.Mother_Name_of_Department__c = studentWrapper.motherNameOfDepartment;
        applicationForm.Mother_Covid_vaccination_status__c = studentWrapper.motherCovidVaccinationStatus;
        
        if (String.isNotBlank(studentWrapper.guardianMobileNo)) {
            applicationForm.Guardian_Mobile_No__c = countryCode + studentWrapper.guardianMobileNo;
        }

        applicationForm.Is_Guardian__c = studentWrapper.isGuardian;
        if (studentWrapper.isGuardian) {
            applicationForm.Guardian_Name__c = studentWrapper.guardianName;
            applicationForm.Relationship__c = studentWrapper.guardianRelation;
            applicationForm.Guardian_City__c = studentWrapper.guardianCity;
            applicationForm.Guardian_state__c = studentWrapper.guardianState;
            applicationForm.Guardian_Country__c = studentWrapper.guardianCountry;
            applicationForm.Name_of_the_Organisation__c = studentWrapper.guardianNameOfTheOrganisation;
            applicationForm.Office_Contact_No__c = studentWrapper.guardianOfficeContactNo;
            applicationForm.Office_Address__c = studentWrapper.guardianOfficeAddress;
            applicationForm.Annual_Income__c = studentWrapper.guardianAnnualIncome;
            applicationForm.Guardian_Email_ID__c = studentWrapper.guardianEmailId;
            applicationForm.Guardian_Aadhaar_Card_No__c = studentWrapper.guardianAadhaarNo;
            applicationForm.Guardian_Pan_Card_No__c = studentWrapper.guardianPAN;
            applicationForm.Guardian_Qualification__c = studentWrapper.guardianEducationalQualification;
            applicationForm.Guardian_Profession__c = studentWrapper.guardianProfession;
            applicationForm.Guardian_Designation__c = studentWrapper.guardianDesignation;
            applicationForm.Guardian_Flat_No_House_No__c = studentWrapper.guardianFloorBuildingName;
            applicationForm.Guardian_Street__c = studentWrapper.guardianStreetLocality;
            applicationForm.Guardian_Pin_Code__c = studentWrapper.guardianPinCode;
            applicationForm.Guardian_Website_url_linkedIn_profile__c = studentWrapper.guardianWebsiteLinkedinProfile;
            applicationForm.Is_Guardian_Government_Employee__c = studentWrapper.guardianGovernmentEmployee;
            applicationForm.Name_of_Department__c = studentWrapper.guardianNameOfDepartment;
            applicationForm.Guardian_Covid_vaccination_status__c = studentWrapper.guardianCovidVaccinationStatus;
            applicationForm.Guardian_Residential_Address__c = applicationForm.Guardian_Flat_No_House_No__c + ', ' + applicationForm.Guardian_Street__c;
        }
        
        UPDATE applicationForm;
        
        return 'Success';
        
    }
    
    @AuraEnabled
    public static String saveStudentInfoPage3(Map<String, Object> filesToUpload, String studentId) {
        System.debug('studentId ==>'+studentId + ' filesToUpload ==>'+filesToUpload);
        if(!filesToUpload.isEmpty() && studentId != null && studentId != ''){
            
            List<ContentVersion> contentVersions = [SELECT Id, ContentDocumentId, Identifier__c, Description FROM ContentVersion WHERE Description IN :filesToUpload.keySet()];
            List<String> contentdocumentIds = new List<String>();
            for (Contentversion eachVersion:contentVersions) {
                contentdocumentIds.add(eachVersion.ContentDocumentId);
            }
            DELETE [SELECT Id FROM ContentDocument WHERE Id IN :contentdocumentIds];
            
            List<ContentVersion> contentVersionList = new List<ContentVersion>();
            
            for (String eachDataId : filesToUpload.keySet()) {
                Object attObj = filesToUpload.get(eachDataId);
                
                Map<Object, Object> att = (Map<Object, Object>) attObj;
                if (att != null) {
                    String fileName = (String) att.get('fileName');
                    String base64Str = (String) att.get('base64');
                    
                    ContentVersion cv = new ContentVersion();
                    cv.Title = eachDataId;
                    cv.Identifier__c = eachDataId;
                    cv.Description = eachDataId;
                    cv.PathOnClient = fileName;
                    cv.VersionData = EncodingUtil.base64Decode(base64Str);
                    contentVersionList.add(cv);
                }
            }
            
            insert contentVersionList;
            system.debug('contentVersionList-->'+contentVersionList.size());
            
            
            // Optional: Link to a record (like Account, Opportunity) via ContentDocumentLink
            List<ContentDocumentLink> docLinks = new List<ContentDocumentLink>();
            
            // Fetch inserted ContentDocumentIds
            List<ContentVersion> insertedCVs = [
                SELECT Id, ContentDocumentId, Identifier__c
                FROM ContentVersion
                WHERE Id IN :contentVersionList
            ];
            
            system.debug('insertedCVs-->'+insertedCVs.size());
            for (ContentVersion cv : insertedCVs) {
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cv.ContentDocumentId;
                cdl.LinkedEntityId = studentId;
                cdl.ShareType = 'V'; // Viewer (or 'C' for Collaborator, 'I' for Inferred)
                cdl.Visibility = 'AllUsers';
                docLinks.add(cdl);
            }
            
            // Insert links in bulk
            insert docLinks;
            
            system.debug('docLinks-->'+docLinks.size());
            
        }
        return 'Success';
    }
    
    public static String camelCaseToLabel(String input) {
        if (String.isBlank(input)) return '';
        
        String spaced = input.replaceAll('([a-z])([A-Z])', '$1 $2');
        
        List<String> words = spaced.split(' ');
        for (Integer i = 0; i < words.size(); i++) {
            words[i] = words[i].capitalize();
        }
        
        return String.join(words, ' ');
    }
    
    @AuraEnabled
    public static DocumentValidationWrapper getDocumentValidations(String studentId) {
        Application_Form__c student = [SELECT Single_Parent__c, Nationality__c, OCI_VISA__c, Grade__c, Application_Form_Relation__c, Caste__c, Is_Guardian__c FROM Application_Form__c WHERE Id = :studentId];
        
        DocumentValidationWrapper documentVal = new DocumentValidationWrapper();
        documentVal.isGuardian = student.Is_Guardian__c;
        documentVal.isSingleParent = student.Single_Parent__c;
        if (student.Single_Parent__c) {
            documentVal.singleParentRelation = student.Application_Form_Relation__c;
            if (student.Application_Form_Relation__c == 'Father') {
                documentVal.isSingleParentFather = true;
                documentVal.isSingleParentMother = false;
            } else if (student.Application_Form_Relation__c == 'Mother') {
                documentVal.isSingleParentFather = false;
                documentVal.isSingleParentMother = true;
            }
        }

        if (student.Caste__c == 'Gen') {
            documentVal.isCasteGen = true;
        } else {
            documentVal.isCasteGen = false;
        }

        if (student.Nationality__c == 'Indian') {
            documentVal.isFatherIndianCitizen = true;
            documentVal.isMotherIndianCitizen = true;
            documentVal.isForeign = false;
        } else {
            documentVal.isFatherIndianCitizen = false;
            documentVal.isMotherIndianCitizen = false;
            documentVal.isForeign = true;
        }
        if (student.OCI_VISA__c == 'Available') {
            documentVal.isOciVisaAvailable = true;
        } else {
            documentVal.isOciVisaAvailable = false;
        }
        
        return documentVal;
    }
    
    @AuraEnabled
    public static FormWrapper getDisclosure(String studentId, String schoolId, String classId, String academicYear) {
        System.debug('schoolId ==>'+schoolId+' classId ==>'+classId+' academicYear ==>'+academicYear);

        Application_Form__c applicationForm = [SELECT Father_First_Name__c, Father_Last_Name__c, Mother_First_Name__c, Mother_Last_Name__c, Guardian_Name__c, Student_Name__c FROM Application_Form__c WHERE Id = :studentId];

        List<String> namesList = new List<String>();

        // Father
        if (String.isNotBlank(applicationForm.Father_First_Name__c) || String.isNotBlank(applicationForm.Father_Last_Name__c)) {
            namesList.add(
                String.join(
                    new List<String>{
                        String.valueOf(applicationForm.Father_First_Name__c),
                        String.valueOf(applicationForm.Father_Last_Name__c)
                    },
                    ' '
                ).trim()
            );
        }

        // Mother
        if (String.isNotBlank(applicationForm.Mother_First_Name__c) || String.isNotBlank(applicationForm.Mother_Last_Name__c)) {
            namesList.add(
                String.join(
                    new List<String>{
                        String.valueOf(applicationForm.Mother_First_Name__c),
                        String.valueOf(applicationForm.Mother_Last_Name__c)
                    },
                    ' '
                ).trim()
            );
        }

        // Guardian
        if (String.isNotBlank(applicationForm.Guardian_Name__c)) {
            namesList.add(applicationForm.Guardian_Name__c.trim());
        }

        // Final string
        String finalNames = String.join(namesList, ' & ');

        List<Disclosure__c> disclosures = [SELECT Id, Terms__c, Name FROM Disclosure__c WHERE School__c = :schoolId AND Class__c = :classId AND Academic_Year__c = :academicYear];
        System.debug('disclosures'+disclosures);

        FormWrapper wrapper = new FormWrapper();
        wrapper.parentName = finalNames;
        wrapper.studentName = applicationForm.Student_Name__c;

        for (Disclosure__c eachDisclosure : disclosures) {
            if (eachDisclosure.Name.contains('Form C1')) {
                wrapper.formC1 = new FormLowWrapper(eachDisclosure, wrapper, 'formC1');
            } else if (eachDisclosure.Name.contains('Form C')) {
                wrapper.formC = new FormLowWrapper(eachDisclosure, wrapper, 'formC');
            } else if (eachDisclosure.Name.contains('Form D')) {
                wrapper.formD = new FormLowWrapper(eachDisclosure, wrapper, 'formD');
            } else if (eachDisclosure.Name.contains('Form E1')) {
                wrapper.formE1 = new FormLowWrapper(eachDisclosure, wrapper, 'formE1');
            } else if (eachDisclosure.Name.contains('Form E2')) {
                wrapper.formE2 = new FormLowWrapper(eachDisclosure, wrapper, 'formE2');
            }
        }
        return wrapper;
    }
    
    @AuraEnabled
    public static DocumentUploadWrapper getUploadedDocumentsInPage3(String studentId) {
        List<String> contentDocumentIds = new List<String>();
        List<ContentDocumentLink> contentDocumentLinks = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: studentId];
        
        for (ContentDocumentLink eachDl : contentDocumentLinks) {
            contentDocumentIds.add(eachDl.ContentDocumentId);
        }
        
        List<ContentVersion> contentVersions = [SELECT Id, ContentDocumentId, Identifier__c, Title FROM ContentVersion WHERE ContentDocumentId IN :contentDocumentIds];
        DocumentUploadWrapper wrapper = new DocumentUploadWrapper();
        for (ContentVersion eachCv : contentVersions) {
            if (eachCv.Title == 'StudentPhoto-'+studentId) {
                wrapper.isStudentPhotoUploaded = true;
            }
            if (eachCv.Title == 'FatherPhoto-'+studentId) {
                wrapper.isFatherPhotoUploaded = true;
            }
            if (eachCv.Title == 'MotherPhoto-'+studentId) {
                wrapper.isMotherPhotoUploaed = true;
            }
            if (eachCv.Title == 'FatherSignaturePhoto-'+studentId) {
                wrapper.isFatherSignatureUploaded = true;
            }
            if (eachCv.Title == 'MotherSignaturePhoto-'+studentId) {
                wrapper.isMotherSignatureUploaded = true;
            }
        }
        
        return wrapper;
    }
    
    @AuraEnabled
    public static List<Map<String, String>> getGrade(String schoolId){
        List<Class__c> classes = [SELECT Id, Name FROM Class__c WHERE School_Name__c = :schoolId];
        
        List<Map<String, String>> gradeOptions = new List<Map<String, String>>();
        
        for (Class__c eachClass : classes) {
            gradeOptions.add(new Map<String, String>{'label' => eachClass.Name, 'value' => eachClass.Id});
        }
        
        return gradeOptions;
    }

    @AuraEnabled
    public static List<Map<String, String>> getGradeForSibling(String schoolId){
        List<Class__c> classes = [SELECT Id, Name FROM Class__c WHERE School_Name__c = :schoolId];
        
        List<Map<String, String>> gradeOptions = new List<Map<String, String>>();
        
        for (Class__c eachClass : classes) {
            gradeOptions.add(new Map<String, String>{'label' => eachClass.Name, 'value' => eachClass.Name});
        }
        
        return gradeOptions;
    }

    @AuraEnabled
    public static Boolean isChildBelowGrade1(String studentId) {
        Application_Form__c student = [SELECT Seeking_Grade__r.Name FROM Application_Form__c WHERE Id = :studentId];
        String grade = student.Seeking_Grade__r.Name;
        System.debug(grade);

        return grade == 'Play Group' || grade == 'Nursery' || grade == 'Jr. Kg' || grade == 'Sr. Kg' || grade == 'Playgroup' || grade == 'Jr.Kg' || grade == 'Sr.Kg' || grade == 'Prep I' || grade == 'Prep II' || grade == 'PRE-KG' || grade == 'L-KG' || grade == 'U-KG' || grade == 'PREP-I' || grade == 'Prep-II' || grade == 'PYP-I' || grade == 'PYP-II' || grade == 'PYP-III' || grade == 'PYP-IV' || grade == 'PYP-V' || grade == 'LKG' || grade == 'UKG' || grade == 'Playgroup' || grade == 'JKG' || grade == 'SKG' || grade == 'Jr.Kg' || grade == 'Sr.Kg';
    }

    @AuraEnabled
    public static String redirectToPaymentPage(String enquiryId) {
        System.debug('enquiryId -> ' + enquiryId);
        Enquiry__c enq = [SELECT Id, School_Institution__r.School_Short_Code__c, Payment_Done__c FROM Enquiry__c WHERE Id = :enquiryId];

        Map<String, Universal_Application_Fee_Amount__mdt> schoolNameUAmdtMap = new Map<String, Universal_Application_Fee_Amount__mdt>();
        for (Universal_Application_Fee_Amount__mdt mdtUAFA : [SELECT MasterLabel, QualifiedApiName, Application_Fees__c, Merchant_ID__c, Payment_Applicable__c, Payment_Gateway__c, Short_Code__c 
                                                             FROM Universal_Application_Fee_Amount__mdt 
                                                             WHERE Short_Code__c = :enq.School_Institution__r.School_Short_Code__c]) {
            schoolNameUAmdtMap.put(mdtUAFA.Short_Code__c, mdtUAFA);
        }

        CC_Avenue_Settings__c ccAvenueSettings = CC_Avenue_Settings__c.getInstance();

        System.debug('schoolNameUAmdtMap -> ' + schoolNameUAmdtMap);
        System.debug('enq.School_Institution__r.School_Short_Code__c -> ' + enq.School_Institution__r.School_Short_Code__c);
        System.debug('enq.Payment_Done__c => -> ' + enq.Payment_Done__c + ' Contains => ' + schoolNameUAmdtMap.containsKey(enq.School_Institution__r.School_Short_Code__c));
        
        if (schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Applicable__c == true) {
            if (!enq.Payment_Done__c && schoolNameUAmdtMap.containsKey(enq.School_Institution__r.School_Short_Code__c)) {
                System.debug('Applicable -> ' + schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Applicable__c + ' Gateway ' + schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Gateway__c);
                if (schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Applicable__c && schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Gateway__c == 'HDFC') {
                    return ccAvenueSettings.SF_Site_URL__c + 'CCAvenuePaymentGateway?eid=' + enq.Id;
                }
                if (schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Gateway__c == 'RazorPay') {
                    return ccAvenueSettings.SF_Site_URL__c + 'ApplicationPaymentGateway?eid=' + enq.Id;
                }
            } else {
                return 'No Payment Required';
            }
        } else {
            return 'No Payment Required';
        }

        return 'No Payment Required';
    }

    @AuraEnabled
    public static void closeApplicationForm(String enquiryId) {
        Enquiry__c enquiry = new Enquiry__c(Id = enquiryId, Application_Received__c = true, Application_Form_Received__c = true);
        enquiry.Application_Form_Received_On_Date__c = System.now().format('dd-MM-yyyy', 'Asia/Kolkata');
        enquiry.Application_Form_Received_On_Time__c = DateTime.now().format('hh:mm a', 'Asia/Kolkata');
        enquiry.Application_Submitted_On__c = DateTime.now();
        enquiry.Stages__c = 'Application submitted';
        UPDATE enquiry;

        List<Application_Form__c> applicationForms = [SELECT Id, Application_Form_Received_On_Date__c, Application_Form_Received_On_Time__c FROM Application_Form__c WHERE Enquiry__c = :enquiryId];

        Application_Form__c applicationForm = null;
        if (!applicationForms.isEmpty()) {
            applicationForm = applicationForms[0];
            applicationForm.Application_Form_Received_On_Date__c = System.now().format('dd-MM-yyyy', 'Asia/Kolkata');
            applicationForm.Application_Form_Received_On_Time__c = DateTime.now().format('hh:mm a', 'Asia/Kolkata');
            applicationForm.Print_Copy_Submitted__c = true;
            UPDATE applicationForm;
        }

        Enquiry__c enq = [SELECT Id, Contact__c, Org_code__c, Contact__r.Lead_ID__c FROM Enquiry__c WHERE Id = :enquiryId LIMIT 1];

        if (enq.Contact__c != null && enq.Contact__r.Lead_ID__c != null) {
            Lead lead = [SELECT Id, Application_Form_Received__c, Application_Form_Received_On_Date__c, Application_Form_Received_On_Time__c, Lead_ID__c, Stage__c FROM Lead WHERE Lead_ID__c =: enq.Contact__r.Lead_ID__c];
            lead.Stage__c = 'Application submitted';
            lead.Application_Form_Received__c = true;
            lead.Application_Form_Received_On_Date__c = System.now().format('dd-MM-yyyy', 'Asia/Kolkata');
            lead.Application_Form_Received_On_Time__c = DateTime.now().format('hh:mm a', 'Asia/Kolkata');
            UPDATE lead;
        }

        boolean isEmailactive = false;
        string emailtemp;
        boolean notem = true;
        List < SchoolEmail__mdt > se = new list < SchoolEmail__mdt > ();
        se = [SELECT CCAddress__c, DisplayName__c, TempName__c, Active__c, Event__c, Object__c, SchoolShortcode__c FROM SchoolEmail__mdt WHERE SchoolShortcode__c =: enq.Org_code__c AND Event__c = 'Application Submitted'];
        
        if (se != null && se.size() > 0) {
            isEmailactive = se[0].Active__c;
            emailtemp = se[0].TempName__c;
        } else {
            notem = false;
        }
        if (isEmailactive) {
            SendEmail.SendEmailTemplateWithTemplate(emailtemp, enq.Contact__c, true, enq.id, se[0], null);
        }
        List<List_of_Document__c> listDoc = [SELECT Id, name, isOptional__c, isSubmitted__c, Submission_Date__c FROM List_of_Document__c];

        List<Document_Detail__c> docDetails = new List<Document_Detail__c>();

        DocumentValidationWrapper documentValidationObject = getDocumentValidations(applicationForm.Id);

        for(List_of_Document__c lod:listDoc) {
            Document_Detail__c dd = new Document_Detail__c();
            dd.Name = lod.Name;
            dd.Application_Form__c = applicationForm.Id;
            if (lod.Name == 'Student\'s photo') {
                dd.Mandatory__c = true;

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'StudentPhoto%'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'Student\'s Birth Certificate') {
                dd.Mandatory__c = true;

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'birthCertificate'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'Father\'s photo') {
                if (!documentValidationObject.isGuardian || documentValidationObject.isSingleParentFather) {
                    dd.Mandatory__c = false;
                } else {
                    dd.Mandatory__c = true;
                }

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'FatherPhoto%'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'Father\'s signature') {
                if (!documentValidationObject.isGuardian || documentValidationObject.isSingleParentMother) {
                    dd.Mandatory__c = false;
                } else {
                    dd.Mandatory__c = true;
                }

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'FatherSignaturePhoto%'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'Mother\'s photo') {
                if (!documentValidationObject.isGuardian || documentValidationObject.isSingleParentFather) {
                    dd.Mandatory__c = false;
                } else {
                    dd.Mandatory__c = true;
                }

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'MotherPhoto%'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'Mother\'s signature') {
                if (!documentValidationObject.isGuardian || documentValidationObject.isSingleParentFather) {
                    dd.Mandatory__c = false;
                } else {
                    dd.Mandatory__c = true;
                }

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'MotherSignaturePhoto%'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'Father\'s identity proof') {
                System.debug('documentValidationObject ==>' + documentValidationObject);
                if (documentValidationObject.isFatherIndianCitizen && !documentValidationObject.isSingleParentMother) {
                    dd.Mandatory__c = true;
                }

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'fatherAadharCard'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'Mother\'s identity proof') {
                if (documentValidationObject.isMotherIndianCitizen && !documentValidationObject.isSingleParentFather) {
                    dd.Mandatory__c = true;
                }

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'motherAadharCard'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'Guardian affidavit') {
                if (documentValidationObject.isGuardian) {
                    dd.Mandatory__c = true;
                }

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'affidavitForLegalGuardian'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'Single parent custody') {
                if (!documentValidationObject.isForeign && documentValidationObject.isSingleParent) {
                    dd.Mandatory__c = true;
                }

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'evidenceOrAffidavitForLegalGuardianship'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'Student\'s Caste Certificate') {
                if (!documentValidationObject.isForeign && !documentValidationObject.isCasteGen) {
                    dd.Mandatory__c = true;
                }

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'casteCertificate'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'OCI/Visa') {
                if (documentValidationObject.isForeign && documentValidationObject.isOciVisaAvailable) {
                    dd.Mandatory__c = true;
                }

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'ociVisa'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            if (lod.Name == 'Student\'s Passport') {
                if (documentValidationObject.isForeign) {
                    dd.Mandatory__c = true;
                }

                Boolean isPresent = [
                    SELECT COUNT()
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :applicationForm.Id
                    AND ContentDocument.Title LIKE 'passport'
                ] > 0;

                if (isPresent) {
                    dd.Submission_Status__c = 'Accepted';
                }
            }

            docDetails.add(dd);
        }
        insert docDetails;
    }
    
    public class ApplicationFormPage2Wrapper {
        
        @AuraEnabled public String studentId;
        @AuraEnabled public String leadRecordId;
        @AuraEnabled public Boolean isSingleParent;
        @AuraEnabled public String singleParentRelation;
        @AuraEnabled public String countryCode;
        
        // Father Information
        @AuraEnabled public String fatherFirstName;
        @AuraEnabled public String fatherLastName;
        @AuraEnabled public String fatherMobileNo;
        @AuraEnabled public String fatherEmailId;
        @AuraEnabled public String fatherAadhaarNo;
        @AuraEnabled public String fatherGradeApplyingFor;
        @AuraEnabled public String fatherPAN;
        @AuraEnabled public String fatherEducationalQualification;
        @AuraEnabled public String fatherProfession;
        @AuraEnabled public String fatherNameOfTheOrganisation;
        @AuraEnabled public String fatherDesignation;
        @AuraEnabled public String fatherOfficeContactNo;
        @AuraEnabled public String fatherOfficeAddress;
        @AuraEnabled public String fatherFloorBuildingName;
        @AuraEnabled public String fatherStreetLocality;
        @AuraEnabled public String fatherPinCode;
        @AuraEnabled public String fatherWebsiteLinkedinProfile;
        @AuraEnabled public Decimal fatherAnnualIncome;
        @AuraEnabled public String fatherGovernmentEmployee;
        @AuraEnabled public String fatherNameOfDepartment;
        @AuraEnabled public String fatherCovidVaccinationStatus;
        
        // Mother Information
        @AuraEnabled public String motherFirstName;
        @AuraEnabled public String motherLastName;
        @AuraEnabled public String motherMobileNo;
        @AuraEnabled public String motherEmail;
        @AuraEnabled public String motherAadhaar;
        @AuraEnabled public String motherGradeApplyingFor;
        @AuraEnabled public String motherPAN;
        @AuraEnabled public String motherEducationalQualification;
        @AuraEnabled public String motherProfession;
        @AuraEnabled public String motherNameOfTheOrganisation;
        @AuraEnabled public String motherDesignation;
        @AuraEnabled public String motherOfficeContactNo;
        @AuraEnabled public String motherOfficeAddress;
        @AuraEnabled public String motherFloorBuildingName;
        @AuraEnabled public String motherStreetLocality;
        @AuraEnabled public String motherPinCode;
        @AuraEnabled public String motherWebsiteLinkedInProfile;
        @AuraEnabled public Decimal motherAnnualIncome;
        @AuraEnabled public String motherGovernmentEmployee;
        @AuraEnabled public String motherNameOfDepartment;
        @AuraEnabled public String motherCovidVaccinationStatus;
        
        // Guardian Information
        @AuraEnabled public Boolean isGuardian;
        @AuraEnabled public String guardianName;
        @AuraEnabled public String guardianRelation;
        @AuraEnabled public String guardianCity;
        @AuraEnabled public String guardianState;
        @AuraEnabled public String guardianCountry;
        @AuraEnabled public String guardianMobileNo;
        @AuraEnabled public String guardianEmailId;
        @AuraEnabled public String guardianAadhaarNo;
        @AuraEnabled public String guardianGradeApplyingFor;
        @AuraEnabled public String guardianPAN;
        @AuraEnabled public String guardianEducationalQualification;
        @AuraEnabled public String guardianProfession;
        @AuraEnabled public String guardianNameOfTheOrganisation;
        @AuraEnabled public String guardianDesignation;
        @AuraEnabled public String guardianOfficeContactNo;
        @AuraEnabled public String guardianOfficeAddress;
        @AuraEnabled public String guardianFloorBuildingName;
        @AuraEnabled public String guardianStreetLocality;
        @AuraEnabled public String guardianPinCode;
        @AuraEnabled public String guardianWebsiteLinkedinProfile;
        @AuraEnabled public Decimal guardianAnnualIncome;
        @AuraEnabled public String guardianGovernmentEmployee;
        @AuraEnabled public String guardianNameOfDepartment;
        @AuraEnabled public String guardianCovidVaccinationStatus;
        
        public ApplicationFormPage2Wrapper() {
            
        }
        
        public ApplicationFormPage2Wrapper(Application_Form__c student) {
            
            this.countryCode = student.Country_Code__c;

            this.isSingleParent = student.Single_Parent__c;
            this.singleParentRelation = student.Application_Form_Relation__c;
            
            this.fatherFirstName = student.Father_First_Name__c;
            this.fatherLastName = student.Father_Last_Name__c;
            this.fatherEmailId = student.Father_Email_Id__c;
            this.fatherAadhaarNo = student.Father_Aadhar_Card__c;
            this.fatherMobileNo = student.Father_Phone__c;
            this.fatherOfficeContactNo = student.Father_Office_Contact_No__c;
            // this.fatherGradeApplyingFor = student.;
            this.fatherPAN = student.Father_Pan_Card_No__c;
            if (student.Father_Qualification__c != null && String.isNotBlank(student.Father_Qualification__c)) {
                this.fatherEducationalQualification = student.Father_Qualification__c;
            } else {
                this.fatherEducationalQualification = student.Enquiry__r.Father_s_Educational_Qualifications__c;
            }
            if (student.Father_Occupation__c != null && String.isNotBlank(student.Father_Occupation__c)) {
                this.fatherProfession = student.Father_Occupation__c;
            } else {
                this.fatherProfession = student.Enquiry__r.Father_s_Occupation__c;
            }
            this.fatherNameOfTheOrganisation = student.Father_Name_of_Organisation__c;
            this.fatherDesignation = student.Father_Designation__c;
            this.fatherOfficeAddress = student.Father_Office_Address__c;
            // this.fatherFloorBuildingName = student.;
            // this.fatherStreetLocality = student.;
            // this.fatherPinCode = student.;
            this.fatherWebsiteLinkedinProfile = student.Father_Website_url_linkedIn_profile__c;
            this.fatherAnnualIncome = student.Father_Annual_Income__c;
            this.fatherGovernmentEmployee = student.Is_Father_Government_Employee__c;
            this.fatherNameOfDepartment = student.Father_Name_of_Department__c;
            if (student.Father_Covid_vaccination_status__c != null) {
                this.fatherCovidVaccinationStatus = student.Father_Covid_vaccination_status__c;
            } else {
                this.fatherCovidVaccinationStatus = 'None';
            }
            
            this.motherFirstName = student.Mother_First_Name__c;
            this.motherLastName = student.Mother_Last_Name__c;
            this.motherEmail = student.Mother_Email_Id__c;
            this.motherAadhaar = student.Mother_Adhaar_Card_No__c;
            this.motherMobileNo = student.Mother_Phone__c;
            this.motherOfficeContactNo = student.Mother_Office_Contact_No__c;
            // this.motherGradeApplyingFor = student.;
            this.motherPAN = student.Mother_Pan_Card_No__c;
            if (student.Mother_Qualification__c != null && String.isNotBlank(student.Mother_Qualification__c)) {
                this.motherEducationalQualification = student.Mother_Qualification__c;
            } else {
                this.motherEducationalQualification = student.Enquiry__r.Mother_s_Educational_Qualifications__c;
            }

            if (student.Mother_Occupation__c != null && String.isNotBlank(student.Mother_Occupation__c)) {
                this.motherProfession = student.Mother_Occupation__c;
            } else {
                this.motherProfession = student.Enquiry__r.Mother_s_Occupation__c;
            }
            this.motherNameOfTheOrganisation = student.Mother_Name_of_Organisation__c;
            this.motherDesignation = student.Mother_Designation__c;
            this.motherOfficeAddress = student.Mother_Office_Address__c;
            // this.motherFloorBuildingName = student.;
            // this.motherStreetLocality = student.;
            // this.motherPinCode = student.;
            this.motherWebsiteLinkedInProfile = student.Mother_Website_url_LinkedIn_profile__c;
            this.motherAnnualIncome = student.Mother_Annual_Income__c;
            this.motherGovernmentEmployee = student.Is_Mother_Government_Employee__c;
            this.motherNameOfDepartment = student.Mother_Name_of_Department__c;
            if (student.Mother_Covid_vaccination_status__c != null) {
                this.motherCovidVaccinationStatus = student.Mother_Covid_vaccination_status__c;
            } else {
                this.motherCovidVaccinationStatus = 'None';
            }
            
            this.isGuardian = student.Is_Guardian__c;
            this.guardianRelation = student.Relationship__c;
            this.guardianCity = student.Guardian_City__c;
            this.guardianState = student.Guardian_state__c;
            this.guardianCountry = student.Guardian_Country__c;
            this.guardianNameOfTheOrganisation = student.Name_of_the_Organisation__c;
            this.guardianOfficeContactNo = student.Office_Contact_No__c;
            this.guardianOfficeAddress = student.Office_Address__c;
            this.guardianAnnualIncome = student.Annual_Income__c;
            this.guardianName = student.Guardian_Name__c;
            this.guardianMobileNo = student.Guardian_Mobile_No__c;
            this.guardianEmailId = student.Guardian_Email_ID__c;
            this.guardianAadhaarNo = student.Guardian_Aadhaar_Card_No__c;
            this.guardianPAN = student.Guardian_Pan_Card_No__c;
            this.guardianEducationalQualification = student.Guardian_Qualification__c;
            this.guardianProfession = student.Guardian_Profession__c;
            this.guardianDesignation = student.Guardian_Designation__c;
            this.guardianOfficeContactNo = student.Office_Contact_No__c;
            this.guardianOfficeAddress = student.Office_Address__c;
            this.guardianFloorBuildingName = student.Guardian_Flat_No_House_No__c;
            this.guardianStreetLocality = student.Guardian_Street__c;
            this.guardianPinCode = student.Guardian_Pin_Code__c;
            this.guardianWebsiteLinkedinProfile = student.Guardian_Website_url_linkedIn_profile__c;
            this.guardianAnnualIncome = student.Annual_Income__c;
            this.guardianGovernmentEmployee = student.Is_Guardian_Government_Employee__c;
            this.guardianNameOfDepartment = student.Name_of_Department__c;
            if (student.Guardian_Covid_vaccination_status__c != null) {
                this.guardianCovidVaccinationStatus = student.Guardian_Covid_vaccination_status__c;
            } else {
                this.guardianCovidVaccinationStatus = 'None';
            }
        }
    }
    
    public class DocumentValidationWrapper {
        @AuraEnabled public Boolean isSingleParent;
        @AuraEnabled public Boolean isGuardian;
        @AuraEnabled public String singleParentRelation;
        @AuraEnabled public Boolean isSingleParentFather;
        @AuraEnabled public Boolean isSingleParentMother;
        @AuraEnabled public Boolean isFatherIndianCitizen;
        @AuraEnabled public Boolean isMotherIndianCitizen;
        @AuraEnabled public Boolean isOciVisaAvailable;
        @AuraEnabled public Boolean isChildAboveGrade1;
        @AuraEnabled public Boolean isForeign;
        @AuraEnabled public Boolean isCasteGen;
    }
    
    public class DocumentUploadWrapper {
        @AuraEnabled public Boolean isStudentPhotoUploaded;
        @AuraEnabled public Boolean isFatherPhotoUploaded;
        @AuraEnabled public Boolean isMotherPhotoUploaed;
        @AuraEnabled public Boolean isFatherSignatureUploaded;
        @AuraEnabled public Boolean isMotherSignatureUploaded;
    }
    
    public class FormWrapper {
        @AuraEnabled public String studentName;
        @AuraEnabled public String parentName;
        @AuraEnabled public FormLowWrapper formC;
        @AuraEnabled public FormLowWrapper formC1;
        @AuraEnabled public FormLowWrapper formD;
        @AuraEnabled public FormLowWrapper formE1;
        @AuraEnabled public FormLowWrapper formE2;
    }
    
    public class FormLowWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String terms;
        
        FormLowWrapper(Disclosure__c disclosure, FormWrapper header, String formType) {
            String intialBody = 'We <b> ' + header.parentName + '</b>  parents/guardians of <b> ' + header.studentName +' </b> ';
            this.name = disclosure.Name;

            if (formType.contains('formC')) {
                this.terms = intialBody + disclosure.Terms__c;
            } else {
                this.terms = disclosure.Terms__c;
            }
        }
    }
}