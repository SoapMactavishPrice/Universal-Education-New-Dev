@isTest
public class ActivityTasksCountHandler_test {
   @isTest
   static  void TestupdateTaskCountOnLead (){
      
      lead ld=new lead();
      ld.LastName='bc';
      ld.FirstName='yx';
      ld.LeadSource='website';
      ld.Status='unqualified';
      ld.MobilePhone='98765432';
      ld.Phone='752555667';
      //ld.School_Institution__c=acc.Id;
      //   ld.Seeking_Admission_in_Grade__c='Play Group';
      ld.Converted__c=false;
      ld.Email='dd@gmail.com';
      ld.Company='vs';
      ld.Status = 'New';
      ld.Your_First_Name__c = 'rohith';
      ld.Your_Last_Name__c = 'alguri';
      ld.Category__c = 'Day scholar';
      ld.Seeking_Admission_in_Grade__c= 'sr.kg';
      ld.Relation__c = 'father';
      ld.Gender__c = 'male';
      ld.Date_of_Birth__c = date.newInstance(1995, 01, 29);
      insert ld;
      
      
      
      
      List<task> tskList = new List<Task>();
      for(integer i = 0; i< 5 ; i++){
         Task tsk = new Task();
         tsk.Subject = 'OUTBOUND Call';
         tsk.Priority = 'Normal';
         tsk.Status = 'Completed';
         tsk.Call_Status__c = 'Customer Missed';
         tsk.WhoId = ld.Id;
         tskList.add(tsk);
      }
      
      insert tskList;
      RecursiveTriComCurrStatusHandler.isFirstTime =true;
      
      Task tsk1 = new Task();
      tsk1.Subject = 'INBOUND Call';
      tsk1.Priority = 'Customer Missed';
      tsk1.Status = 'Completed';
      tsk1.Call_Status__c = 'Connected';
      tsk1.WhoId = ld.Id;
      //tsk1.TaskSubtype = 'Email';
      insert tsk1;
      
      Task tsk2 = new Task();
      tsk2.Subject = 'INBOUND Call';
      tsk2.Priority = 'Customer Missed';
      tsk2.Status = 'Completed';
      tsk2.Call_Status__c = 'Connected';
      tsk2.WhoId = ld.Id;
      tsk2.TaskSubtype = 'Email';
      insert tsk2;
      
      Task tsk3 = new Task();
      tsk3.Subject = 'OUTBOUND Call';
      tsk3.Priority = 'Customer Missed';
      tsk3.Status = 'Completed';
      tsk3.Call_Status__c = 'Missed';
      tsk3.WhoId = ld.Id;
      tsk3.TaskSubtype = 'Email';
      insert tsk3;
      
      //RecursiveTriComCurrStatusHandler.isFirstTime =true;
   }
   
   public static string leadInsert(){
      lead ld=new lead();
      ld.LastName='bc';
      ld.FirstName='yx';
      ld.LeadSource='website';
      ld.Status='unqualified';
      ld.MobilePhone='98765432';
      ld.Phone='752555667';
      //ld.School_Institution__c=acc.Id;
      //   ld.Seeking_Admission_in_Grade__c='Play Group';
      ld.Converted__c=false;
      ld.Email='dd@gmail.com';
      ld.Company='vs';
      ld.Status = 'New';
      ld.Your_First_Name__c = 'rohith';
      ld.Your_Last_Name__c = 'alguri';
      ld.Category__c = 'Day scholar';
      ld.Seeking_Admission_in_Grade__c= 'sr.kg';
      ld.Relation__c = 'father';
      ld.Gender__c = 'male';
      ld.Date_of_Birth__c = date.newInstance(1995, 01, 29);
      insert ld;
      
      return ld.Id;
   }
   @isTest
   static  void TestupdateTaskCountOnContact (){
      
      Contact con = new Contact();
      con.FirstName = 'Test_First_name';
      con.LastName ='Test_Last _name';
      con.MobilePhone='9123445678';
      con.Email='himanshunimje@live.com';
      con.Type__c='Admission Enquiry';
      con.Enquiry_Link_Sent__c=false;
      con.Contact_Status__c='Qualified';
      con.Contact_Reasons__c='N/A';
      con.Lead__c = leadInsert();
      insert con;
      
      Task tsk2 = new Task();
      tsk2.Subject = 'INBOUND Call';
      tsk2.Priority = 'Customer Missed';
      tsk2.Status = 'Completed';
      tsk2.Call_Status__c = 'Connected';
      tsk2.WhoId = con.Id;
      tsk2.TaskSubtype = 'Email';
      insert tsk2;
      
      List<task> tskList = new List<Task>();
      for(integer i = 0; i< 5 ; i++){
         Task tsk = new Task();
         tsk.Subject = 'OUTBOUND Call';
         tsk.Priority = 'Normal';
         tsk.Status = 'Completed';
         tsk.Call_Status__c = 'Completed';
         tsk.WhoId = con.Id;
         tskList.add(tsk);
      }
      
      insert tskList;
      
      
      Task tsk3 = new Task();
      tsk3.Subject = 'INBOUND Call';
      tsk3.Priority = 'Customer Missed';
      tsk3.Status = 'Completed';
      tsk3.Call_Status__c = 'Connected';
      tsk3.WhoId = con.Id;
      tsk3.TaskSubtype = 'Email';
      insert tsk3;
      RecursiveTriComCurrStatusHandler.isFirstTime =true;
      
      
   }
   
   @isTest
   static  void TestupdateTaskCountOnEnq (){
      Contact con = new Contact();
      con.FirstName = 'Test_First_name';
      con.LastName ='Test_Last _name';
      con.MobilePhone='9123445678';
      con.Email='himanshunimje@live.com';
      con.Type__c='Admission Enquiry';
      con.Enquiry_Link_Sent__c=false;
      con.Contact_Status__c='Qualified';
      con.Contact_Reasons__c='N/A';
      con.Lead__c = leadInsert();
      insert con;
      
      Enquiry__c enq = new Enquiry__c();
      enq.Contact__c =con.Id;
      enq.Enquiry_Type__c='Test_General';
      enq.Date_of_Birth__c=system.today();
      enq.Academic_Year__c='2022-2023';
      enq.FirstName__c='test_Student';
      enq.Last_Name__c='Test';
      enq.Lead__c = leadInsert();
      // enq.Lead__c = leadInsert();
      insert enq;
      
      List<task> tskList = new List<Task>();
      for(integer i = 0; i< 5 ; i++){
         Task tsk = new Task();
         tsk.Subject = 'OUTBOUND Call';
         tsk.Priority = 'Customer Missed';
         tsk.Status = 'Completed';
         tsk.Call_Status__c = 'User Disconnected';
         tsk.WhatId = enq.Id;
         tskList.add(tsk);
      }
      
      insert tskList;
      
      
      Task tsk1 = new Task();
      tsk1.Subject = 'INBOUND Call';
      tsk1.Priority = 'Customer Missed';
      tsk1.Status = 'Completed';
      tsk1.Call_Status__c = 'Connected';
      tsk1.WhatId = enq.Id;
      insert tsk1;
      
      EmailMessage email = new EmailMessage();
      email.FromAddress = 'test@abc.org';
      email.Incoming = True;
      email.ToAddress= 'test@xyz.org';
      email.Subject = 'Test email';
      email.HtmlBody = 'Test email body';
      email.RelatedToId = enq.Id;
      insert email;
      RecursiveTriComCurrStatusHandler.isFirstTime =true;
   }
   
   @isTest
   static  void TestupdateTaskCountOnAppForm (){
      System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
      
      Contact con = new Contact();
      con.FirstName = 'Test_First_name';
      con.LastName ='Test_Last _name';
      con.MobilePhone='9123445678';
      con.Email='himanshunimje@live.com';
      con.Type__c='Admission Enquiry';
      con.Enquiry_Link_Sent__c=false;
      con.Contact_Status__c='Qualified';
      con.Contact_Reasons__c='N/A';
      con.Lead__c = leadInsert();
      insert con;
      
      Enquiry__c enq = new Enquiry__c();
      enq.Contact__c =con.Id;
      enq.Enquiry_Type__c='Test_General';
      enq.Date_of_Birth__c=system.today();
      enq.Academic_Year__c='2022-2023';
      enq.FirstName__c='test_Student';
      enq.Last_Name__c='Test';
      enq.Lead__c = leadInsert();
      //  enq.Lead__c = leadInsert();
      insert enq;
      
      Application_Form__c af1=new Application_Form__c();
      af1.Academic_Year__c='2020-21';
      af1.Address__c='address';
      af1.Adhaar_Card_No__c='768768765654';
      af1.Father_Annual_Income__c=10000;
      af1.Mother_Anual_Income__c=20000;
      af1.Application_Form_Declaration__c=true;
      af1.Name='rumeli';
      af1.Birth_Place__c='kolkata';
      af1.Blood_Group__c='AB+ve';
      af1.Father_Business_Address__c='Father_Business_Address__c';
      af1.Mother_Business_Address__c='mother_Business_Address__c';
      af1.Father_Business_Contact__c='6767876543';
      af1.Mother_Business_Contact__c='9876787654';
      af1.Category__c='Gen';
      af1.Country__c='india';
      af1.City__c='kolkata';
      af1.Email_Address__c='rumeli@developer.com';
      af1.Enquiry__c=enq.Id;
      af1.Student_Name__c='student';
      af1.Status__c='Application submitted';
      af1.State__c='state';
      af1.School_Institution__c = enq.School_Institution__c;
      af1.Lead__c = leadInsert();
      insert af1;
      
      
      
      
      List<task> tskList = new List<Task>();
      for(integer i = 0; i< 5 ; i++){
         Task tsk = new Task();
         tsk.Subject = 'OUTBOUND Call';
         tsk.Priority = 'Normal';
         tsk.Status = 'Completed';
         tsk.Call_Status__c = 'Customer Missed';
         tsk.WhatId = af1.Id;
         tskList.add(tsk);
      }
      
      insert tskList;
      
      
      Task tsk1 = new Task();
      tsk1.Subject = 'INBOUND Call';
      tsk1.Priority = 'Customer Missed';
      tsk1.Status = 'Completed';
      tsk1.Call_Status__c = 'Connected';
      tsk1.WhatId = af1.Id;
      insert tsk1;
      
      
      EmailMessage email = new EmailMessage();
      email.FromAddress = 'test@abc.org';
      email.Incoming = True;
      email.ToAddress= 'test@xyz.org';
      email.Subject = 'Test email';
      email.HtmlBody = 'Test email body';
      email.RelatedToId = af1.Id;
      insert email;
      
   }
   
   
   @isTest
   static  void TestupdateTaskCountOnAddForm (){
      System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
      
      Contact con = new Contact();
      con.FirstName = 'Test_First_name';
      con.LastName ='Test_Last _name';
      con.MobilePhone='9123445678';
      con.Email='himanshunimje@live.com';
      con.Type__c='Admission Enquiry';
      con.Enquiry_Link_Sent__c=false;
      con.Contact_Status__c='Qualified';
      con.Contact_Reasons__c='N/A';
      con.Lead__c = leadInsert();
      insert con;
      
      Enquiry__c enq = new Enquiry__c();
      enq.Contact__c =con.Id;
      enq.Enquiry_Type__c='Test_General';
      enq.Date_of_Birth__c=system.today();
      enq.Academic_Year__c='2022-2023';
      enq.FirstName__c='test_Student';
      enq.Last_Name__c='Test';
      enq.Lead__c = leadInsert();
      //  enq.Lead__c = leadInsert();
      insert enq;
      
      Application_Form__c af1=new Application_Form__c();
      af1.Academic_Year__c='2020-21';
      af1.Address__c='address';
      af1.Adhaar_Card_No__c='768768765654';
      af1.Father_Annual_Income__c=10000;
      af1.Mother_Anual_Income__c=20000;
      af1.Application_Form_Declaration__c=true;
      af1.Name='rumeli';
      af1.Birth_Place__c='kolkata';
      af1.Blood_Group__c='AB+ve';
      af1.Father_Business_Address__c='Father_Business_Address__c';
      af1.Mother_Business_Address__c='mother_Business_Address__c';
      af1.Father_Business_Contact__c='6767876543';
      af1.Mother_Business_Contact__c='9876787654';
      af1.Category__c='Gen';
      af1.Country__c='india';
      af1.City__c='kolkata';
      af1.Email_Address__c='rumeli@developer.com';
      af1.Enquiry__c=enq.Id;
      af1.Student_Name__c='student';
      af1.Status__c='Application submitted';
      af1.State__c='state';
      af1.School_Institution__c = enq.School_Institution__c;
      af1.Lead__c = leadInsert();
      insert af1;
      
      
      Admission_Form__c af2=new Admission_Form__c();
      af2.Address__c='address';
      af2.Adhaar_Card_No__c='768768765654';
      af2.Name='rumeli';
      af2.Student_Name__c='rumeli';
      af2.Enquiry_No__c=af1.Enquiry__c;
      af2.Student_Name__c='student';
      af2.Application_Form__c=af1.Id;
      af2.Admission_Granted__c=false;
      af2.Called_for_Observation__c=true;
      af2.Document_Received__c=true;
      af2.Last_Name__c='banerjee';
      af2.Mobile_Number__c='9804661694';
      af2.GuardianName__c='rumeli banerjee';
      af2.GuardianEmail_Id__c='rumeli@gmail.com';
      af2.GuardianMobile_No__c='9804661694';
      af2.Nationality__c='Indian';
      af2.Registration_No__c='2019-20/II/UHSC/REG/9';
      // af2.Lead__c = leadInsert();
      //  insert af2;
      
      Admission_Granted__c af3=new Admission_Granted__c();
      af3.Adhaar_Card_No__c='123456789098';
      af3.Birth_Place__c='kolkata';
      af3.Category__c='Gen';
      af3.Registration_No__c=af2.Registration_No__c;
      af3.EnquiryNo__c=af1.Enquiry__c;
      af3.Application_Form__c=af1.Id;
      af3.Admission_Form__c=af2.Id;
      af3.Original_Document__c='Received';
      af3.Status__c='Admission Incomplete';
      af3.Fees_Status__c='Paid';
      // af3.Lead__c = leadInsert();
      //   insert af3;
      
      
      List<task> tskList = new List<Task>();
      for(integer i = 0; i< 5 ; i++){
         Task tsk = new Task();
         tsk.Subject = 'OUTBOUND Call';
         tsk.Priority = 'Normal';
         tsk.Status = 'Completed';
         tsk.Call_Status__c = 'Customer Missed';
         tsk.WhatId = af2.Id;
         tskList.add(tsk);
      }
      
      insert tskList;
      
      
      Task tsk1 = new Task();
      tsk1.Subject = 'INBOUND Call';
      tsk1.Priority = 'Customer Missed';
      tsk1.Status = 'Completed';
      tsk1.Call_Status__c = 'Connected';
      tsk1.WhatId = af2.Id;
      insert tsk1;
      
      EmailMessage email = new EmailMessage();
      email.FromAddress = 'test@abc.org';
      email.Incoming = True;
      email.ToAddress= 'test@xyz.org';
      email.Subject = 'Test email';
      email.HtmlBody = 'Test email body';
      email.RelatedToId = af2.Id;
      insert email;

      ActivityTasksCountHandler.testMethod1();
      
   }
   
   
   @isTest
   static  void TestupdateTaskCountOnAddGrant (){
      System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
      
      Contact con = new Contact();
      con.FirstName = 'Test_First_name';
      con.LastName ='Test_Last _name';
      con.MobilePhone='9123445678';
      con.Email='himanshunimje@live.com';
      con.Type__c='Admission Enquiry';
      con.Enquiry_Link_Sent__c=false;
      con.Contact_Status__c='Qualified';
      con.Contact_Reasons__c='N/A';
      con.Lead__c = leadInsert();
      insert con;
      
      Enquiry__c enq = new Enquiry__c();
      enq.Contact__c =con.Id;
      enq.Enquiry_Type__c='Test_General';
      enq.Date_of_Birth__c=system.today();
      enq.Academic_Year__c='2022-2023';
      enq.FirstName__c='test_Student';
      enq.Last_Name__c='Test';
      enq.Lead__c = leadInsert();
      insert enq;
      
      Application_Form__c af1=new Application_Form__c();
      af1.Academic_Year__c='2020-21';
      af1.Address__c='address';
      af1.Adhaar_Card_No__c='768768765654';
      af1.Father_Annual_Income__c=10000;
      af1.Mother_Anual_Income__c=20000;
      af1.Application_Form_Declaration__c=true;
      af1.Name='rumeli';
      af1.Birth_Place__c='kolkata';
      af1.Blood_Group__c='AB+ve';
      af1.Father_Business_Address__c='Father_Business_Address__c';
      af1.Mother_Business_Address__c='mother_Business_Address__c';
      af1.Father_Business_Contact__c='6767876543';
      af1.Mother_Business_Contact__c='9876787654';
      af1.Category__c='Gen';
      af1.Country__c='india';
      af1.City__c='kolkata';
      af1.Email_Address__c='rumeli@developer.com';
      af1.Enquiry__c=enq.Id;
      af1.Student_Name__c='student';
      af1.Status__c='Application submitted';
      af1.State__c='state';
      af1.School_Institution__c = enq.School_Institution__c;
      af1.Lead__c = leadInsert();
      insert af1;
      
      
      Admission_Form__c af2=new Admission_Form__c();
      af2.Address__c='address';
      af2.Adhaar_Card_No__c='768768765654';
      af2.Name='rumeli';
      af2.Student_Name__c='rumeli';
      af2.Enquiry_No__c=af1.Enquiry__c;
      af2.Student_Name__c='student';
      af2.Application_Form__c=af1.Id;
      af2.Admission_Granted__c=false;
      af2.Called_for_Observation__c=true;
      af2.Document_Received__c=true;
      af2.Last_Name__c='banerjee';
      af2.Mobile_Number__c='9804661694';
      af2.GuardianName__c='rumeli banerjee';
      af2.GuardianEmail_Id__c='rumeli@gmail.com';
      af2.GuardianMobile_No__c='9804661694';
      af2.Nationality__c='Indian';
      af2.Registration_No__c='2019-20/II/UHSC/REG/9';
      // af2.Lead__c = leadInsert();
      // insert af2;
      
      Admission_Granted__c af3=new Admission_Granted__c();
      af3.Adhaar_Card_No__c='123456789098';
      af3.Birth_Place__c='kolkata';
      af3.Category__c='Gen';
      af3.Registration_No__c=af2.Registration_No__c;
      af3.EnquiryNo__c=af1.Enquiry__c;
      af3.Application_Form__c=af1.Id;
      af3.Admission_Form__c=af2.Id;
      af3.Original_Document__c='Received';
      af3.Status__c='Admission Incomplete';
      af3.Fees_Status__c='Paid';
      //   af3.Lead__c = leadInsert();
      // insert af3;
      
      List<task> tskList = new List<Task>();
      for(integer i = 0; i< 5 ; i++){
         Task tsk = new Task();
         tsk.Subject = 'OUTBOUND Call';
         tsk.Priority = 'Normal';
         tsk.Status = 'Completed';
         tsk.Call_Status__c = 'User Disconnected';
         tsk.WhatId = af3.Id;
         tskList.add(tsk);
      }
      
      insert tskList;
      
      
      Task tsk1 = new Task();
      tsk1.Subject = 'INBOUND Call';
      tsk1.Priority = 'Customer Missed';
      tsk1.Status = 'Completed';
      tsk1.Call_Status__c = 'Connected';
      tsk1.WhatId = af3.Id;
      insert tsk1;
      
      
      EmailMessage email = new EmailMessage();
      email.FromAddress = 'test@abc.org';
      email.Incoming = True;
      email.ToAddress= 'test@xyz.org';
      email.Subject = 'Test email';
      email.HtmlBody = 'Test email body';
      email.RelatedToId = af3.Id;
      insert email;

      ActivityTasksCountHandler.testMethod1();
      
      
      
      
   }
   
}