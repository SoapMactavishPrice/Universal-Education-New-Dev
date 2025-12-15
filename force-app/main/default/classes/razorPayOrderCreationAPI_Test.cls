@isTest  
public class razorPayOrderCreationAPI_Test 
{
    @isTest public static void testmethod1()
    {
        Contact con = new Contact();
        User u;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        Enquiry__c enq = new Enquiry__c();
        Event ev=new Event();
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            //UserRole r = [SELECT Id FROM UserRole];
            u = new User(alias = 'jsmith', email='jsmith@acme.com', 
                emailencodingkey='UTF-8', lastname='Smith', 
                languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id,
                timezonesidkey='America/Los_Angeles', 
                username='tt_jsmith@acme123.com');
            insert u;
            
            
            Account acc = new Account();
            acc.Name ='Universal Test';
            acc.School_Short_Code__c = 'STELRA';
            insert acc;
            
            con.FirstName = 'Test_First_name';
            con.LastName ='Test_Last _name';
            con.AccountId = acc.Id;
            con.MobilePhone='9123445678';
            con.Email='rumeli@developer.com';
            con.Type__c='Admission Enquiry';
            insert con;
            
            enq.Contact__c =con.Id;
            enq.Enquiry_Type__c='Test_General';
            enq.Date_of_Birth__c=system.today();
            enq.Academic_Year__c='2015';
            enq.FirstName__c='test_Student';
            enq.Last_Name__c='Test';
            enq.Log_Status__c='On Hold';
            enq.Seeking_Admission_in_Grade__c='II';
            enq.Parent_First_Name__c ='test_parent';
            enq.Parent_Last_Name__c= con.LastName;
            enq.Email__c=con.Email;
            enq.Mobile_No__c =con.MobilePhone;
            enq.School_Institution__c=con.AccountId;
            enq.Address__c ='test_address';
            enq.City__c='test_city';
            enq.State__c='test_state';
            enq.Pin_Code__c='125479';
            enq.Source_of_Information__c = 'test_source';
            enq.Stages__c='Application submitted';
            enq.Application_Received__c=true;
            enq.Application_Sent__c=true;
            enq.School_Tour_Scheduled__c=false;
            enq.School_Tour_Re_Scheduled__c=false;
            enq.Interaction_Done__c=false;
            enq.School_Institution__c = acc.ID;
            //enq.Receipt_No__c='test receipt';
            insert enq;
            
            Razorpay_Endpoint__c razPay = new Razorpay_Endpoint__c();
            razPay.Name='Create Order';
            razPay.Endpoint__c='https://api.razorpay.com/v1/orders';
            insert razPay;
            
            Universal_Application_Fee_Amount__mdt mtd = new Universal_Application_Fee_Amount__mdt();
            mtd.Short_Code__c = 'STELRA';
            mtd.Payment_Applicable__c = true;
            mtd.Payment_Gateway__c = 'RazorPay';
            mtd.Key_Id__c = 'rzp_test_V4tW33rwuOePMh';
            mtd.Key_Secret__c = '5tlWQPCPHFB2pnjWde0gcRQk';
            
            razorPayOrderCreationAPI.requesrCall rq = new razorPayOrderCreationAPI.requesrCall();
            rq.amount = 1200;
            rq.ccurrency = 'INR';
            rq.receipt = enq.Receipt_No__c;
            
            test.starttest();
            System.Test.setMock(HttpCalloutMock.class, new OrderCreationMock());
            razorPayOrderCreationAPI.OrderCreation(enq.id,1200);
            test.stoptest();
            }
       }
}