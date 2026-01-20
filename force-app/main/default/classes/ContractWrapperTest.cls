@isTest public class ContractWrapperTest {
	
    @isTest public static void testmethod1()
    {
         Account acc = new Account();
        acc.Name ='Testaccountname';
        insert acc;
        
        Boolean isSelected;
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
   		con.LastName ='TestLastname';
   		con.AccountId=acc.Id;
   		con.MobilePhone='9123445678';
    	con.Email='rumeli@gmail.com';
    	con.Type__c='Admission Enquiry';
    	insert con;
        
        ContractWrapperCls cn=new ContractWrapperCls(con,isSelected);
        ContractWrapperCls cn1=new ContractWrapperCls(con);
    }
}