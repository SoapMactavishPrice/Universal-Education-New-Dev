@isTest
public class LeadSmsDetailControllerTest {
    @isTest
    public static void testsmsdetail(){
        Lead obj = new Lead(LastName ='Test', Company='test company',MobilePhone='6787547476');
     	insert obj;
        system.debug('id::'+obj.id);
         PageReference pageRef = Page.LeadSMSDetails;
         Test.setCurrentPage(pageRef);
     	pageRef.getParameters().put('Id', String.valueOf(obj.Id));
     	ApexPages.StandardController sc = new ApexPages.StandardController(obj);
     	LeadSMSDetailsController testcon = new LeadSMSDetailsController(sc);
    }
}