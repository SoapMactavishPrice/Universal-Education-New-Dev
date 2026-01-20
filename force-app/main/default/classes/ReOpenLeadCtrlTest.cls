@isTest
public class ReOpenLeadCtrlTest {

    @isTest 
    public static void testReOpenLeadCtrl() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        // Create test school with required School_Short_Code__c
        Account acc = new Account(
            Name = 'Test School',
            School_Short_Code__c = 'STELRB' 
        );
        insert acc;

        // Create test lead that references the above school by short code
        Lead ld = new Lead(
            Acadmic_Year__c = '2021-2022',
            LastName = 'TestLead',
            School_Short_Code__c = 'STELRB',
            MobilePhone = '1234567898',
            Status = 'New',
            Company = 'Test company',
            Reason_Lost__c = false,
            Current_Status__c = 'Nurturing',
            Stage__c = '',
            Reason_Losts__c = '',
            Lost_Reasons__c = '',
            Reason_Lost_Object__c = '',
            Reopen_Date_Time__c = system.now(),
            Lost_Date_Time__c= null
        );
        insert ld;

        // Create related contact
        Contact con = new Contact(
            FirstName = 'TestFirstname',
            LastName = 'TestLastname',
            AccountId = acc.Id,
            Lead_ID__c = ld.Id,
            MobilePhone = '9123445678',
            Email = 'rumeli@gmail.com',
            Type__c = 'Admission Enquiry',
            Contact_Status__c = 'Qualified',
            Contact_Reasons__c = 'N/A'
        );
        insert con;

        // Create related Enquiry
        Enquiry__c enq = new Enquiry__c(
            Contact__c = con.Id,
            Enquiry_Type__c = 'TestGeneral',
            Date_of_Birth__c = system.today(),
            Academic_Year__c = '2020-21',
            FirstName__c = 'testStudent',
            Last_Name__c = 'Test',
            Log_Status__c = 'On Hold',
            Seeking_Admission_in_Grade__c = 'II',
            Parent_First_Name__c = 'testparent',
            Parent_Last_Name__c = con.LastName,
            Email__c = con.Email,
            Mobile_No__c = con.MobilePhone,
            School_Institution__c = acc.Id,
            Address__c = 'testaddress',
            City__c = 'testcity',
            State__c = 'teststate',
            Pin_Code__c = '125479',
            Source_of_Information__c = 'testsource',
            Stages__c = 'Application submitted',
            Application_Received__c = true,
            Application_Sent__c = true
        );
        insert enq;

        // Application Form
        Application_Form__c af1 = new Application_Form__c(
            Academic_Year__c = '2019-20',
            Address__c = 'address',
            Adhaar_Card_No__c = '768768765654',
            Father_Annual_Income__c = 10000,
            Mother_Anual_Income__c = 20000,
            Application_Form_Declaration__c = true,
            Name = 'rumeli',
            Birth_Place__c = 'kolkata',
            Blood_Group__c = 'AB+ve',
            Father_Business_Address__c = 'FatherBusinessAddress',
            Mother_Business_Address__c = 'mother_Business_Address__c',
            Father_Business_Contact__c = '9843356798',
            Mother_Business_Contact__c = '9876456364',
            Category__c = 'Gen',
            Country__c = 'india',
            City__c = 'kolkata',
            Email_Address__c = 'rumeli@gmail.com',
            Enquiry__c = enq.Id,
            Student_Name__c = 'student',
            Status__c = 'Application submitted',
            State__c = 'state'
        );
        insert af1;

        // Admission Form
        Admission_Form__c af2 = new Admission_Form__c(
            Address__c = 'address',
            Adhaar_Card_No__c = '768768765654',      
            Name = 'rumeli',
            Student_Name__c = 'student',        
            Enquiry_No__c = enq.Id,
            Application_Form__c = af1.Id,
            Admission_Granted__c = false,
            Called_for_Observation__c = true,
            Document_Received__c = true,
            Last_Name__c = 'banerjee',
            Mobile_Number__c = '9804661694',
            GuardianName__c = 'rumeli banerjee',
            GuardianEmail_Id__c = 'rumeli@gmail.com',
            GuardianMobile_No__c = '9804661694',
            Nationality__c = 'Indian',
            Registration_No__c = '2019-20/II/UHSC/REG/9'
        );
        insert af2;

        // Admission Granted
        Admission_Granted__c af3 = new Admission_Granted__c(
            Adhaar_Card_No__c = '123456789098',
            Birth_Place__c = 'kolkata',
            Category__c = 'Gen',
            Registration_No__c = af2.Registration_No__c,
            EnquiryNo__c = enq.Id,
            Application_Form__c = af1.Id,
            Admission_Form__c = af2.Id
        );
        insert af3;

        // Test page + controller interaction
        PageReference pageRef = Page.ReOpenLead;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', ld.Id);

        ApexPages.StandardController sc1 = new ApexPages.StandardController(ld);
        ReOpenLeadCtrl lds = new ReOpenLeadCtrl(sc1);
        lds.LeadReOpen();

        Test.startTest();
        ReOpenLeadCtrl.fakeMethod(); // If fakeMethod is used for coverage
        Test.stopTest();
    }
}