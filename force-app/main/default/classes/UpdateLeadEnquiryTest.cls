@istest
public class UpdateLeadEnquiryTest {
    @isTest
    public static void test()
    {
       Test.startTest();

            UpdateLeadEnquiry obj = new UpdateLeadEnquiry();
            DataBase.executeBatch(obj); 
            
        Test.stopTest(); 
    }
//UpdateLeadEnquiry
}