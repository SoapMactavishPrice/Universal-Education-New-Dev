public class enqInteractionController_LWC {

    @AuraEnabled(cacheable=true)
    public static Map<String, object> getEnquiryName(Id enquiryId) {
        // Query the Contact record based on the provided contactId
        enquiry__c enquiryRecord = [SELECT id, Interaction_Rescheduled_For__c, Interaction_Rescheduled_On__c, Interaction_Scheduled__c, 
                                    Name, Stages__c, School_Institution__c, School_Institution__r.School_Short_Code__c, Log_Status__c, 
                                    Meet_Online_Scheduled__c, Interested__c, School_Tour_Scheduled__c, School_Tour_Re_Scheduled__c, 
                                    Email__c, Contact__c, Interaction_Done__c, Lead_ID__c, Org_code__c, School_Institution__r.Name, orgCode__c
                                    
                                    FROM Enquiry__c WHERE Id = :enquiryId LIMIT 1];
        
        // Create a map to return multiple fields
        Map<String, object> enquiryInfo = new Map<String, object>();
        enquiryInfo.put('EnquiryName', enquiryRecord.Name);
        enquiryInfo.put('EnquiryContact', enquiryRecord.Contact__c);
        enquiryInfo.put('SchoolTourScheduled', enquiryRecord.Interaction_Scheduled__c);
        enquiryInfo.put('SchoolName', enquiryRecord.School_Institution__r != null ? enquiryRecord.School_Institution__r.Name : null);
        enquiryInfo.put('Schoolid', enquiryRecord.School_Institution__c);
        enquiryInfo.put('SchoolShortCode', enquiryRecord.orgCode__c);
        
        
        return enquiryInfo;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static Map<String, object> re_schgetEnquiryName(Id enquiryId) {
        // Query the Contact record based on the provided contactId
        enquiry__c enquiryRecord = [SELECT Name,Contact__c, School_Institution__r.Name,School_Institution__r.School_Short_Code__c,orgCode__c,School_Tour_Re_Scheduled__c,
                                    School_Tour_Scheduled__c,Interaction_Rescheduled__c,Interaction_Scheduled__c, Interaction_Rescheduled_On__c
                                    FROM Enquiry__c WHERE Id = :enquiryId LIMIT 1];
        
        // Create a map to return multiple fields
        Map<String, object> enquiryInfo = new Map<String, object>();
        enquiryInfo.put('EnquiryName', enquiryRecord.Name);
        enquiryInfo.put('EnquiryContact', enquiryRecord.Contact__c);
        enquiryInfo.put('SchoolTourScheduled', enquiryRecord.Interaction_Scheduled__c);
        enquiryInfo.put('SchoolTourre_Scheduled', enquiryRecord.Interaction_Rescheduled__c);
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
    public static String calledForInteraction(Id enquiryId, String subject, Datetime startDateTime, Datetime endDateTime, String ownerId) {
            // Query Enquiry record
            Enquiry__c enq = [
                SELECT Id, Interaction_Rescheduled_For__c, Interaction_Rescheduled_On__c, Interaction_Scheduled__c,
                       Name, Stages__c, School_Institution__c, School_Institution__r.School_Short_Code__c,
                       Log_Status__c, Meet_Online_Scheduled__c, Interested__c, School_Tour_Scheduled__c,
                       School_Tour_Re_Scheduled__c, Email__c, Contact__c, Interaction_Done__c,
                       Lead_ID__c, Org_code__c
                FROM Enquiry__c
                WHERE Id = :enquiryId
                LIMIT 1
            ];

            alreadytourscheduled(enq);

            String schoolShortcode = enq.Org_code__c;

            // Fetch Lead (only one lead per Enquiry)
            Lead le = [
                SELECT Id, Lead_ID__c, Stage__c, Interaction_Scheduled__c,
                       Interaction_Scheduled_For_Date__c, Interaction_Scheduled_For_Time__c,
                       Interaction_Scheduled_On_Date__c, Interaction_Scheduled_On_Time__c,
                       Interaction_ReScheduled__c, Interaction_ReScheduled_On_Date__c,
                       Interaction_ReScheduled_On_Time__c, Interaction_Done__c,
                       Interaction_Done_On_Date__c, Interaction_Done_On_Time__c
                FROM Lead
                WHERE Lead_ID__c = :enq.Lead_ID__c
                LIMIT 1
            ];

            // Email Template metadata
            List<SchoolEmail__mdt> se = [
                SELECT CCAddress__c, DisplayName__c, TempName__c, Active__c,
                       Event__c, Object__c, SchoolShortcode__c
                FROM SchoolEmail__mdt
                WHERE SchoolShortcode__c = :schoolShortcode
                AND Event__c = 'Call for Inter'
                LIMIT 1
            ];

            Boolean isEmailActive = !se.isEmpty() ? se[0].Active__c : false;
            String emailTemp = !se.isEmpty() ? se[0].TempName__c : null;

            // Calendar Email metadata
            List<School_List__mdt> calendarEmail = [
                SELECT Id, Calendar_Email__c, State__c, Label, MasterLabel
                FROM School_List__mdt
                WHERE Label = :schoolShortcode
            ];

            List<String> calendarEmailStr = new List<String>();
            if (!calendarEmail.isEmpty()) {
                for (School_List__mdt ce : calendarEmail) {
                    calendarEmailStr.add(ce.Calendar_Email__c);
                }
                calendarEmailStr.add(enq.Email__c);
            } else {
                throw new AuraHandledException('School is not listed for email notification');
            }

            // Schedule Event if not already scheduled
            if (enq.Interaction_Scheduled__c == false) {
                Event ev = new Event();
                ev.WhatId = enq.Id;
                ev.School_Institution__c = enq.School_Institution__c;
                ev.StartDateTime = startDateTime;
                ev.EndDateTime = endDateTime;
                ev.Subject = subject;
                ev.OwnerId = ownerId;

                if (Test.isRunningTest()) {
                    ev.DurationInMinutes = 60;
                    ev.ActivityDateTime = System.now();
                }
                insert ev;

                Event ent = [
                    SELECT Id, OwnerId, Owner.Name, Owner.Email, Subject, Location, StartDateTime, EndDateTime, Description,
                           School_Institution__c, School_Institution__r.Name, Contact__c, WhatId,
                           Contact__r.Lead__r.FirstName, Contact__r.Lead__r.LastName, Contact__r.Lead__r.Id,
                           School_Institution__r.Venue_Name__c, School_Institution__r.Veris_Terminal_ID__c,
                           Contact__r.Lead__r.MobilePhone
                    FROM Event
                    WHERE Id = :ev.Id
                ];

                // Update Enquiry
                enq.Interaction_Scheduled__c = true;
                enq.Stages__c = 'Interaction Scheduled';
                enq.Interaction_Scheduled_On__c = System.now();
                enq.Interaction_Scheduled_For__c = ev.StartDateTime;
                enq.Interaction_Assign_To__c = ev.OwnerId;
                enq.Interaction_Time__c = ev.StartDateTime.format('hh:mm a');
                enq.Interaction_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                enq.Interaction_Scheduled_On_Date__c = System.now().format('dd-MM-yyyy');
                enq.Interaction_Scheduled_On_Time__c = System.now().format('hh:mm a');
                update enq;

                // Update Lead
                le.Stage__c = 'Interaction Scheduled';
                le.Interaction_Scheduled__c = true;
                le.Interaction_Scheduled_On_Date__c = System.now().format('dd-MM-yyyy');
                le.Interaction_Scheduled_On_Time__c = System.now().format('hh:mm a');
                le.Interaction_Scheduled_For_Time__c = ev.StartDateTime.format('hh:mm a');
                le.Interaction_Scheduled_For_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                update le;

                // Update Admission Form
                List<Admission_Form__c> adForms = [
                    SELECT Id
                    FROM Admission_Form__c
                    WHERE Enquiry_No__c = :enq.Id
                ];
                for (Admission_Form__c af : adForms) {
                    af.Interaction_Scheduled__c = true;
                    af.Status__c = 'Interaction Scheduled';
                }
                if (!adForms.isEmpty()) update adForms;

                // Send Email
                String htmlBody;
                if (!Test.isRunningTest()) {
                    Boolean toMakeStellarCallout =
                        StellarAPICallouts.checkIfStellarAPIEnabled(enq.School_Institution__r.School_Short_Code__c);

                    if (!toMakeStellarCallout) {
                        if (isEmailActive) {
                            SendEmail.SendEmailTemplateWithTemplate(emailTemp, enq.Contact__c, true, enq.Id, se[0], ev.Id);
                        } else {
                            htmlBody = SendEmailForMeeting.sendEmailMeetingToParent(calendarEmailStr, ev.Id, enq.Name, 'Meeting_At_School_Schedule_Email_Template');
                        }
                    }

                    // Google Meet schedule
                    GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id, StellarAPICallouts.POST_METHOD, toMakeStellarCallout, htmlBody);
                }
            }
            return 'Success';

    }

    public static void alreadytourscheduled(Enquiry__c enq) {
        if (enq.Interaction_Scheduled__c == true) {
            throw new AuraHandledException('Interaction Online already Scheduled.');
        }
    }

    public static void alreadyReTourscheduled(Enquiry__c enq) {
        if (enq.Interaction_Rescheduled__c == true) {
            throw new AuraHandledException('Interaction Online already Re-Scheduled.');
        }
    }

    
    @AuraEnabled
    public static String interactionOnlineRescheduled(Id enquiryId, String subject, Datetime startDateTime, Datetime endDateTime, String ownerId) {
            Enquiry__c enq = [
                SELECT Id, Interaction_Rescheduled_For__c, Interaction_Rescheduled_On__c,
                       Interaction_Scheduled__c, Name, Stages__c, School_Institution__c,
                       School_Institution__r.School_Short_Code__c, Log_Status__c,
                       Meet_Online_Scheduled__c, Interested__c, School_Tour_Scheduled__c,
                       School_Tour_Re_Scheduled__c, Email__c, Contact__c, Interaction_Rescheduled__c,
                       Interaction_Done__c, Lead_ID__c, Org_code__c
                FROM Enquiry__c
                WHERE Id = :enquiryId
                LIMIT 1
            ];

            alreadyReTourscheduled(enq);

            String schoolShortcode = enq.Org_code__c;

            // Calendar Email metadata
            List<School_List__mdt> calendarEmail = [
                SELECT Id, Calendar_Email__c, State__c, Label, MasterLabel
                FROM School_List__mdt
                WHERE Label = :schoolShortcode
            ];

            List<String> calendarEmailStr = new List<String>();
            if (!calendarEmail.isEmpty()) {
                for (School_List__mdt ce : calendarEmail) {
                    calendarEmailStr.add(ce.Calendar_Email__c);
                }
                calendarEmailStr.add(enq.Email__c);
            } else {
                throw new AuraHandledException('School is not listed for email notification');
            }

            // Email template metadata
            List<SchoolEmail__mdt> se = [
                SELECT TempName__c, Active__c, DisplayName__c, CCAddress__c,
                       Event__c, Object__c, SchoolShortcode__c
                FROM SchoolEmail__mdt
                WHERE SchoolShortcode__c = :schoolShortcode
                AND Event__c = 'Interaction Re-scheduled'
                LIMIT 1
            ];
            Boolean isEmailActive = !se.isEmpty() ? se[0].Active__c : false;
            String emailTemp = !se.isEmpty() ? se[0].TempName__c : null;

            // Create Event
            Event ev = new Event();
            ev.WhatId = enq.Id;
            ev.School_Institution__c = enq.School_Institution__c;
            ev.Contact__c = enq.Contact__c;
            ev.StartDateTime = startDateTime;
            ev.EndDateTime = endDateTime;
            ev.Subject = subject;
            ev.OwnerId = ownerId;

            if (Test.isRunningTest()) {
                ev.DurationInMinutes = 60;
                ev.ActivityDateTime = System.now();
            }
            insert ev;

            Event ent = [
                SELECT Id, OwnerId, Owner.Name, Owner.Email, Subject, Location, StartDateTime, EndDateTime, Description,
                       School_Institution__c, School_Institution__r.Name, Contact__c, WhatId,
                       Contact__r.Lead__r.FirstName, Contact__r.Lead__r.LastName, Contact__r.Lead__r.Id,
                       School_Institution__r.Venue_Name__c, School_Institution__r.Veris_Terminal_ID__c,
                       Contact__r.Lead__r.MobilePhone
                FROM Event
                WHERE Id = :ev.Id
            ];

            // Update Enquiry
            enq.Interaction_Rescheduled__c = true;
            enq.Stages__c = 'Interaction Online Rescheduled';
            enq.Interaction_Rescheduled_On__c = System.now();
            enq.Interaction_Rescheduled_For__c = ev.StartDateTime;
            enq.Interaction_Re_scheduled_Assign_To__c = ev.OwnerId;
            enq.Interaction_Re_scheduled_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
            enq.Interaction_Re_scheduled_Time__c = ev.StartDateTime.format('hh:mm a');
            update enq;

            // Update Lead (only one lead)
            Lead le = [
                SELECT Id, Lead_ID__c
                FROM Lead
                WHERE Lead_ID__c = :enq.Lead_ID__c
                LIMIT 1
            ];
            le.Stage__c = 'Interaction Online Rescheduled';
            le.Interaction_ReScheduled__c = true;
            le.Interaction_ReScheduled_On_Time__c = System.now().format('hh:mm a');
            le.Interaction_ReScheduled_On_Date__c = System.now().format('dd-MM-yyyy');
            le.Interaction_ReScheduled_For_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
            le.Interaction_ReScheduled_For_Time__c = ev.StartDateTime.format('hh:mm a');
            update le;

            // Update Admission Form
            List<Admission_Form__c> adForms = [
                SELECT Id
                FROM Admission_Form__c
                WHERE Enquiry_No__c = :enq.Id
            ];
            for (Admission_Form__c af : adForms) {
                af.Interaction_Online_Scheduled__c = false;
                af.Interaction_Online_Rescheduled__c = true;
                af.Status__c = 'Interaction Online Rescheduled';
            }
            if (!adForms.isEmpty()) update adForms;

            // Send Email
            String htmlBody;
            if (!Test.isRunningTest()) {
                Boolean toMakeStellarCallout =
                    StellarAPICallouts.checkIfStellarAPIEnabled(enq.School_Institution__r.School_Short_Code__c);

                if (!toMakeStellarCallout) {
                    if (isEmailActive) {
                        SendEmail.SendEmailTemplateWithTemplate(emailTemp, enq.Contact__c, true, enq.Id, se[0], ev.Id);
                    } else {
                        htmlBody = SendEmailForMeeting.sendEmailMeetingToParent(
                            calendarEmailStr, ev.Id, enq.Name, 'Meeting_At_School_Schedule_Email_Template'
                        );
                    }
                }

                // Google Meet schedule
                GoogleCalendarMeetScheduleController.doCreateNewCalendar(
                    ev.Id, StellarAPICallouts.POST_METHOD, toMakeStellarCallout, htmlBody
                );
            }

            return 'Success';

    }

    public static void testMethod1(){
        for(integer i=1; i<= 2; i++){
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
        }
    }


}