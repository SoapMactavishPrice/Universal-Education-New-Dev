public class enqScheduleCampusVisitLWC {

    @AuraEnabled(cacheable=true)
    public static Map<String, object> getEnquiryName(Id enquiryId) {
        // Query the Contact record based on the provided contactId
        enquiry__c enquiryRecord = [SELECT Name,Contact__c, School_Institution__r.Name,School_Institution__r.School_Short_Code__c,orgCode__c,
                                    School_Tour_Scheduled__c
                                    FROM Enquiry__c WHERE Id = :enquiryId LIMIT 1];
        
        // Create a map to return multiple fields
        Map<String, object> enquiryInfo = new Map<String, object>();
        enquiryInfo.put('EnquiryName', enquiryRecord.Name);
        enquiryInfo.put('EnquiryContact', enquiryRecord.Contact__c);
        enquiryInfo.put('SchoolTourScheduled', enquiryRecord.School_Tour_Scheduled__c);
        enquiryInfo.put('SchoolName', enquiryRecord.School_Institution__r != null ? enquiryRecord.School_Institution__r.Name : null);
        enquiryInfo.put('Schoolid', enquiryRecord.School_Institution__c);
        enquiryInfo.put('SchoolShortCode', enquiryRecord.orgCode__c);
        
        
        return enquiryInfo;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static Map<String, object> re_schgetEnquiryName(Id enquiryId) {
        // Query the Contact record based on the provided contactId
        enquiry__c enquiryRecord = [SELECT Name,Contact__c, School_Institution__r.Name,School_Institution__r.School_Short_Code__c,orgCode__c,School_Tour_Re_Scheduled__c,
                                    School_Tour_Scheduled__c
                                    FROM Enquiry__c WHERE Id = :enquiryId LIMIT 1];
        
        // Create a map to return multiple fields
        Map<String, object> enquiryInfo = new Map<String, object>();
        enquiryInfo.put('EnquiryName', enquiryRecord.Name);
        enquiryInfo.put('EnquiryContact', enquiryRecord.Contact__c);
        enquiryInfo.put('SchoolTourScheduled', enquiryRecord.School_Tour_Scheduled__c);
        enquiryInfo.put('SchoolTourre_Scheduled', enquiryRecord.School_Tour_Re_Scheduled__c);
        enquiryInfo.put('SchoolName', enquiryRecord.School_Institution__r != null ? enquiryRecord.School_Institution__r.Name : null);
        enquiryInfo.put('Schoolid', enquiryRecord.School_Institution__c);
        enquiryInfo.put('SchoolShortCode', enquiryRecord.orgCode__c);
        
        
        return enquiryInfo;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<String> getSubjectPicklistValues() {
        List<String> picklistValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Event.Subject.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry entry : picklistEntries) {
            if (entry.isActive()) {
                picklistValues.add(entry.getLabel());
            }
        }
        System.debug('picklistValues'+picklistValues);
        return picklistValues;
    }
    @AuraEnabled(cacheable=true)
    public static List<User> getLeadUser(String schoolShortCode) {
        System.debug('schoolShortCode: ' + schoolShortCode);
        
        // Query the LeadUser__c records filtered by the provided schoolShortCode
        List<LeadUser__c> leadUsers = [SELECT Name FROM LeadUser__c WHERE SchoolCode__c = :schoolShortCode];
        Set<String> leadUserNames = new Set<String>();
        for (LeadUser__c lead : leadUsers) {
            leadUserNames.add(lead.Name);
            System.debug('leadUserNames'+leadUserNames);
        }
        System.debug('leadUsers: ' + leadUsers);
        return [SELECT Id, Name FROM User WHERE Name IN :leadUserNames];
    }
    @AuraEnabled
    public static String createEvent(String subject, DateTime startDateTime, DateTime endDateTime, String description, Id ownerId , ID enqId,ID school,Boolean School_Tour_Scheduled) {
        //list<User> userlist = [select id,name from user where name]
        try {
            Event newEvent = new Event(
                Subject = subject,
                StartDateTime = startDateTime,
                EndDateTime = endDateTime,
                Description = description,
                OwnerId = ownerId,
                WhatId = enqId,
                School_Institution__c = school
                
                
            );
            insert newEvent;
            
            Enquiry__c con = new Enquiry__c();
            system.debug('con.School_Tour_Scheduled__c>>> '+con.School_Tour_Scheduled__c );
            system.debug('CampusvisitScheduled>>> '+School_Tour_Scheduled );
            if(!School_Tour_Scheduled){
                system.debug('Inside if>>>> ' );
                con.id = enqId;
                con.School_Tour_Scheduled__c = true;
                con.Meet_at_School_Scheduled_On__c = newEvent.StartDateTime;
                con.Meet_at_School_Scheduled_For__c = newEvent.StartDateTime;
                con.Meeting_End_DateTime__c = newEvent.EndDateTime;
                //                con.CV_Scheduled_Date_Time__c = newEvent.StartDateTime;
                system.debug('ev ' + newEvent);
                con.Log_Status__c = 'Capmus Visit Scheduled';
                //                con.Campus_Visit_Scheduled__c = true;
                //                con.CV_Scheduled_On__c = system.now();
                String s = newEvent.StartDateTime.format('hh:mm a');
                //                con.CV_scheduled_Assign_To__c = newEvent.OwnerId;
                //                con.CV_Scheduled_Time__c = newEvent.StartDateTime.format('hh:mm a');
                //                con.CV_Scheduled_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                update con;
                
                
                
                /* lead l = new lead();
l.id = con.Lead__c;
l.Stage__c = 'CV Rescheduled';
update l;*/
                
            }        
            
            else{
                system.debug('Inside else>>>> ' );
                con.id = enqId;
                con.Log_Status__c = 'Re-Scheduled Campus visit';
                con.Meet_at_School_Re_Scheduled_On__c = system.now();
                //                con.Meet_at_School_Re_Schedule_Date__c = newEvent.StartDateTime;
                //                con.CV_Rescheduled__c = true;
                //               con.Re_Scheduled_Campus_Visit__c = true;
                String s = newEvent.StartDateTime.format('hh:mm a');
                con.Meet_at_School_Re_Schedule_Time__c = s;
                con.Meet_at_School_Re_Schedule_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                con.Meet_at_School_Re_Schedule_Assign_To__c = newEvent.OwnerId;
                update con;
                
                /* lead l = new lead();
l.id = con.Lead__c;
l.Stage__c = 'CV Rescheduled';
update l;*/
            }
            return 'Event created successfully!';
        } catch (Exception e) {
            
            throw new AuraHandledException('Error creating event: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String re_schedulecreateEvent(String subject, DateTime startDateTime, DateTime endDateTime, String description, Id ownerId ,
                                                ID enqId,ID school,Boolean School_Tour_Scheduled,Boolean School_Tour_re_Scheduled) {
        //list<User> userlist = [select id,name from user where name]
        try {
            Event newEvent = new Event(
                Subject = subject,
                StartDateTime = startDateTime,
                EndDateTime = endDateTime,
                Description = description,
                OwnerId = ownerId,
                WhatId = enqId,
                School_Institution__c = school
                

            );
            insert newEvent;
            
            Enquiry__c con = new Enquiry__c();
             system.debug('School_Tour_re_Scheduled>>> '+School_Tour_re_Scheduled );
             system.debug('School_Tour_Scheduled>>>  '+School_Tour_Scheduled );
            if(School_Tour_Scheduled && !School_Tour_re_Scheduled){
                system.debug('Inside if>>>> ' );
                con.id = enqId;
                con.School_Tour_Re_Scheduled__c = true;
                con.Meet_at_School_Re_Scheduled_On__c = newEvent.StartDateTime;
                con.Meet_at_School_Re_Scheduled_For__c = newEvent.StartDateTime;
                con.Meeting_End_DateTime__c = newEvent.EndDateTime;
//                con.CV_Scheduled_Date_Time__c = newEvent.StartDateTime;
                system.debug('ev ' + newEvent);
                con.Log_Status__c = 'Capmus Visit Scheduled';
//                con.Campus_Visit_Scheduled__c = true;
//                con.CV_Scheduled_On__c = system.now();
                String s = newEvent.StartDateTime.format('hh:mm a');
//                con.CV_scheduled_Assign_To__c = newEvent.OwnerId;
//                con.CV_Scheduled_Time__c = newEvent.StartDateTime.format('hh:mm a');
//                con.CV_Scheduled_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                update con;
                
                
                
               /* lead l = new lead();
                l.id = con.Lead__c;
                l.Stage__c = 'CV Rescheduled';
                update l;*/
                
            }        
            
            else{
                  system.debug('Inside else>>>> ' );
                con.id = enqId;
                con.Log_Status__c = 'Re-Scheduled Campus visit';
                con.Meet_at_School_Re_Scheduled_On__c = system.now();
//                con.Meet_at_School_Re_Schedule_Date__c = newEvent.StartDateTime;
//                con.CV_Rescheduled__c = true;
 //               con.Re_Scheduled_Campus_Visit__c = true;
                String s = newEvent.StartDateTime.format('hh:mm a');
                con.Meet_at_School_Re_Schedule_Time__c = s;
                con.Meet_at_School_Re_Schedule_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                con.Meet_at_School_Re_Schedule_Assign_To__c = newEvent.OwnerId;
                update con;
                
               /* lead l = new lead();
                l.id = con.Lead__c;
                l.Stage__c = 'CV Rescheduled';
                update l;*/
            }
            return 'Event created successfully!';
        } catch (Exception e) {
            
            throw new AuraHandledException('Error creating event: ' + e.getMessage());
        }
    }


}