public without sharing class TransferNotesAcrossSystem {

    /**
     * Note Transfer from Lead to Contact.
     */
    public static void syncLeadNotesToContact(List<Contact> newList, Map<Id, Contact> oldMap) {

        Set<Id> leadIds = new Set<Id>();
        Map<Id, Id> contactIdByLeadId = new Map<Id, Id>();

        if (oldMap == null) {
            for (Contact con : newList) {
                if (con.Lead__c != null) {
                    leadIds.add(con.Lead__c);
                    contactIdByLeadId.put(con.Lead__c, con.Id);
                }
            }
        } else {
            for (Contact con : newList) {
                Contact oldCon = oldMap.get(con.Id);
                if (con.Lead__c != null && oldCon.Lead__c != con.Lead__c) {
                    leadIds.add(con.Lead__c);
                    contactIdByLeadId.put(con.Lead__c, con.Id);
                }
            }
        }

        if (leadIds.isEmpty()) return;

        List<ContentDocumentLink> leadLinks = [
            SELECT ContentDocumentId, LinkedEntityId, ShareType, Visibility
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :leadIds
        ];

        if (leadLinks.isEmpty()) return;

        Set<Id> contactIds = new Set<Id>(contactIdByLeadId.values());

        Set<String> existingKeys = new Set<String>();
        for (ContentDocumentLink cdl : [
            SELECT ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :contactIds
        ]) {
            existingKeys.add(cdl.LinkedEntityId + '-' + cdl.ContentDocumentId);
        }

        List<ContentDocumentLink> toInsert = new List<ContentDocumentLink>();

        for (ContentDocumentLink leadLink : leadLinks) {
            Id contactId = contactIdByLeadId.get(leadLink.LinkedEntityId);
            if (contactId == null) continue;

            String key = contactId + '-' + leadLink.ContentDocumentId;
            if (existingKeys.contains(key)) continue;

            ContentDocumentLink newLink = new ContentDocumentLink();
            newLink.LinkedEntityId = contactId;
            newLink.ContentDocumentId = leadLink.ContentDocumentId;
            newLink.ShareType = leadLink.ShareType;
            newLink.Visibility = leadLink.Visibility;

            toInsert.add(newLink);
        }

        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
    }

    /**
     * Note Transfer from Contact to Enquiry.
     */
    public static void syncContactNotesToEnquiry(List<Enquiry__c> newList, Map<Id, Enquiry__c> oldMap) {

        Set<Id> contactIds = new Set<Id>();
        Map<Id, Id> enquiryIdByContactId = new Map<Id, Id>();

        if (oldMap == null) {
            for (Enquiry__c enq : newList) {
                if (enq.Contact__c != null) {
                    contactIds.add(enq.Contact__c);
                    enquiryIdByContactId.put(enq.Contact__c, enq.Id);
                }
            }
        } else {
            for (Enquiry__c enq : newList) {
                Enquiry__c oldEnq = oldMap.get(enq.Id);
                if (enq.Contact__c != null && oldEnq.Contact__c != enq.Contact__c) {
                    contactIds.add(enq.Contact__c);
                    enquiryIdByContactId.put(enq.Contact__c, enq.Id);
                }
            }
        }

        if (contactIds.isEmpty()) return;

        List<ContentDocumentLink> contactLinks = [
            SELECT ContentDocumentId, LinkedEntityId, ShareType, Visibility
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :contactIds
        ];

        if (contactLinks.isEmpty()) return;

        Set<Id> enquiryIds = new Set<Id>(enquiryIdByContactId.values());

        Set<String> existingKeys = new Set<String>();
        for (ContentDocumentLink cdl : [
            SELECT ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :enquiryIds
        ]) {
            existingKeys.add(cdl.LinkedEntityId + '-' + cdl.ContentDocumentId);
        }

        List<ContentDocumentLink> toInsert = new List<ContentDocumentLink>();

        for (ContentDocumentLink contactLink : contactLinks) {
            Id enquiryId = enquiryIdByContactId.get(contactLink.LinkedEntityId);
            if (enquiryId == null) continue;

            String key = enquiryId + '-' + contactLink.ContentDocumentId;
            if (existingKeys.contains(key)) continue;

            ContentDocumentLink newLink = new ContentDocumentLink();
            newLink.LinkedEntityId = enquiryId;
            newLink.ContentDocumentId = contactLink.ContentDocumentId;
            newLink.ShareType = contactLink.ShareType;
            newLink.Visibility = contactLink.Visibility;

            toInsert.add(newLink);
        }

        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
    }

    /**
     * Note Transfer from Enquiry to Application Form.
     */
    @AuraEnabled
    public static Integer transferNotesFromEnquiryToApplicationForm(Id applicationFormId) {
        if (applicationFormId == null) return 0;

        Application_Form__c app = [
            SELECT Id, Enquiry__c
            FROM Application_Form__c
            WHERE Id = :applicationFormId
            LIMIT 1
        ];

        if (app.Enquiry__c == null) return 0;

        List<ContentDocumentLink> enquiryLinks = [
            SELECT ContentDocumentId, ShareType, Visibility
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :app.Enquiry__c
        ];

        if (enquiryLinks.isEmpty()) return 0;

        Set<Id> enquiryDocIds = new Set<Id>();
        for (ContentDocumentLink cdl : enquiryLinks) {
            enquiryDocIds.add(cdl.ContentDocumentId);
        }

        Set<Id> alreadyLinked = new Set<Id>();
        for (ContentDocumentLink existing : [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :applicationFormId
            AND ContentDocumentId IN :enquiryDocIds
        ]) {
            alreadyLinked.add(existing.ContentDocumentId);
        }

        List<ContentDocumentLink> toInsert = new List<ContentDocumentLink>();

        for (ContentDocumentLink parentLink : enquiryLinks) {
            if (alreadyLinked.contains(parentLink.ContentDocumentId)) continue;

            ContentDocumentLink newLink = new ContentDocumentLink();
            newLink.LinkedEntityId = applicationFormId;
            newLink.ContentDocumentId = parentLink.ContentDocumentId;
            newLink.ShareType = parentLink.ShareType;
            newLink.Visibility = parentLink.Visibility;

            toInsert.add(newLink);
        }

        if (!toInsert.isEmpty()) {
            insert toInsert;
        }

        return toInsert.size();
    }


    /**
     * Note Transfer from Application Form to Admission Form.
     */
    public static void syncApplicationFormNotesToAdmissionForm(
        List<Admission_Form__c> newList,
        Map<Id, Admission_Form__c> oldMap
    ) {
        Set<Id> appFormIds = new Set<Id>();
        Map<Id, Id> admissionIdByAppFormId = new Map<Id, Id>();

        if (oldMap == null) {
            for (Admission_Form__c adm : newList) {
                if (adm.Enquiry_No__c != null) {
                    appFormIds.add(adm.Enquiry_No__c);
                    admissionIdByAppFormId.put(adm.Enquiry_No__c, adm.Id);
                }
            }
        } else {
            for (Admission_Form__c adm : newList) {
                Admission_Form__c oldAdm = oldMap.get(adm.Id);
                if (adm.Enquiry_No__c != null && oldAdm.Enquiry_No__c != adm.Enquiry_No__c) {
                    appFormIds.add(adm.Enquiry_No__c);
                    admissionIdByAppFormId.put(adm.Enquiry_No__c, adm.Id);
                }
            }
        }

        if (appFormIds.isEmpty()) return;

        List<ContentDocumentLink> appLinks = [
            SELECT ContentDocumentId, LinkedEntityId, ShareType, Visibility
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :appFormIds
        ];

        if (appLinks.isEmpty()) return;

        Set<Id> admissionIds = new Set<Id>(admissionIdByAppFormId.values());

        Set<String> existingKeys = new Set<String>();
        for (ContentDocumentLink cdl : [
            SELECT ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :admissionIds
        ]) {
            existingKeys.add(cdl.LinkedEntityId + '-' + cdl.ContentDocumentId);
        }

        List<ContentDocumentLink> toInsert = new List<ContentDocumentLink>();

        for (ContentDocumentLink appLink : appLinks) {
            Id admissionId = admissionIdByAppFormId.get(appLink.LinkedEntityId);
            if (admissionId == null) continue;

            String key = admissionId + '-' + appLink.ContentDocumentId;
            if (existingKeys.contains(key)) continue;

            ContentDocumentLink newLink = new ContentDocumentLink();
            newLink.LinkedEntityId = admissionId;
            newLink.ContentDocumentId = appLink.ContentDocumentId;
            newLink.ShareType = appLink.ShareType;
            newLink.Visibility = appLink.Visibility;

            toInsert.add(newLink);
        }

        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
    }

    /**
     * Note Transfer from Admission From to Admission Granted.
     */
    public static void syncAdmissionFormNotesToAdmissionGranted(
        List<Admission_Granted__c> newList,
        Map<Id, Admission_Granted__c> oldMap
    ) {

        Set<Id> admissionFormIds = new Set<Id>();
        Map<Id, Id> grantedIdByAdmissionFormId = new Map<Id, Id>();

        if (oldMap == null) {
            for (Admission_Granted__c ag : newList) {
                if (ag.Admission_Form__c != null) {
                    admissionFormIds.add(ag.Admission_Form__c);
                    grantedIdByAdmissionFormId.put(ag.Admission_Form__c, ag.Id);
                }
            }
        } else {
            for (Admission_Granted__c ag : newList) {
                Admission_Granted__c oldAg = oldMap.get(ag.Id);
                if (ag.Admission_Form__c != null && oldAg.Admission_Form__c != ag.Admission_Form__c) {
                    admissionFormIds.add(ag.Admission_Form__c);
                    grantedIdByAdmissionFormId.put(ag.Admission_Form__c, ag.Id);
                }
            }
        }

        if (admissionFormIds.isEmpty()) return;

        List<ContentDocumentLink> admissionFormLinks = [
            SELECT ContentDocumentId, LinkedEntityId, ShareType, Visibility
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :admissionFormIds
        ];

        if (admissionFormLinks.isEmpty()) return;

        Set<Id> grantedIds = new Set<Id>(grantedIdByAdmissionFormId.values());

        Set<String> existingKeys = new Set<String>();
        for (ContentDocumentLink cdl : [
            SELECT ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :grantedIds
        ]) {
            existingKeys.add(cdl.LinkedEntityId + '-' + cdl.ContentDocumentId);
        }

        List<ContentDocumentLink> toInsert = new List<ContentDocumentLink>();

        for (ContentDocumentLink formLink : admissionFormLinks) {
            Id grantedId = grantedIdByAdmissionFormId.get(formLink.LinkedEntityId);
            if (grantedId == null) continue;

            String key = grantedId + '-' + formLink.ContentDocumentId;
            if (existingKeys.contains(key)) continue;

            ContentDocumentLink newLink = new ContentDocumentLink();
            newLink.LinkedEntityId = grantedId;
            newLink.ContentDocumentId = formLink.ContentDocumentId;
            newLink.ShareType = formLink.ShareType;
            newLink.Visibility = formLink.Visibility;

            toInsert.add(newLink);
        }

        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
    }

    
}