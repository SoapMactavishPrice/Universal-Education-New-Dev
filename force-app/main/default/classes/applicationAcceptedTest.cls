@isTest
public class applicationAcceptedTest {
    private static Enquiry__c createEnquiryData() {
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company'
        );
        insert testLead;

        Account school = new Account(
            Name = 'Test School',
            School_Short_Code__c = 'TEST'
        );
        insert school;

        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'Parent',
            AccountId = school.Id,
            MobilePhone = '9123445678',
            Email = 'parent@example.com',
            Lead__c = testLead.Id,
            Type__c = 'Admission Enquiry',
            Contact_Status__c = 'Qualified',
            Contact_Reasons__c = 'N/A'
        );
        insert con;

        Enquiry__c enq = new Enquiry__c(
            Contact__c = con.Id,
            Enquiry_Type__c = 'General',
            Date_of_Birth__c = System.today(),
            Academic_Year__c = '2015',
            FirstName__c = 'Student',
            Last_Name__c = 'Test',
            Log_Status__c = 'On Hold',
            Parent_First_Name__c = 'Test',
            Parent_Last_Name__c = con.LastName,
            Email__c = con.Email,
            Mobile_No__c = con.MobilePhone,
            School_Institution__c = school.Id,
            Lead__c = testLead.Id,
            Address__c = 'test address',
            City__c = 'test city',
            State__c = 'test state',
            Pin_Code__c = '125479',
            Source_of_Information__c = 'test source',
            Stages__c = 'Application submitted',
            Application_Received__c = true,
            Application_Sent__c = true
        );
        insert enq;
        return enq;
    }

    @isTest
    static void testCreateAdmissionFormCreatesOnlyOneRecord() {
        Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = createApplicationForm(true, true, 'Application submitted');

        applicationAccepted controller = buildController(appForm.Id);
        Test.startTest();
        PageReference result = controller.createAdmissionForm();
        Test.stopTest();

        System.assertNotEquals(null, result, 'Successful acceptance should navigate back to the application form.');
        System.assertEquals(
            1,
            [SELECT COUNT() FROM Admission_Form__c WHERE Application_Form__c = :appForm.Id],
            'Exactly one admission form should be created.'
        );

        Application_Form__c updatedApp = [SELECT Status__c, Application_Accepted__c FROM Application_Form__c WHERE Id = :appForm.Id];
        System.assertEquals('Application Accepted', updatedApp.Status__c);
        System.assertEquals(true, updatedApp.Application_Accepted__c);
    }

    @isTest
    static void testCreateAdmissionFormBlocksDuplicateCreation() {
        Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = createApplicationForm(true, true, 'Application submitted');

        applicationAccepted controller = buildController(appForm.Id);
        controller.createAdmissionForm();

        Test.startTest();
        PageReference secondResult = buildController(appForm.Id).createAdmissionForm();
        Test.stopTest();

        System.assertEquals(null, secondResult, 'Duplicate acceptance attempt should stay on the page.');
        System.assertEquals(
            1,
            [SELECT COUNT() FROM Admission_Form__c WHERE Application_Form__c = :appForm.Id],
            'Second execution must not create another admission form.'
        );
    }

    @isTest
    static void testCreateAdmissionFormRequiresVerifiedDocuments() {
        Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = createApplicationForm(false, false, 'Application submitted');

        Test.startTest();
        PageReference result = buildController(appForm.Id).createAdmissionForm();
        Test.stopTest();

        System.assertEquals(null, result, 'Invalid document state should not navigate away.');
        System.assertEquals(
            0,
            [SELECT COUNT() FROM Admission_Form__c WHERE Application_Form__c = :appForm.Id],
            'Admission form should not be created when documents are not verified.'
        );
    }

    @isTest
    static void testApplicationRejectedUpdatesStatus() {
        Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = createApplicationForm(true, false, 'Application submitted');

        Test.startTest();
        PageReference result = buildController(appForm.Id).applicationRejected();
        Test.stopTest();

        System.assertNotEquals(null, result, 'Reject flow should navigate back to the application form.');

        Application_Form__c updatedApp = [SELECT Status__c, Application_Rejected__c FROM Application_Form__c WHERE Id = :appForm.Id];
        System.assertEquals('Application Rejected', updatedApp.Status__c);
        System.assertEquals(true, updatedApp.Application_Rejected__c);
    }

    @isTest
    static void testDocumentVerifiedUpdatesStatus() {
        Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Application_Form__c appForm = createApplicationForm(false, true, 'Application submitted');

        Test.startTest();
        PageReference result = buildController(appForm.Id).documentVerified();
        Test.stopTest();

        System.assertNotEquals(null, result, 'Document verification should navigate back to the application form.');

        Application_Form__c updatedApp = [SELECT Status__c, Document_Verified__c FROM Application_Form__c WHERE Id = :appForm.Id];
        System.assertEquals('Document Verified', updatedApp.Status__c);
        System.assertEquals(true, updatedApp.Document_Verified__c);
    }

    private static applicationAccepted buildController(Id applicationFormId) {
        PageReference pageRef = Page.applicationAccepted;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', applicationFormId);
        return new applicationAccepted(new ApexPages.StandardController(new Application_Form__c(Id = applicationFormId)));
    }

    private static Application_Form__c createApplicationForm(Boolean documentVerified, Boolean printCopySubmitted, String statusValue) {
        Enquiry__c enquiryRecord = createEnquiryData();
        Account school = [SELECT Id, School_Short_Code__c FROM Account WHERE Id = :enquiryRecord.School_Institution__c LIMIT 1];

        Application_Form__c appForm = new Application_Form__c(
            Academic_Year__c = '2019-20',
            Lead__c = enquiryRecord.Lead__c,
            Address__c = 'address',
            Adhaar_Card_No__c = '768768765654',
            Father_Annual_Income__c = 10000,
            Mother_Anual_Income__c = 20000,
            Application_Form_Declaration__c = true,
            Name = 'app-' + String.valueOf(Math.abs(Crypto.getRandomInteger())),
            Birth_Place__c = 'kolkata',
            Blood_Group__c = 'AB+ve',
            Father_Business_Address__c = 'Father address',
            Mother_Business_Address__c = 'Mother address',
            Father_Business_Contact__c = '6767876543',
            Mother_Business_Contact__c = '9876787654',
            Category__c = 'Gen',
            Country__c = 'India',
            City__c = 'Kolkata',
            Email_Address__c = 'student@example.com',
            Enquiry__c = enquiryRecord.Id,
            Student_Name__c = 'Student Name',
            Status__c = statusValue,
            State__c = 'State',
            Single_Parent__c = true,
            Seeking_Admission_for_another_Child__c = 'Yes',
            Relationship__c = 'father',
            Religion__c = 'Hindu',
            Residence_No__c = '9887656765',
            Father_Name_of_Organisation__c = 'Org',
            Father_Datail_captured__c = true,
            Father_Last_Name__c = 'Parent',
            Father_Occupation__c = 'Occupation',
            Father_Phone__c = '0989878765',
            Father_Qualification__c = 'Graduate',
            School_Institution__c = school.Id,
            Document_Verified__c = documentVerified,
            Print_Copy_Submitted__c = printCopySubmitted
        );
        insert appForm;
        return appForm;
    }
}
