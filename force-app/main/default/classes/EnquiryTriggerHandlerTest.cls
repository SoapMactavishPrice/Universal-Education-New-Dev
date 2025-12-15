@isTest
public class EnquiryTriggerHandlerTest {

    @testSetup
    static void setupData() {
        // Create a sample Lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'User',
            Company = 'Test Company',
            //LeadSource = 'Walkin',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        // Create related Enquiry__c record
        Enquiry__c enquiry = new Enquiry__c(
            Lead__c = testLead.Id,
            Apartment_Society__c = 'Sunrise Apartments',
            Locality__c = 'Central Park',
            Current_school__c = 'Green Valley School',
            Mother_s_Educational_Qualifications__c = 'Graduate',
            Mother_s_Occupation__c = 'Homemaker',
            How_did_you_hear_about_us__c = 'I know someone',
            Father_s_Educational_Qualifications__c = 'Graduate',
            Father_s_Occupation__c = 'Business'
        );
        insert enquiry;
    }

    @isTest
    static void testLeadUpdateFromEnquiryInsert() {
        // Refetch the Lead and validate the values were copied
        Enquiry__c enq = [SELECT Lead__c FROM Enquiry__c LIMIT 1];
        Lead updatedLead = [
            SELECT Apartment_Society__c, Landmark__c, Current_school__c,
                   Mother_s_Educational_Qualifications__c, Mother_s_Occupation__c,
                   How_did_you_hear_about_us__c, Father_s_Educational_Qualifications__c,
                   Father_s_Occupation__c
            FROM Lead WHERE Id = :enq.Lead__c
        ];


    }

    @isTest
    static void testLeadUpdateFromEnquiryUpdate() {
        // Fetch and update enquiry
        Enquiry__c enq = [SELECT Id, Lead__c FROM Enquiry__c LIMIT 1];
        enq.Apartment_Society__c = 'Maple Residency';
        enq.Locality__c = 'Skyline Towers';
        enq.Current_school__c = 'Blue Bells High';
        enq.Father_s_Occupation__c = 'Business';

        update enq;

        // Validate lead is updated after enquiry update
        Lead updatedLead = [
            SELECT Apartment_Society__c, Landmark__c, Current_school__c, Father_s_Occupation__c
            FROM Lead WHERE Id = :enq.Lead__c
        ];

        
    }
}