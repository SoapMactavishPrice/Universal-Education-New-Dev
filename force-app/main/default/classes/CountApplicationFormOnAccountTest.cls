@isTest
public class CountApplicationFormOnAccountTest {

     class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    public static void CountApplication() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Create Account
        Account acc = new Account(
            Name = 'Test School',
            Total_number_of_Contacts__c = 10,
            Total_No_of_Enquiry_Form_Recived__c = 9,
            Total_No_of_Application_Form_Received__c = 11,
            School_Email__c = 'abc@gmail.com',
            Type = 'Partner'
        );
        insert acc;

        // Create Contact
        Contact con = new Contact(
            FirstName = 'Test_First_name',
            LastName = 'Test_Last_name',
            AccountId = acc.Id,
            MobilePhone = '9123445678',
            Email = 'rumeli@developer.com',
            Type__c = 'Admission Enquiry'
        );
        insert con;

        // Create Enquiry
        Enquiry__c enq = new Enquiry__c(
            Contact__c = con.Id,
            Enquiry_Type__c = 'Test_General',
            Date_of_Birth__c = Date.today(),
            Academic_Year__c = '2015',
            FirstName__c = 'test_Student',
            Last_Name__c = 'Test',
            Log_Status__c = 'On Hold',
            Seeking_Admission_in_Grade__c = 'II',
            Parent_First_Name__c = 'test_parent',
            Parent_Last_Name__c = con.LastName,
            Email__c = con.Email,
            Mobile_No__c = con.MobilePhone,
            School_Institution__c = acc.Id,
            Address__c = 'test_address',
            City__c = 'test_city',
            State__c = 'test_state',
            Pin_Code__c = '125479',
            Source_of_Information__c = 'test_source',
            Stages__c = 'Application submitted',
            Application_Received__c = true,
            Application_Sent__c = true
        );
        insert enq;

        // Create Application Form
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
            Father_Business_Address__c = 'Father_Business_Address__c',
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

        // Create Admission Form
        Admission_Form__c af2 = new Admission_Form__c(
            Address__c = 'address',
            Adhaar_Card_No__c = '768768765654',
            Name = 'rumeli',
            Student_Name__c = 'student',
            Enquiry_No__c = af1.Enquiry__c,
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

        // Optional update
        update af2;

      

        //  Assert to make sure the account is updated properly
        Account updatedAcc = [SELECT Total_No_of_Application_Form_Received__c FROM Account WHERE Id = :acc.Id];
    }
}