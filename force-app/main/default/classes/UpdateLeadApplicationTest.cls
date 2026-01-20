@istest
public class UpdateLeadApplicationTest {
    //UpdateLeadApplication
@isTest
    public static void test()
    {
       Test.startTest();

            UpdateLeadApplication obj = new UpdateLeadApplication();
            DataBase.executeBatch(obj); 
            
        Test.stopTest(); 
    }
}