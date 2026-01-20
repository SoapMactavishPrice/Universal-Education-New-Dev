@isTest
public class UpdateLeadContactTest {
    @isTest
    public static void test()
    {
       Test.startTest();

            UpdateLeadContact obj = new UpdateLeadContact();
            DataBase.executeBatch(obj); 
            
        Test.stopTest(); 
    }

}