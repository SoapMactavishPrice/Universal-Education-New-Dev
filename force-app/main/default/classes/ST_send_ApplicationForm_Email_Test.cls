@isTest
public class ST_send_ApplicationForm_Email_Test {
     @isTest
    public static void aftestmethod(){
        
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open',
        //    School_Institution__c = testSchool.Id,
            Current_Location__c = 'Test Location'
        );
        insert testLead;
        
        Account acc = new Account();
            acc.Name ='Universal Test';
            acc.School_Short_Code__c = 'STELRA';
            insert acc;
            
    
    Contact con = new Contact();
    con.FirstName = 'Test_First_name';
    con.LastName ='Test_Last _name';
    con.Lead__c =testLead.Id;
    con.AccountId=acc.Id;
    con.MobilePhone='9123445678';
    con.Email='biswajit@developer.com';
    con.Type__c='Admission Enquiry';
    insert con;
    
      
        
        Enquiry__c enq=new Enquiry__c();
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
            enq.Lead__c =testLead.Id;
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
            enq.School_Tour_Scheduled__c=True;
            enq.School_Tour_Re_Scheduled__c=True;
            enq.Interaction_Done__c=True;
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
        
        PageReference pageRef = Page.UE_sendApplication;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(enq.Id));
        ST_send_ApplicationForm_through_Email temp= new ST_send_ApplicationForm_through_Email();
        //ST_send_ApplicationForm_through_Email.fakeMethod();
        temp.send();
       // temp.isTestingStellar = true;
        temp.send();
        temp.cancel();
        enq.Stages__c='Application submitted';
        //update eq
        //eq.Stages__c='Application (Rejected)';
        //update eq;
        enq.Application_Sent__c=FALSE;
        enq.Interaction_Done__c=FALSE;
        enq.Application_Received__c=FALSE;
        update enq;
        temp.send();
        enq.Stages__c='Interested';
        enq.Email__c = 'b@jogi.com';
        temp.send();
        temp.cancel();
        enq.Stages__c='Application (Rejected)';
        enq.Email__c=null;
        update enq;
        temp.send();
        temp.cancel();
        enq.Stages__c='Application Link Sent';
        enq.Application_Sent__c=True;
        update enq;
        temp.send();
        temp.cancel();
        
         test.starttest();
            System.Test.setMock(HttpCalloutMock.class, new OrderCreationMock());
            razorPayOrderCreationAPI.OrderCreation(enq.id,1200);
            test.stoptest();
        }
}