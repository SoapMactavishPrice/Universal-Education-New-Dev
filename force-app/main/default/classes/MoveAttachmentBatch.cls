global class MoveAttachmentBatch implements Database.Batchable<sObject> {
    Id recIdTo;
    public MoveAttachmentBatch(Id recId) {
        recIdTo = recId;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
         
        String query = 'Select Id,Enquiry__c  From  Application_Form__c WHERE Enquiry__c != NULL AND Id = :recIdTo';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Application_Form__c> lstAF ) {
        
        // process each batch of records default size is 200
        
        
                changeParentOfAttachments(lstAF);
         
        
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
    
    

    public static void changeParentOfAttachments( List<Application_Form__c> lstAF) {
        System.debug('START ApplicationFormHandler ');

        Map<Id, Id> enquiryToAppForm = new Map<Id, Id>();
        for (Application_Form__c appForm : lstAF) {
            if (appForm.Enquiry__c != null) {
                enquiryToAppForm.put(appForm.Enquiry__c, appForm.Id);
            }
        }
        System.debug('enquiryToAppForm :' + enquiryToAppForm);

        List<ContentDocumentLink> oldContentDocumentLinks = [
            SELECT
                Id,
                LinkedEntityId,
                ContentDocumentId
            FROM
                ContentDocumentLink
            WHERE
                LinkedEntityId IN :enquiryToAppForm.keySet()
        ];
        System.debug('oldContentDocumentLinks :' + oldContentDocumentLinks);
        List<Id> contentDocIds = new List<Id>();
        List<Id> contentVerIds = new List<Id>();
        for (ContentDocumentLink cdl : oldContentDocumentLinks) {
            contentDocIds.add(cdl.ContentDocumentId);
        }
        //Deleting old public links
        // List<ContentDistribution> lstConDist = [
        //     SELECT Id, ContentDownloadURL,ContentVersionId
        //     FROM ContentDistribution
        //     WHERE ContentVersion.ContentDocumentId IN :contentDocIds
        // ];
        List<ContentVersion> lstConVer = [
            Select Id,Description FROM ContentVersion WHERE ContentDocumentId IN :contentDocIds
        ];
        for (ContentVersion cv : lstConVer) {
            String enquiryId = (String.isNotBlank(cv.description)&&cv.description.contains('-'))
                               ?cv.description.split('-')[0]:'test';
            String photoName = (String.isNotBlank(cv.description)&&cv.description.contains('-'))
                            ?cv.description.split('-')[1]:'test';
            system.debug('enquiryId'+enquiryId);
            system.debug('enquiryId.startsWithIgnoreCase'+ enquiryId.startsWithIgnoreCase('a01'));
            String appFormId;
            if(enquiryId.startsWithIgnoreCase('a01')){
                 appFormId = enquiryToAppForm.get(enquiryId);
            }else{
                 appFormId = 'test';
            }
            cv.description = appFormId + '-' + photoName;
            cv.Title = photoName + '-' + appFormId ;
        }
        update lstConVer;
        System.debug('after converting files ====' + lstConver);
        List<ContentDocumentLink> newContentDocumentLinks = new List<ContentDocumentLink>();
        for (ContentDocumentLink cdl : oldContentDocumentLinks) {
            newContentDocumentLinks.add(
                new ContentDocumentLink(
                    LinkedEntityId = enquiryToAppForm.get(cdl.LinkedEntityId),
                    ContentDocumentId = cdl.ContentDocumentId
                )
            );
        }
        //Update public links for application form
        // for (type variable : List_or_set) {

        // }
        insert newContentDocumentLinks;
        
        // delete lstConDist;
        delete oldContentDocumentLinks;
        
        // delete oldAttachments;
        System.debug('oldContentDocumentLinks: ' + newContentDocumentLinks);
        System.debug('END ApplicationFormHandler');

    }


}