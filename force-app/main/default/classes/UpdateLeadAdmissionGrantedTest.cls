@isTest
public class UpdateLeadAdmissionGrantedTest {
    @isTest
    public static void test()
    {
       Test.startTest();

            UpdateLeadAdmissionGranted obj = new UpdateLeadAdmissionGranted();
            DataBase.executeBatch(obj); 
            
        Test.stopTest(); 
    }
    //UpdateLeadAdmissionGranted

}