@isTest public class UE_normalEnquiryFormTest {
  Public string message{get;set;}
  /*
    @isTest public static void testmethod1()
    {
        
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Academic_Year__c='2019-20';
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='test_address';
        enq.City__c='test_city';
        enq.State__c='test_state';
        enq.Pin_Code__c='125479';
        enq.Autonumber_apexClass__c = 1;
        enq.Source_of_Information__c = 'test_source';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-730);
        insert enq;
       
        string conid = con.id ; 
        String ExistingContactID = con.id;
        Id Eid = enq.id;
        List<Enquiry__c> enqList= new list<Enquiry__c>();
        enqList.add(enq);

       test.startTest();
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
       // ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
       
        test.stopTest();
    }
    
    @isTest public static void testmethod2()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
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
        
        insert enq;
       String ExistingContactID = con.id;
        Id Eid = enq.id;
        List<Enquiry__c> enqList= new list<Enquiry__c>();
        enqList.add(enq);
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    
    @isTest public static void testmethod3()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='testStuden#;@t';
        enq.Last_Name__c='Test@;';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testp@;arent';
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
        enq.Date_of_Birth__c=system.today().addDays(-730);
        
        insert enq;
        String ExistingContactID = con.id;
        Id Eid = enq.id;
        List<Enquiry__c> enqList= new list<Enquiry__c>();
        enqList.add(enq);
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    
    @isTest public static void testmethod4()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test;';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
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
        enq.Date_of_Birth__c=system.today().addDays(-1095);
        
        insert enq;
       
       String ExistingContactID = con.id;
        Id Eid = enq.id;
        List<Enquiry__c> enqList= new list<Enquiry__c>();
        enqList.add(enq);
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
       // ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    @isTest public static void testmethod5()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2021-22';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test;';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Autonumber_apexClass__c = 1;
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-1460);
        
        insert enq;
        String ExistingContactID = enq.Contact__c;
        Id Eid = enq.id;
        List<Enquiry__c> enqList= new list<Enquiry__c>();
        enqList.add(enq);
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    @isTest public static void testmethod6()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        con.MobilePhone='9123445';
        con.Phone='9808765432';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test;';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
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
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
        String ExistingContactID = enq.Contact__c; 
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    @isTest public static void testmethod7()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
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
        
        /*Contact con = new Contact();
        con.FirstName = 'TestFirstname';
        con.LastName ='TestLastname';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Phone='9808765432';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        insert con;
       Already */
    /*    Enquiry__c enq = new Enquiry__c();
       //   enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test;';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
      //  enq.Parent_Last_Name__c= con.LastName;
      //  enq.Email__c=con.Email;
      //  enq.Mobile_No__c =con.MobilePhone;
      //  enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress@';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-2190);
        //enq.orgCode__c='UHSC';
        
        insert enq;
     	String ExistingContactID = enq.contact__c ;
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
     //   ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    /*
    @isTest public static void testmethod8()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
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
        con.FirstName = 'acb';
        con.LastName ='fgj';
        con.AccountId=acc.Id;
        con.MobilePhone='9129129120';
        con.Phone='9129129120';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
         Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='23456kskk';
        enq.Last_Name__c='3453ksk45435';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='34534DS535';
        enq.Parent_Last_Name__c= '235345SL435';
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='tes!taddress';
        enq.City__c='3lsll54345';
        enq.State__c='ajs34535435';
        enq.Pin_Code__c='tet';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
          List<Contact>ExistingContact = new List<contact>();
        ExistingContact.add(con);
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
     //   ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    
     @isTest public static void testmethod9()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        con.FirstName = 'asdfg';
        con.LastName ='abc';
        con.AccountId=acc.Id;
        con.MobilePhone='9123211234';
        con.Phone='9809808900';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
         Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='abc23456';
        enq.Last_Name__c='abc345345435';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='abc34534535';
        enq.Parent_Last_Name__c= 'abc235345435';
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone + 'xyz';
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='@testaddress!';
        enq.City__c='xyz354345';
        enq.State__c='xus34535435';
        enq.Pin_Code__c='tet222002';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
          List<Contact>ExistingContact = new List<contact>();
        ExistingContact.add(con);
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
     //   ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
       
    @isTest public static void testmethod10()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        con.MobilePhone='9123467847';
        con.Phone='9808765432';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2019-20';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='test@address';
        enq.City__c='test@city';
        enq.State__c='test@state';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India23';
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    
    @isTest public static void testmethod11()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        con.MobilePhone='9123445908';
        con.Phone='9808765432';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2020-21';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test;';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='12testparent';
        enq.Parent_Last_Name__c= '';
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
        enq.Country__c='';
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    
    @isTest public static void testmethod12()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        con.MobilePhone='9123440895';
        con.Phone='9808765432';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2020-21';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= 'test';
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125&&479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    
    @isTest public static void testmethod13()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        con.MobilePhone='9123445000';
        con.Phone='9808765432';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2020-21';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testadress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    
    @isTest public static void testmethod14()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        con.MobilePhone='9123445000';
        con.Phone='9808765432';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2019-20';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='';
        enq.State__c='';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    
    @isTest public static void testmethod15()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        con.MobilePhone='9123445000';
        con.Phone='9808765432';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2020-21';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.Autonumber_apexClass__c = 12; 
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'YouTube';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
        String ExistingContactId = enq.Contact__c;
        Id eid = enq.id; 
        List<Enquiry__c> enqList=[Select id,Autonumber_apexClass__c,contact__r.FirstName from Enquiry__c where id =:eid order by createddate desc NULLS LAST limit 1];
       
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }

    @isTest public static void testmethod16()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        con.MobilePhone='9123445000';
        con.Phone='9808765432';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2021-22';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125#479';
        enq.Source_of_Information__c = 'YouTube';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
    @isTest public static void testmethod17()
    {
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c ='UST';
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
        con.FirstName = '';
        con.LastName ='TestLastname';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445000';
        con.Phone='9808765432';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='test@city';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
      //  ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
    }
 */ 

/*
    @isTest public static void testmethodNegative()
    {
       Account acc = new Account();
        acc.Name ='Testaccountname';
        insert acc;
        
        Class__c cls1=new Class__c();
        cls1.School_Name__c=acc.Id;
        cls1.Name='Grade-Play Group';
        cls1.Original_Class__c='Play Group';
        insert cls1;
        
              
        Contact con = new Contact();
        con.FirstName = '234@snfalfsnitest fail';
        con.LastName ='456456546';
       // con.AccountId=acc.Id;
        con.MobilePhone='912';
        con.Phone='980';
        con.Email='rumeli@developer.com';
        con.Type__c='fail';
        con.phone='9898989898';
        con.MailingCity='Pune';
        con.MailingCountry='India';
        con.MailingPostalCode='413207';
        con.MailingState='Maharashtra';
        con.MailingStreet='VN';
        insert con;
        
         Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='sdgfhj23456';
        enq.Last_Name__c='adfg345345435';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='fhk34534535';
        enq.Parent_Last_Name__c= 'avh235345435';
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='354345';
        enq.State__c='34535435';
        enq.Pin_Code__c='21345';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Country__c='India';
        enq.Date_of_Birth__c=system.today().addDays(-1825);
        
        insert enq;
        
        string conid = con.id ; 
        String ExistingContactID = con.id;
        Id Eid = enq.id;
        List<Enquiry__c> enqList= new list<Enquiry__c>();
        enqList.add(enq);
        
        test.startTest();
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
        ag1.save();
        ag1.reset();
     //   ag1.getPrimaryPickVals();
        ag1.getSecondaryPickVals();
        
        test.stopTest();
    }
    */
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
        con.Academic_Year__c = '2022-2023';
        insert con;
        String conid= con.id; 
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.FirstName__c='test';
        enq.Last_Name__c='Test';
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today().addDays(-2300);
        enq.Academic_Year__c='2021-2022';
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
      //  enq.Date_of_Birth__c=system.today().addDays(-730);
        Try{
        insert enq;
        
        String ExistingContactID = con.id;
        Id Eid = enq.id;
        List<Enquiry__c> enqList= new list<Enquiry__c>();
        enqList.add(enq);
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('cid',con.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
       	
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        
            ag1.getSecondaryPickVals();
        ag1.save();
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
        con.Academic_Year__c = '2022-2023';
        insert con;
        String conid= con.id; 
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today().addDays(-2300);
        enq.Academic_Year__c='2021-2022';
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
        //Id Eid = enq.id;
        //List<Enquiry__c> enqList= new list<Enquiry__c>();
        //enqList.add(enq);
        
        PageReference pageRef = Page.normalEnquiryForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('cid',con.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
       	
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
        UE_normalEnquiryForm.FormFactory();
        ag1.save();
       
        ag1.reset();
      //  ag1.getPrimaryPickVals();
      //  ag1.getSecondaryPickVals();
      System.test.stopTest();
        
    }
     @isTest public static void Test3()
    {
        
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        
        System.Test.startTest();
        
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
        con.Academic_Year__c = '2022-2023';
        insert con;
        String conid= con.id; 
        system.debug('ConId::' +conid);
        
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today().addDays(-3000);
        enq.Academic_Year__c='2021-2022';
        enq.FirstName__c='Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='waiting';
        enq.Seeking_Admission_in_Grade__c='Nursery';
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
        Apexpages.currentpage().getparameters().put('cid',con.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
       	
        UE_normalEnquiryForm ag1= new UE_normalEnquiryForm(sc1);
       // ag1.getSecondaryPickVals();
        ag1.save();
       
      //  ag1.getPrimaryPickVals();
             System.Test.stopTest();

       
    }

    
}