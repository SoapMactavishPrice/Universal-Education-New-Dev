@isTest

public class ContactWrapperClsTest 
{
  
public static TestMethod void ContactWrapperTest()
    {
    
   Contact con = new Contact();
    con.LastName = 'Name';
    insert con;
    boolean selected = false;
    ContractWrapperCls wrap = new ContractWrapperCls(con);
    ContractWrapperCls wrap1 = new ContractWrapperCls(con , selected );
    wrap1.isSelected=False;
    }
        
}