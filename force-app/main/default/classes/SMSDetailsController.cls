/**
 * Created by Admin on 2018-08-16.
 */

public with sharing class SMSDetailsController {
    public  List<smsgupshup__c> smsgupshups {get;set;}

    public  SMSDetailsController(ApexPages.StandardController controller){
        String ContactID = ApexPages.currentPage().getParameters().get('id');
        smsgupshups=[SELECT Contact_ID__c,Contact_Name_Number__c,Message__c,Sender_Number__c FROM  smsgupshup__c WHERE Contact_ID__c=:ContactID];

    }
}