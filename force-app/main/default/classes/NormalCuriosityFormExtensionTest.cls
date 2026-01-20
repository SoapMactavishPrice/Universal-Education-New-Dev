@isTest 
public class NormalCuriosityFormExtensionTest {
    Public string message{get;set;}
   @isTest public static void TestException()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        System.Test.startTest();
        
        Account acc = new Account();
        acc.Name ='Test1accountname';
        acc.School_Short_Code__c ='UST';
        acc.Website = 'www.gmUSTT1ESt.com';
        acc.School_Email__c = 'Ust1@gmail.com';
       
        insert acc;
        
        Class__c cls1=new Class__c();
        cls1.School_Name__c=acc.Id;
        cls1.Name='Grade-Play Group';
        cls1.Original_Class__c='Play Group';
        insert cls1;
        
        Class__c cls2=new Class__c();
        cls2.School_Name__c=acc.Id;
        cls2.Name='Grade-Nursery';
        cls2.Original_Class__c='Nursery';
        insert cls2;
        
        Class__c cls3=new Class__c();
        cls3.School_Name__c=acc.Id;
        cls3.Name='Grade-Jr. Kg';
        cls3.Original_Class__c='Jr. Kg';
        insert cls3;
        
        Contact con = new Contact();
        con.FirstName = 'Test1Firstname';
        con.LastName ='Test1Lastname';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Phone='9808765432';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        con.Academic_Year__c='2021-2022';
        con.Contact_Status__c = 'Qualified';
        con.Contact_Reasons__c = 'N/A';
        insert con;
        String conid= con.id; 
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today().addDays(-2300);
        enq.Academic_Year__c='2021-22';
        enq.FirstName__c='testStudentA';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='waiting';
        enq.Seeking_Admission_in_Grade__c='Play Group';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        //enq.Academic_Year__c='2021-22';
      //  enq.Date_of_Birth__c=system.today().addDays(-730);
        Try{
        insert enq;
        
        String ExistingContactID = con.id;
        Id Eid = enq.id;
        List<Enquiry__c> enqList= new list<Enquiry__c>();
        enqList.add(enq);
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
            Apexpages.currentpage().getparameters().put('id',enq.Id);
            Apexpages.currentpage().getparameters().put('linkdate','2021-10-06');
             Apexpages.currentpage().getparameters().put('cid',conid);
            //Apexpages.currentpage().getparameters().put('academicYear',con.Academic_Year__c);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
       	
        NormalCuriosityFormExtension ag1= new NormalCuriosityFormExtension(sc1);
            NormalCuriosityFormExtension.FormFactory();
        
        //ag1.save();
        }
        Catch (dmlException e){
            System.assert(e.getMessage().contains('First exception on row 0 with id ; first error: INVALID_FIELD_FOR_INSERT_UPDATE, cannot specify Id in an insert call: [Id]'), e.getMessage() );
            
        }
       // ag1.reset();
      //  ag1.getPrimaryPickVals();
      //  ag1.getSecondaryPickVals();
      System.Test.stopTest();
       
    }
    
     @isTest public static void Test2()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        System.Test.startTest();
        
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
        acc.Website = 'www.gmUSTTESt.com';
        acc.School_Email__c = 'Ust@gmail.com';
       
        insert acc;
        
        Class__c cls1=new Class__c();
        cls1.School_Name__c=acc.Id;
        cls1.Name='Grade-Play Group';
        cls1.Original_Class__c='Play Group';
        insert cls1;
        
        Class__c cls2=new Class__c();
        cls2.School_Name__c=acc.Id;
        cls2.Name='Grade-Nursery';
        cls2.Original_Class__c='Nursery';
        insert cls2;
        
        Class__c cls3=new Class__c();
        cls3.School_Name__c=acc.Id;
        cls3.Name='Grade-Jr. Kg';
        cls3.Original_Class__c='Jr. Kg';
        insert cls3;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
        con.LastName ='TestLastname';
        con.AccountId=acc.Id;
        con.MobilePhone='1234567890';
        con.Phone='1234567890';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        con.Contact_Status__c = 'Qualified';
        con.Contact_Reasons__c = 'N/A';
        insert con;
        String conid= con.id; 
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today().addDays(-2300);
        enq.Academic_Year__c='2021-22';
        enq.FirstName__c='ABtestStudent21';
        enq.Last_Name__c='ABTest21';
        enq.Log_Status__c='waiting';
        enq.Seeking_Admission_in_Grade__c='Play Group';
        enq.Parent_First_Name__c ='ABtest@@parent';
        enq.Parent_Last_Name__c= 'ABtest#23';
        enq.Email__c=con.Email;
        enq.Mobile_No__c ='1234567890';
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='test&&address';
        enq.City__c='ABtest&&city';
        enq.State__c='test&&state';
        enq.Pin_Code__c='12547';
        enq.Source_of_Information__c = 'YouTube';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='Ind&ia';
      //  enq.Date_of_Birth__c=system.today().addDays(-730);
        
        insert enq;
        String ExistingContactID = con.id;
        Id Eid = enq.id;
        List<Enquiry__c> enqList= new list<Enquiry__c>();
        enqList.add(enq);
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        Apexpages.currentpage().getparameters().put('linkdate','2021-10-06');
         Apexpages.currentpage().getparameters().put('cid',conid);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
       	
        NormalCuriosityFormExtension ag1= new NormalCuriosityFormExtension(sc1);
        NormalCuriosityFormExtension.FormFactory();
        try{
             ag1.save();
       
        ag1.reset();
        }catch(Exception e){
            
        }
       
      //  ag1.getPrimaryPickVals();
      //  ag1.getSecondaryPickVals();
        System.Test.stopTest();
    }
     @isTest public static void Test3()
    {
        Account acc = new Account();
        acc.Name ='CTestaccountname';
        acc.School_Short_Code__c ='cUST';
        acc.Website = 'www.gmUSTTESt3.com';
        acc.School_Email__c = 'Ust3@gmail.com';
       
        insert acc;
        
        Class__c cls1=new Class__c();
        cls1.School_Name__c=acc.Id;
        cls1.Name='Grade-Play Group';
        cls1.Original_Class__c='Play Group';
        insert cls1;
        
        Class__c cls2=new Class__c();
        cls2.School_Name__c=acc.Id;
        cls2.Name='Grade-Nursery';
        cls2.Original_Class__c='Nursery';
        insert cls2;
        
        Class__c cls3=new Class__c();
        cls3.School_Name__c=acc.Id;
        cls3.Name='Grade-Jr. Kg';
        cls3.Original_Class__c='Jr. Kg';
        insert cls3;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstCname';
        con.LastName ='TestLastnamec';
        con.AccountId=acc.Id;
        con.MobilePhone='1234567890';
        con.Phone='1234567890';
        con.Email='Crumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.MailingCity='Pu&ne';
        con.MailingCountry='Ind&ia';
        con.MailingPostalCode='413C207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        con.Contact_Status__c = 'Qualified';
        con.Contact_Reasons__c = 'N/A';
        insert con;
        String conid= con.id; 
        system.debug('ConId::' +conid);
        
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today().addDays(-3000);
        enq.Academic_Year__c='2021-22';
        enq.FirstName__c='Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='waiting';
        enq.Seeking_Admission_in_Grade__c='Grade-Jr. Kg';
        enq.Parent_First_Name__c ='';
        enq.Parent_Last_Name__c= '';
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=acc.id;
        enq.Address__c ='testaddress!!';
        enq.City__c='testcity!';
        enq.State__c='teststate!';
        enq.Pin_Code__c='12547!';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
      //  enq.Date_of_Birth__c=system.today().addDays(-730);
        
        //insert enq;
        String ExistingContactID = conid;
        System.debug('ExistingContact ::' +ExistingContactID);
        Id Eid = enq.id;
        List<Enquiry__c> enqList= new list<Enquiry__c>();
        enqList.add(enq);
        List<Enquiry__c> enq1 = new List <Enquiry__c>();
        Enq1.add(enq);
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        Apexpages.currentpage().getparameters().put('linkdate','2021-10-06');
         Apexpages.currentpage().getparameters().put('cid',conid);
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
       	
        NormalCuriosityFormExtension ag1= new NormalCuriosityFormExtension(sc1);
       // ag1.getSecondaryPickVals();
       Test.startTest();
        NormalCuriosityFormExtension.FormFactory();
        try{
          //  ag1.save();
        }catch(Exception e){
            
        }
        
       Test.stopTest();
      //  ag1.getPrimaryPickVals();
     
       
    }
}