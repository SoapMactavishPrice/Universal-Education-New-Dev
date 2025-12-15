public without sharing class FileUploadController {

   @AuraEnabled
    public static Id saveAttachment(Id parentId, String fileName, String base64Data, String contentType, String ext) {
        String descText = parentId+'-'+fileName;
        List<ContentDocument> conDocs = new List<ContentDocument>();
        for(ContentVersion cv : [
            SELECT Id,ContentDocumentId FROM ContentVersion WHERE Description like :descText
        ]) {
            conDocs.add(
                new ContentDocument(Id = cv.ContentDocumentId)
            );
        }
        //To delete old Images for same photoType and same RecordId
        System.debug('conDocs ' + conDocs);
        delete conDocs;

        ContentVersion cv = new ContentVersion();
        cv.Title = fileName+'.'+ext;
        cv.PathOnClient = fileName+'.'+ext;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.IsMajorVersion = true;
        cv.description=parentId+'-'+fileName;
        Insert cv;

      /*  ContentDistribution cd = new ContentDistribution();
        cd.Name = fileName;
        cd.ContentVersionId = cv.Id;
        insert cd;*/

        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;

        //Create ContentDocumentLink
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = parentId;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        return cv.id;
    }

   @AuraEnabled
    public static String getPic(Id parent, String photoName) {

        System.debug('For Enquiry Page');
        String valueToSearch = parent+'-'+photoName;
        System.debug('valuetosearch' + valueToSearch);
        // photoName += '%';
        List<ContentDistribution> lst =  [
            SELECT Id, ContentDownloadURL
            FROM ContentDistribution
            WHERE ContentVersion.description = :valueToSearch
        ];
        System.debug('lst' + lst);
        if (lst.size() > 0) {
            return lst[0].ContentDownloadUrl;
        }
        else {
            return null;
        }


    }


}