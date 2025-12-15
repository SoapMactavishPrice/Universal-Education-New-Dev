@isTest
public class SaveStallerformToLeadTest {
    
    @isTest
    public static void testdoPost() {
        
        // Create the mock RestRequest and RestResponse objects
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/saveStellarForm'; // Set your actual endpoint
        req.httpMethod = 'POST';
        
        // Create and populate lead data
        SaveStellarformToLead.JSON2Apex leadData = new SaveStellarformToLead.JSON2Apex();
        leadData.firstName = 'John';
        leadData.lastName = 'Patil';
        leadData.mobile = '1234567890';
        leadData.referrerFirstName = 'Jane';
        leadData.referrerLastName = 'Smith';
        leadData.referrertContactNumber = '0987654321';
        leadData.reasonforrecommendation = 'Highly recommended';
        leadData.school = 'ABC123';
        leadData.academicYear = '2023-2024';
        leadData.leadSource = 'Referral';
        leadData.email = 'john.doe@example.com';
        leadData.phoneNumber = '1234567890';
        leadData.Stellarcampusapplyingfor = 'Main Campus';
        leadData.Stellarcampusapplyingfor = '5';
        leadData.LearnerFirstName = 'John Jr';
        leadData.LearnerLastName = 'Doe';
        leadData.Gender = 'Male';
        leadData.DateofBirth = Date.newInstance(2000, 8, 15); // Set date in a proper format
        leadData.Nationality = 'American';
        leadData.Apartmentname = 'Sunset Apartments';
        leadData.streetAreaLandmark = '1234 Elm Street; Near Central Park';
        leadData.State = 'Maharashtra';
        leadData.City = 'Panvel';
        leadData.Country ='India';
        leadData.Pincode = '410206';
        leadData.Areyouasingleparent = false;
        leadData.FatherFirstName = 'Siddhant';
        leadData.FatherLastName = 'Doe';
        leadData.fatherPhoneNumber = '1234567890';
        leadData.fatherEmail = 'john.doe@example.com';
        leadData.FatherEducationalqualification = 'Graduate';
        leadData.FatherProfession = 'Salaried - Government';
        leadData.fatherOrganisation = 'Tech Corp';
        leadData.FatherDesignation = 'Senior Engineer';
        leadData.fatherLinkedin = 'https//linkedin.com/in/johndoe';
        leadData.MotherFirstName = 'Jane';
        leadData.MotherLastName = 'Doe';
        leadData.motherPhoneNumber = '0987654321';
        leadData.motherEmail = 'jane.doe@example.com';
        leadData.MotherEducationalqualification = 'Graduate';
        leadData.MotherProfession = 'Salaried - Government';
        leadData.motherOrganisation = 'Healthcare Inc';
        leadData.MotherDesignation = 'Surgeon';
        leadData.motherLinkedin = 'https//linkedin.com/in/johndoe';
        leadData.LearningNeeds = 'No';
            
        // Serialize the data to JSON and set the request body
        String requestData = JSON.serialize(leadData);
        req.requestBody = Blob.valueOf(requestData);
        
        // Mock data for Account object
        Account a1 = new Account();
        a1.Name = 'Sample School';
        a1.Total_number_of_Contacts__c = 10;
        a1.Total_No_of_Enquiry_Form_Recived__c = 9;
        a1.Total_No_of_Application_Form_Received__c = 11;
        a1.School_Email__c = 'abc@gmail.com';
        a1.Type = 'Partner';
        a1.School_Short_Code__c = 'ABC123';
        insert a1;
        
        // Set the request and response in RestContext
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        // Call the method to be tested
        Test.startTest();
        SaveStellarformToLead.doPost();
        Test.stopTest();
        
        // Validate the results here if there are expected outcomes
        // For example, you can query the lead object and verify its fields
        Lead insertedLead = [SELECT FirstName, LastName, MobilePhone, Email FROM Lead WHERE LastName = 'Patil' LIMIT 1];
        System.assertEquals('John', insertedLead.FirstName);
        System.assertEquals('Patil', insertedLead.LastName);
        System.assertEquals('+911234567890', insertedLead.MobilePhone);
        System.assertEquals('john.doe@example.com', insertedLead.Email);
    }
}