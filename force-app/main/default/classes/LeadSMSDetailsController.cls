public with sharing class  LeadSMSDetailsController {
    public  List<smsgupshup__c> smsgupshups {get;set;}

    public  LeadSMSDetailsController(ApexPages.StandardController controller){
        String ContactID = ApexPages.currentPage().getParameters().get('id');
        system.debug('ids::'+ContactID);
        smsgupshups=[SELECT Contact_ID__c,Contact_Name_Number__c,Message__c,Sender_Number__c FROM  smsgupshup__c WHERE Contact_ID__c=:ContactID];

    }
}