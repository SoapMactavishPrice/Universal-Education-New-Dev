public without sharing class ApplicationFormHandler {

    // public static void changeParentOfAttachments() {
    //     System.debug('START ApplicationFormHandler ');

    //     Map<Id, Id> enquiryToAppForm = new Map<Id, Id>();
    //     for (Application_Form__c appForm : (List<Application_Form__c>)Trigger.new) {
    //         if (appForm.Enquiry__c != null) {
    //             enquiryToAppForm.put(appForm.Enquiry__c, appForm.Id);
    //         }
    //     }
    //     System.debug('enquiryToAppForm :' + enquiryToAppForm);

    //     List<ContentDocumentLink> oldContentDocumentLinks = [
    //         SELECT
    //             Id,
    //             LinkedEntityId,
    //             ContentDocumentId
    //         FROM
    //             ContentDocumentLink
    //         WHERE
    //             LinkedEntityId IN :enquiryToAppForm.keySet()
    //     ];
    //     List<Id> contentDocIds = new List<Id>();
    //     List<Id> contentVerIds = new List<Id>();
    //     for (ContentDocumentLink cdl : oldContentDocumentLinks) {
    //         contentDocIds.add(cdl.ContentDocumentId);
    //     }
    //     //Deleting old public links
    //     // List<ContentDistribution> lstConDist = [
    //     //     SELECT Id, ContentDownloadURL,ContentVersionId
    //     //     FROM ContentDistribution
    //     //     WHERE ContentVersion.ContentDocumentId IN :contentDocIds
    //     // ];
    //     List<ContentVersion> lstConVer = [
    //         Select Id,Description FROM ContentVersion WHERE ContentDocumentId IN :contentDocIds
    //     ];
    //     for (ContentVersion cv : lstConVer) {
    //         String enquiryId = cv.description.split('-')[0];
    //         String photoName = cv.description.split('-')[1];
    //         String appFormId = enquiryToAppForm.get(enquiryId);
    //         // cv.description = appFormId + '-' + photoName;
    //         cv.Title = photoName + '-' + appFormId ;
    //     }
    //     update lstConVer;
    //     System.debug('after converting files ====' + lstConver);
    //     // delete lstConDist;
    //     delete oldContentDocumentLinks;
    //     List<ContentDocumentLink> newContentDocumentLinks = new List<ContentDocumentLink>();
    //     for (ContentDocumentLink cdl : oldContentDocumentLinks) {
    //         newContentDocumentLinks.add(
    //             new ContentDocumentLink(
    //                 LinkedEntityId = enquiryToAppForm.get(cdl.LinkedEntityId),
    //                 ContentDocumentId = cdl.ContentDocumentId
    //             )
    //         );
    //     }
    //     //Update public links for application form
    //     // for (type variable : List_or_set) {

    //     // }
    //     insert newContentDocumentLinks;
    //     // delete oldAttachments;
    //     System.debug('oldContentDocumentLinks: ' + newContentDocumentLinks);
    //     System.debug('END ApplicationFormHandler');

    // }

    public static void changeParentOfAttachments() {
        System.debug('START ApplicationFormHandler ');
    
        Map<Id, Id> enquiryToAppForm = new Map<Id, Id>();
        for (Application_Form__c appForm : (List<Application_Form__c>)Trigger.new) {
            if (appForm.Enquiry__c != null) {
                enquiryToAppForm.put(appForm.Enquiry__c, appForm.Id);
            }
        }
        
        // Return early if no enquiries to process
        if (enquiryToAppForm.isEmpty()) {
            System.debug('No enquiries found to transfer attachments');
            return;
        }
    
        System.debug('enquiryToAppForm :' + enquiryToAppForm);
    
        // Get ContentDocumentLinks with proper filtering
        List<ContentDocumentLink> oldContentDocumentLinks = [
            SELECT Id, LinkedEntityId, ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :enquiryToAppForm.keySet()
        ];
    
        // Return if no attachments found
        if (oldContentDocumentLinks.isEmpty()) {
            System.debug('No attachments found to transfer');
            return;
        }
    
        // Process ContentVersions
        Set<Id> contentDocIds = new Set<Id>();
        for (ContentDocumentLink cdl : oldContentDocumentLinks) {
            contentDocIds.add(cdl.ContentDocumentId);
        }
    
        List<ContentVersion> contentVersions = [
            SELECT Id, Description, Title 
            FROM ContentVersion 
            WHERE ContentDocumentId IN :contentDocIds
            AND IsLatest = true
        ];
    
        // Update ContentVersion titles
        for (ContentVersion cv : contentVersions) {
            if (cv.Description != null && cv.Description.contains('-')) {
                String enquiryId = cv.Description.split('-')[0];
                String photoName = cv.Description.split('-')[1];
                String appFormId = enquiryToAppForm.get(enquiryId);
                if (appFormId != null) {
                    cv.Title = photoName + '-' + appFormId;
                }
            }
        }
        update contentVersions;
    
        // Create new ContentDocumentLinks
        List<ContentDocumentLink> newContentDocumentLinks = new List<ContentDocumentLink>();
        for (ContentDocumentLink cdl : oldContentDocumentLinks) {
            Id newLinkedEntityId = enquiryToAppForm.get(cdl.LinkedEntityId);
            if (newLinkedEntityId != null) {
                newContentDocumentLinks.add(
                    new ContentDocumentLink(
                        LinkedEntityId = newLinkedEntityId,
                        ContentDocumentId = cdl.ContentDocumentId,
                        ShareType = 'V' // 'V' for Viewer permission
                    )
                );
            }
        }
    
        // Delete old links and create new ones
        delete oldContentDocumentLinks;
        insert newContentDocumentLinks;
    
        System.debug('END ApplicationFormHandler');
    }

}