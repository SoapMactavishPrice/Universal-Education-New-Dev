@Istest
public class UpdateLeadAdmissionFormTest {
//UpdateLeadAdmissionForm
@isTest
    public static void test()
    {
       Test.startTest();

            UpdateLeadAdmissionForm obj = new UpdateLeadAdmissionForm();
            DataBase.executeBatch(obj); 
            
        Test.stopTest(); 
    }
}