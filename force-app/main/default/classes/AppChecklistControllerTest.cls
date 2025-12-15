@isTest
private class AppChecklistControllerTest {
    
    @TestSetup
    static void setupTestData() {
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Create test School
        Account testSchool = new Account(
            Name = 'Test School'
           // School_Logo_URL__c = 'https://example.com/logo.png'
        );
        insert testSchool;
        
        // Create test Grade
        Class__c class1 = new Class__c(
            Name = 'Playgroup',
            School_Name__c= testSchool.id
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
        
        // Create test Enquiry
        Enquiry__c testEnquiry = new Enquiry__c(
          //  First_Name__c = 'Test',
            Last_Name__c = 'Student',
            School_Institution__c = testSchool.Id,
          //  Seeking_Grade__c = testGrade.Id,
           // Academic_Year__c = testAcademicYear.Name,
            Form_C_Checked__c = false,
            Form_D_Checked__c = false,
            Form_E1_Checked__c = false,
            Form_E2_Checked__c = false
        );
        insert testEnquiry;
        
        // Create test Application Form
        Application_Form__c testAppForm = new Application_Form__c(
           // First_Name__c = 'Test',
            Last_Name__c = 'Applicant',
            School_Institution__c = testSchool.Id
         //   Seeking_Grade__c = testGrade.Id,
           // Academic_Year__c = testAcademicYear.Name
        );
        insert testAppForm;
        
        // Create test Disclosures
        List<Disclosure__c> testDisclosures = new List<Disclosure__c>();
        testDisclosures.add(new Disclosure__c(
            Name = 'Form C',
            Description__c = 'Form C Disclosure',
            Terms__c = 'Terms for Form C',
            School__c = testSchool.Id,
           // OrgionalClass__c = 'Grade 5',
           // Academic_Year__c = testAcademicYear.Name,
            DisplaySequence__c = 1
        ));
        testDisclosures.add(new Disclosure__c(
            Name = 'Form-D',
            Description__c = 'Form D Disclosure',
            Terms__c = 'Terms for Form D',
            School__c = testSchool.Id,
          //  OrgionalClass__c = 'Grade 5',
          //  Academic_Year__c = testAcademicYear.Name,
            DisplaySequence__c = 2
        ));
        testDisclosures.add(new Disclosure__c(
            Name = 'Form E-1',
            Description__c = 'Form E-1 Disclosure',
            Terms__c = 'Terms for Form E-1',
            School__c = testSchool.Id,
           // OrgionalClass__c = 'Grade 5',
           // Academic_Year__c = testAcademicYear.Name,
            DisplaySequence__c = 3
        ));
        testDisclosures.add(new Disclosure__c(
            Name = 'Form E-2',
            Description__c = 'Form E-2 Disclosure',
            Terms__c = 'Terms for Form E-2',
            School__c = testSchool.Id,
           // OrgionalClass__c = 'Grade 5',
           // Academic_Year__c = testAcademicYear.Name,
            DisplaySequence__c = 4
        ));
        insert testDisclosures;
    }
    
    @isTest
    static void testGetChecklistWithEnquiry() {
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Enquiry__c testEnquiry = [SELECT Id FROM Enquiry__c LIMIT 1];
        
        Test.startTest();
        List<Disclosure__c> result = AppChecklistController.getChecklist(testEnquiry.Id);
        Test.stopTest();
        
       
    }
    
    @isTest
    static void testGetChecklistWithApplicationForm() {
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Application_Form__c testAppForm = [SELECT Id FROM Application_Form__c LIMIT 1];
        
        Test.startTest();
        List<Disclosure__c> result = AppChecklistController.getChecklist(testAppForm.Id);
        Test.stopTest();
        
       
    }
    
    @isTest
    static void testGetChecklistNoGrade() {
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Create enquiry without grade
        Enquiry__c testEnquiry = new Enquiry__c(
           // First_Name__c = 'No Grade',
            Last_Name__c = 'Test',
            School_Institution__c = [SELECT Id FROM Account LIMIT 1].Id
           // Academic_Year__c = [SELECT Name FROM Academic_Year__c LIMIT 1].Name
        );
        insert testEnquiry;
        
        Test.startTest();
        List<Disclosure__c> result = AppChecklistController.getChecklist(testEnquiry.Id);
        Test.stopTest();
        
        System.assertEquals(null, result, 'Result should be null for enquiry without grade');
    }
    
    @isTest
    static void testGetChecklistNoMatchingDisclosures() {
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Create enquiry with grade that has no disclosures
      //  Grade__c otherGrade = new Grade__c(Name = 'Grade 12');
      //  insert otherGrade;
        
        Enquiry__c testEnquiry = new Enquiry__c(
           // First_Name__c = 'Other Grade',
            Last_Name__c = 'Test',
            School_Institution__c = [SELECT Id FROM Account LIMIT 1].Id
           // Seeking_Grade__c = otherGrade.Id,
           // Academic_Year__c = [SELECT Name FROM Academic_Year__c LIMIT 1].Name
        );
        insert testEnquiry;
        
        Test.startTest();
        List<Disclosure__c> result = AppChecklistController.getChecklist(testEnquiry.Id);
        Test.stopTest();
        
        System.assertEquals(null, result, 'Result should be null when no matching disclosures');
    }
    
    @isTest
    static void testSetCheckboxFormC() {
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Enquiry__c testEnquiry = [SELECT Id, Form_C_Checked__c FROM Enquiry__c LIMIT 1];
        System.assertEquals(false, testEnquiry.Form_C_Checked__c, 'Initial value should be false');
        
        Test.startTest();
        AppChecklistController.setCheckbox(testEnquiry.Id, 'Form C', true);
        Test.stopTest();
        
        Enquiry__c updatedEnquiry = [SELECT Form_C_Checked__c FROM Enquiry__c WHERE Id = :testEnquiry.Id];
        System.assertEquals(true, updatedEnquiry.Form_C_Checked__c, 'Form C checkbox should be updated to true');
    }
    
    @isTest
    static void testSetCheckboxFormD() {
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Enquiry__c testEnquiry = [SELECT Id, Form_D_Checked__c FROM Enquiry__c LIMIT 1];
        System.assertEquals(false, testEnquiry.Form_D_Checked__c, 'Initial value should be false');
        
        Test.startTest();
        AppChecklistController.setCheckbox(testEnquiry.Id, 'Form-D', true);
        Test.stopTest();
        
        Enquiry__c updatedEnquiry = [SELECT Form_D_Checked__c FROM Enquiry__c WHERE Id = :testEnquiry.Id];
        System.assertEquals(true, updatedEnquiry.Form_D_Checked__c, 'Form D checkbox should be updated to true');
    }
    
    @isTest
    static void testSetCheckboxFormE1() {
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Enquiry__c testEnquiry = [SELECT Id, Form_E1_Checked__c FROM Enquiry__c LIMIT 1];
        System.assertEquals(false, testEnquiry.Form_E1_Checked__c, 'Initial value should be false');
        
        Test.startTest();
        AppChecklistController.setCheckbox(testEnquiry.Id, 'Form E-1', true);
        Test.stopTest();
        
        Enquiry__c updatedEnquiry = [SELECT Form_E1_Checked__c FROM Enquiry__c WHERE Id = :testEnquiry.Id];
        System.assertEquals(true, updatedEnquiry.Form_E1_Checked__c, 'Form E-1 checkbox should be updated to true');
    }
    
    @isTest
    static void testSetCheckboxFormE2() {
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Enquiry__c testEnquiry = [SELECT Id, Form_E2_Checked__c FROM Enquiry__c LIMIT 1];
        System.assertEquals(false, testEnquiry.Form_E2_Checked__c, 'Initial value should be false');
        
        Test.startTest();
        AppChecklistController.setCheckbox(testEnquiry.Id, 'Form E-2', true);
        Test.stopTest();
        
        Enquiry__c updatedEnquiry = [SELECT Form_E2_Checked__c FROM Enquiry__c WHERE Id = :testEnquiry.Id];
        System.assertEquals(true, updatedEnquiry.Form_E2_Checked__c, 'Form E-2 checkbox should be updated to true');
    }
    
    @isTest
    static void testSetCheckboxUncheck() {
        
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Enquiry__c testEnquiry = [SELECT Id FROM Enquiry__c LIMIT 1];
        // First set to true
        AppChecklistController.setCheckbox(testEnquiry.Id, 'Form C', true);
        
        Test.startTest();
        // Then set back to false
        AppChecklistController.setCheckbox(testEnquiry.Id, 'Form C', false);
        Test.stopTest();
        
        Enquiry__c updatedEnquiry = [SELECT Form_C_Checked__c FROM Enquiry__c WHERE Id = :testEnquiry.Id];
        System.assertEquals(false, updatedEnquiry.Form_C_Checked__c, 'Form C checkbox should be updated to false');
    }

	class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }
}