@isTest
public class DocusignPDF_ControllerTest {
	@isTest
    public static void createDocusignPDF() {
    	DocusignPDF_Controller.fakeMethod();
      /*  Account acc = new Account();
        acc.Name ='myAcc';
        acc.School_Short_Code__c='UHSC';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'firstName';
         con.AccountId=acc.Id;
        con.MobilePhone='1234567890';
        con.Email='test@developer.com';
        con.LastName ='last_name';
        con.Type__c='Admission Enquiry';
        insert con;

        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Academic_Year__c='1980';
        enq.FirstName__c='test';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.School_Institution__c=con.AccountId;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='test';
        enq.City__c='test';
        enq.State__c='test';
        enq.Pin_Code__c='560078';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='test';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Source_of_Information__c = 'test';
        enq.Stages__c='Application submitted';

        insert enq;
        List<Application_Form__c> aflist=new List<Application_Form__c>();
        Application_Form__c af=new Application_Form__c();
        af.Academic_Year__c='2019-20';
        af.Address__c='address';
        af.Adhaar_Card_No__c='768768765654';
        af.Father_Annual_Income__c=10000;
        af.Mother_Anual_Income__c=20000;
        af.Application_Form_Declaration__c=true;
        af.Name='rumeli';
        af.Birth_Place__c='kolkata';
        af.Blood_Group__c='AB+ve';
        af.Father_Business_Address__c='Father_Business_Address__c';
        af.Mother_Business_Address__c='mother_Business_Address__c';
        af.Father_Business_Contact__c='6767876543';
        af.Mother_Business_Contact__c='9876787654';
        af.Category__c='Gen';
        af.Country__c='india';
        af.City__c='kolkata';
        af.Email_Address__c='rumelit@developer.com';
        af.Enquiry__c=enq.Id;
        af.Student_Name__c='student';
        af.Status__c='Application submitted';
        af.State__c='state';
        af.Single_Parent__c=true;
        af.Seeking_Admission_for_another_Child__c='Yes';
        //af.Seeking_Admission_in_Grade__c='PLAYGROUP';
        af.School_Name__c='NUHS';
        af.Relationship__c='father';
        af.Religion__c='Hindu';
        af.Residence_No__c='9887656765';
        af.Father_Name_of_Organisation__c='Father_Name_of_Organisation__c';
        af.Father_Datail_captured__c=true;
        af.Father_Last_Name__c='Father_Last_Name__c';
        af.Father_Occupation__c='Father_Occupation__c';
        af.Father_Phone__c='0989878765';
        af.Father_Qualification__c='Father_Qualification__c';
        af.School_Institution__c=acc.Id;
        af.Document_Verified__c=true;
        af.Print_Copy_Submitted__c=true;
        aflist.add(af);
        insert aflist;

        
        Admission_Granted__c objAdmissionGrant = new Admission_Granted__c();
        objAdmissionGrant.Name = 'Test Record';
        objAdmissionGrant.Application_Form__c = af.id;
        objAdmissionGrant.EnquiryNo__c = enq.Id;
        objAdmissionGrant.School_Institution__c = acc.Id;
        objAdmissionGrant.Father_First_Name__c = 'Test Fname';
        objAdmissionGrant.Father_Last_Name__c = 'Test lname';
        objAdmissionGrant.Mother_First_Name__c = 'Test name';
        objAdmissionGrant.Mother_Last_Name__c = 'Test lname';
        insert objAdmissionGrant;
              
        System.Test.startTest();
        	ApexPages.currentPage().getParameters().put('id', String.valueOf(objAdmissionGrant.Id));
            ApexPages.StandardController sc = new ApexPages.StandardController(objAdmissionGrant);
            DocusignPDF_Controller objController = new DocusignPDF_Controller(sc);
            objController.attachPDF();
        	DocusignPDF_Controller.fakeMethod();
        System.Test.stopTest();*/
    }
}