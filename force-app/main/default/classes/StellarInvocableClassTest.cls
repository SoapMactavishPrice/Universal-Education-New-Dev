@isTest
public with sharing class StellarInvocableClassTest {
    
    @isTest
    public static void EnquiryFormSubmissionInvocableTest(){
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        System.Test.startTest();
            EnquiryFormSubmissionInvocable.stellarSubmission(
                new List<Enquiry__c>{
                    new Enquiry__c(
                        Email__c = 'TEST.DATA@test.com',
                        Parent_First_Name__c = 'TEST DATA',
                        Parent_Last_Name__c = 'TEST DATA',
                        FirstName__c = 'TEST DATA',
                        Last_Name__c = 'TEST DATA',
                        Name = 'TEST DATA'
                    )
                }
            );
        System.Test.stopTest();
    }

    @isTest
    public static void AdmissionFormSubmissionInvocableTest(){
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        System.Test.startTest();
            AdmissionFormSubmissionInvocable.stellarSubmission(
                new List<Application_Form__c>{
                    new Application_Form__c(
                        Email_Address__c = 'TEST.DATA@test.com',
                        Father_First_Name__c = 'TEST DATA',
                        Father_Last_Name__c = 'TEST DATA',
                        // First_Name__c = 'TEST DATA',
                        // StudentLast_Name__c = 'TEST DATA',
                        Name = 'TEST DATA'
                    )
                }
            );
        System.Test.stopTest();
    }

    @isTest
    public static void DocusignInvocableTest(){
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        System.Test.startTest();
            DocusignInvocable.stellarSubmission(
                new List<Admission_Granted__c>{
                    new Admission_Granted__c(
                        Email_Address__c = 'TEST.DATA@test.com',
                        Form_A_Sent__c = true,
                        Original_Document__c = 'Pending',
                        Father_First_Name__c = 'TEST DATA',
                        Father_Last_Name__c = 'TEST DATA',
                        Name = 'TEST DATA'
                    )
                }
            );
            DocusignInvocable.stellarSubmission(
                new List<Admission_Granted__c>{
                    new Admission_Granted__c(
                        Email_Address__c = 'TEST.DATA@test.com',
                        Form_A_Sent__c = true,
                        Original_Document__c = 'Received',
                        Father_First_Name__c = 'TEST DATA',
                        Father_Last_Name__c = 'TEST DATA',
                        Name = 'TEST DATA'
                    )
                }
            );
        System.Test.stopTest();
    }

    @isTest
    public static void AdmissionFormPutOnHoldInvocableTest(){
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        System.Test.startTest();
            AdmissionFormPutOnHoldInvocable.stellarSubmission(new List<Admission_Form__c> {new Admission_Form__c(
                FatherFirst_Name__c = 'ffname',
                Father_Last_Name__c = 'flname',
                Email_Address__c = 'test@test.com'
            )});
        System.Test.stopTest();
    }
}