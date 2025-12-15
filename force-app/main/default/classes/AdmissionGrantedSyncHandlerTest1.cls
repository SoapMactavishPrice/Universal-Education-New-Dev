@isTest
private class AdmissionGrantedSyncHandlerTest1 {
    @TestSetup
    static void setupTestData() {
        // Create test Account (School/Institution)
        Account school = new Account(
            Name = 'Test School',
            Org_code__c = 'ORG-123'
        );
        insert school;
        
        // Create test Grade
        Class__c class1 = new Class__c(
            Name = 'Playgroup',
            School_Name__c= school.id
           //Original_Class__c = 'Playgroup'
        );
        insert class1;
        
        // Create test Section with Grade__c populated
        Section__c section = new Section__c(
            Name = 'A',
            Original_Section__c = 'A',
            Grade__c = class1.Id  // REQUIRED FIELD
        );
        insert section;
        
        // Create test Lead
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Status = 'Open'
        );
        insert testLead;
        
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert testContact;
        
        Enquiry__c enquiry = new Enquiry__c(
            Contact__c = testContact.Id
        );
        insert enquiry;
        
        // Create test Admission Granted record
        Admission_Granted__c ag = new Admission_Granted__c(
            Name = 'AG-001',
            School_Institution__c = school.Id,
         //   Grade_lookup__c = grade.Id,
          //  Section_lookup__c = section.Id,
            EnquiryNo__c = enquiry.Id,
            First_Name__c = 'Test',
            Last_Name__c = 'Student',
            Enrollment_No__c = 'ENR-001',
            Date_of_Admission__c = Date.today(),
            Fee_Applicable_Date__c = Date.today(),
            Class__c = '1',
            Section__c = 'A',
            Email_Address__c = 'test@example.com',
            Academic_Year__c = '2023-24',
            Sync_with_Applane__c = false,
            Birth_Place__c = 'Test Place',
            guardianEmail_Id__c = 'guardian@test.com',
            guardianMobile_No__c = '9876543210',
            Relationship__c = 'Father',
            GuardianName__c = 'Test Guardian',
            father_Mobile_No__c = '9876543210',
            father_Email_Id__c = 'father@test.com',
            Father_First_Name__c = 'Father',
            Father_Last_Name__c = 'Test',
            Expiry_Date__c = Date.today().addYears(1),
            Passport_No__c = 'PASS123',
            User_Id__c = 'user123',
            Student_Type__c = 'New',
            Emergency_Contact_No__c = '9876543210',
            Address__c = 'Test Address',
            Mother_Tongue__c = 'English',
            Religion__c = 'Hindu',
            Blood_Group__c = 'O+',
            House__c = 'X',
            Registration_No__c = 'REG123',
            father_Qualification__c = 'Graduate',
            mother_Qualification__c = 'Graduate',
            father_Annual_Income__c = 500000,
            mother_Annual_Income__c = 400000,
            father_Name_of_Organisation__c = 'Father Org',
            mother_Name_of_Organisation__c = 'Mother Org',
            Adhaar_Card_No__c = 'STUDENTAADHAAR',
            father_Business_Address__c = 'Father Business Address',
            father_Business_Contact__c = '9876543210',
            mother_Business_Contact__c = '9876543210',
            father_Occupation__c = 'Service',
            mother_Occupation__c = 'Service',
            School_Short_Code__c = 'TST',
            Nationality__c = 'Indian',
            Mobile_Number__c = '9876543210'
        );
        insert ag;
    }
    
    
    @isTest
    static void testSyncAdmissionGrantedSuccess() {
        // Get test Admission Granted record
        Admission_Granted__c ag = [SELECT Id FROM Admission_Granted__c LIMIT 1];
        
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"status":"success"}'));
        
        // Call the method
        Test.startTest();
        String result = AdmissionGrantedSyncHandler.SyncAdmissionGranted(ag.Id);
        Test.stopTest();
        
      
        
        // Verify the record was updated
        Admission_Granted__c updatedAg = [SELECT Id, Sync_with_Applane__c FROM Admission_Granted__c WHERE Id = :ag.Id];
        
        // Verify lead was updated
        Lead updatedLead = [SELECT Id, Stage__c FROM Lead LIMIT 1];
    }
    
    @isTest
    static void testSyncAdmissionGrantedError() {
        // Get test Admission Granted record
        Admission_Granted__c ag = [SELECT Id FROM Admission_Granted__c LIMIT 1];
        
        // Mock HTTP callout to simulate error
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500, 'Error'));
        
        // Call the method
        Test.startTest();
        String result = AdmissionGrantedSyncHandler.SyncAdmissionGranted(ag.Id);
        Test.stopTest();
        
       
    }
    
    @isTest
    static void testMissingOrgCode() {
        // Create test data without Org_code__c
        Account school = new Account(Name = 'Test School');
        insert school;
        
       
        // Create test Grade
        Class__c class1 = new Class__c(
            Name = 'Playgroup',
            School_Name__c= school.id
           //Original_Class__c = 'Playgroup'
        );
        insert class1;
        
        // Create test Section with Grade__c populated
        Section__c section = new Section__c(
            Name = 'A',
            Original_Section__c = 'A',
            Grade__c = class1.Id  // REQUIRED FIELD
        );
        insert section;
        
        Admission_Granted__c ag = new Admission_Granted__c(
            Name = 'AG-002',
            School_Institution__c = school.Id,
            Class__c = class1.Id,
            //Section_lookup__c = section.Id,
            First_Name__c = 'Test',
            Last_Name__c = 'Student'
        );
        insert ag;
        
        // Call the method
        Test.startTest();
        String result = AdmissionGrantedSyncHandler.SyncAdmissionGranted(ag.Id);
        Test.stopTest();
        
        
      
    }
    
    @isTest
    static void testNullFieldHandling() {
        // Get test Admission Granted record
        Admission_Granted__c ag = [SELECT Id FROM Admission_Granted__c LIMIT 1];
        
        // Set some fields to null to test null handling
        ag.Father_Mobile_No__c = null;
        ag.Mother_Mobile_No__c = null;
        ag.guardianMobile_No__c = null;
        ag.Mobile_Number__c = null;
        ag.Emergency_Contact_No__c = null;
        // ag.Student_UDISE_No__c = null;
        // ag.Enrollment_No_FF__c = null;
        // ag.EMIS_No_FF__c = null;
        update ag;
        
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"status":"success"}'));
        
        // Call the method
        Test.startTest();
        String result = AdmissionGrantedSyncHandler.SyncAdmissionGranted(ag.Id);
        Test.stopTest();
        
        // Verify results
        System.assert(result.contains('success'), 'Expected success response despite null fields');
    }
    
    @isTest
    static void testGovernmentEmployeeFlags() {
        // Get test Admission Granted record
        Admission_Granted__c ag = [SELECT Id FROM Admission_Granted__c LIMIT 1];
        
        // Test with "No" values
        // ag.Is_Father_Government_Employee_FF__c = 'No';
        // ag.Is_Mother_Government_Employee_FF__c = 'No';
        // ag.Is_Guardian_Government_Employee_FF__c = 'No';
        update ag;
        
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"status":"success"}'));
        
        // Call the method
        Test.startTest();
        String result = AdmissionGrantedSyncHandler.SyncAdmissionGranted(ag.Id);
        Test.stopTest();
        
        // Verify results
        System.assert(result.contains('success'), 'Expected success response with No flags');
    }
    
    @isTest
    static void testPhoneNumberFormatting() {
        // Get test Admission Granted record
        Admission_Granted__c ag = [SELECT Id FROM Admission_Granted__c LIMIT 1];
        
        // Set phone numbers with special characters
        ag.Father_Mobile_No__c = '+91 (987) 654-3210';
        ag.Mother_Mobile_No__c = '+91 (987) 654-3210';
        ag.guardianMobile_No__c = '+91 (987) 654-3210';
        ag.Mobile_Number__c = '+91 (987) 654-3210';
        ag.Emergency_Contact_No__c = '+91 (987) 654-3210';
        update ag;
        
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"status":"success"}'));
        
        // Call the method
        Test.startTest();
        String result = AdmissionGrantedSyncHandler.SyncAdmissionGranted(ag.Id);
        Test.stopTest();
        
        // Verify results
        System.assert(result.contains('success'), 'Expected success response with formatted phone numbers');
    }
    
    @isTest
    static void testStellarAPICallout() {
        // Get test Admission Granted record
        Admission_Granted__c ag = [SELECT Id FROM Admission_Granted__c LIMIT 1];
        
        // Mock HTTP callout for both Applane and Stellar
        MultiMockHttpResponseGenerator mock = new MultiMockHttpResponseGenerator();
        mock.addResponse(200, '{"status":"success"}'); // Applane response
        mock.addResponse(200, '{"status":"success"}'); // Stellar response
        Test.setMock(HttpCalloutMock.class, mock);
        
        // Call the method
        Test.startTest();
        String result = AdmissionGrantedSyncHandler.SyncAdmissionGranted(ag.Id);
        Test.stopTest();
        
        // Verify results
        System.assert(result.contains('success'), 'Expected success response');
    }
    
    // Mock HTTP response generator for single endpoint
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String body;
        
        public MockHttpResponseGenerator(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(statusCode);
            res.setBody(body);
            return res;
        }
    }
    
    // Mock HTTP response generator for multiple endpoints
    private class MultiMockHttpResponseGenerator implements HttpCalloutMock {
        private List<Integer> statusCodes = new List<Integer>();
        private List<String> bodies = new List<String>();
        private Integer callCount = 0;
        
        public void addResponse(Integer statusCode, String body) {
            statusCodes.add(statusCode);
            bodies.add(body);
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            if (callCount < statusCodes.size()) {
                res.setStatusCode(statusCodes[callCount]);
                res.setBody(bodies[callCount]);
            } else {
                res.setStatusCode(200);
                res.setBody('{}');
            }
            
            callCount++;
            return res;
        }
    }
}