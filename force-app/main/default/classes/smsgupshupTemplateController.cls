/**
 * Created by Admin on 2018-08-17.
 */

public with sharing class smsgupshupTemplateController {
    public smsgupshupTemplate__c template{get;set;}
    public  smsgupshupTemplateController(ApexPages.StandardController controller){
        this.template = (smsgupshupTemplate__c)controller.getRecord();
    }
    public PageReference Save() {
       try {
           PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
           insert this.template;
           pageRef.setRedirect(true);
           return pageRef;
       }catch (Exception ex){
           System.debug(ex.getMessage());
           PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
           return pageRef;
       }


    }
}