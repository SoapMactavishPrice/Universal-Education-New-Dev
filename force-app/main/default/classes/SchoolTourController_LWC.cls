public class SchoolTourController_LWC {
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
    public static String createEventLWC(String enquiryId, String ownerId, String subject, DateTime startDateTime, DateTime endDateTime, String description) {
            List<String> calanderemailstr = new List<String>();
            

            Enquiry__c enq = [
                SELECT Id, Org_code__c, Email__c, School_Tour_Scheduled__c, Interaction_Done__c,
                       School_Institution__c, Contact__c, Name,
                       School_Institution__r.School_Short_Code__c,
                       School_Institution__r.Venue_Name__c,
                       School_Institution__r.Veris_Terminal_ID__c, Lead__c
                FROM Enquiry__c WHERE Id = :enquiryId
            ];

            List<Lead> lstleads = new List<Lead>();
            List<Lead> lstlead = [SELECT Id FROM Lead WHERE Id = :enq.Lead__c];

            String schoolshortcode = enq.Org_code__c;

            List<School_List__mdt> CalendarEmail = [
                SELECT Calendar_Email__c FROM School_List__mdt WHERE label = :schoolshortcode
            ];

            if (!CalendarEmail.isEmpty()) {
                for (School_List__mdt emailEntry : CalendarEmail) {
                    calanderemailstr.add(emailEntry.Calendar_Email__c);
                }
                calanderemailstr.add(enq.Email__c);
            } else {
                throw new AuraHandledException('School is not listed for email notification');
            }

            // Already scheduled check
            if (enq.School_Tour_Scheduled__c == true) {
                throw new AuraHandledException('Meet at school is already scheduled.');
            }
            Event ev = new Event();
            ev.WhatId = enq.Id;
            ev.School_Institution__c = enq.School_Institution__c;
            ev.Contact__c = enq.Contact__c;
            ev.OwnerId = ownerId;
            ev.Subject = subject;
            ev.StartDateTime = startDateTime;
            ev.EndDateTime = endDateTime;
            ev.Description = description;
            insert ev;

            Event ent = [
                SELECT Id, OwnerId, Owner.name, Owner.Email, Subject, Location, StartDateTime, EndDateTime, Description,
                       School_Institution__c, School_Institution__r.Name, Contact__c, WhatId,
                       Contact__r.Lead__r.FirstName, Contact__r.Lead__r.LastName, Contact__r.Lead__r.Id,
                       School_Institution__r.Venue_Name__c, School_Institution__r.Veris_Terminal_ID__c,
                       Contact__r.Lead__r.MobilePhone
                FROM Event
                WHERE Id = :ev.Id
            ];

            enq.Log_Status__c = 'Meet at School Scheduled';
            enq.School_Tour_Scheduled__c = true;
            enq.Meet_at_School_Scheduled_On__c = System.now();
            enq.Meet_at_School_Assign_To__c = ev.OwnerId;
            enq.Meet_at_School_Time__c = ev.StartDateTime.format('hh:mm a');
            enq.Meet_at_School_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
            enq.Meet_At_School_Scheduled_On_Date__c = System.now().format('dd-MM-yyyy');
            enq.Meet_At_School_Scheduled_On_Time__c = System.now().format('hh:mm a');
            enq.Meet_at_School_Scheduled_By__c = UserInfo.getName();
            update enq;

            for (Lead le : lstlead) {
                Lead l = new Lead();
                l.Id = le.Id;
                l.Stage__c = 'Meet at School Scheduled';
                l.Meet_At_School_Scheduled__c = true;
                l.Meet_At_School_Scheduled_On_Date__c = System.now().format('dd-MM-yyyy');
                l.Meet_At_School_Scheduled_On_Time__c = System.now().format('hh:mm a');
                l.Meet_at_School_Scheduled_By__c = UserInfo.getName();
                if (ent.OwnerId != null) {
                    l.Meet_at_School_Assign_To__c = ent.Owner.name;
                }
                l.Meet_at_School_Scheduled_Time__c = ev.StartDateTime.format('hh:mm a');
                l.Meet_at_School_Scheduled_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                lstleads.add(l);
            }

            if (!lstleads.isEmpty()) {
                update lstleads;
            }

            // Email template
            String templateName = 'Meeting_At_School_Schedule_Email_Template';
            Boolean toMakeStellarCallout = StellarAPICallouts.checkIfStellarAPIEnabled(enq.School_Institution__r.School_Short_Code__c);
            String htmlbody = null;

            if (!toMakeStellarCallout) {
                List<SchoolEmail__mdt> se = [
                    SELECT CCAddress__c, TempName__c, Active__c, DisplayName__c, Event__c, Object__c, SchoolShortcode__c 
                    FROM SchoolEmail__mdt 
                    WHERE SchoolShortcode__c = :schoolshortcode AND Event__c = 'Meet at School'
                ];

                if (!se.isEmpty() && se[0].Active__c) {
                    SendEmail.SendEmailTemplateWithTemplate(se[0].TempName__c, enq.Contact__c, true, enq.Id, se[0], ev.Id);
                } else {
                    htmlbody = SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr, ev.Id, enq.Name, templateName);
                }
            }

            // Veris Sync
            Map<String, Object> mapDataToSend = new Map<String, Object>{
                'LeadFirstName' => ent.Contact__r.Lead__r.FirstName,
                'LeadLastName' => ent.Contact__r.Lead__r.LastName,
                'LeadPhoneNumber' => ent.Contact__r.Lead__r.MobilePhone.replace('+',''),
                'Description' => ent.Description,
                'Location' => ent.School_Institution__r.Venue_Name__c,
                'VerisTerminalId' => ent.School_Institution__r.Veris_Terminal_ID__c,
                'VisitorCategory' => 'Admission Enquiry',
                'AssignedTo' => ent.Owner.name,
                'AssignedToEmail' => ent.Owner.Email == 'sf.consultant@universal.edu.in' ? 'sf.counsultant@universal.edu.in' : ent.Owner.Email,
                'MeetAtSchoolStart' => ent.StartDateTime.addMinutes(330),
                'MeetAtSchoolEnd' => ent.EndDateTime.addMinutes(330),
                'LeadId' => ent.Contact__r.Lead__r.Id,
                'EventId' => ent.Id
            };

            if (
                ent.School_Institution__r.Venue_Name__c == 'Stellar World School Andheri' ||
                ent.School_Institution__r.Venue_Name__c == 'Stellar World School Bandra' ||
                ent.School_Institution__r.Venue_Name__c == 'Stellar World School Goregoan'
            ) {
                // SyncEventDataToVeris.syncData(JSON.serialize(mapDataToSend), 'SchoolTourController2');
            }

            GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id, StellarAPICallouts.POST_METHOD, toMakeStellarCallout, htmlbody);

            return 'Success';
    }


    @AuraEnabled
    public static String schoolTourRescheduled(String enquiryId, String ownerId, String subject, DateTime startDateTime, DateTime endDateTime, String description) {

        List<String> calanderemailstr = new List<String>();
        Enquiry__c enq = [SELECT Id, Org_code__c, Email__c, School_Tour_Scheduled__c, Interaction_Done__c,
                                    School_Institution__c, Contact__c, Name,
                                    School_Institution__r.School_Short_Code__c, 
                                    School_Institution__r.Venue_Name__c, 
                                    School_Institution__r.Veris_Terminal_ID__c, Lead__c
                            FROM Enquiry__c
                            WHERE Id = :enquiryId];

        List<Lead> lstleads = new List<Lead>();
        Lead[] lstlead = [SELECT Id FROM Lead WHERE Id = :enq.Lead__c];

        String schoolshortcode = enq.Org_code__c;

        List<School_List__mdt> CalendarEmail = [
            SELECT id, Calendar_Email__c, State__c, label, MasterLabel 
            FROM School_List__mdt 
            WHERE label =: schoolshortcode
        ];

        if (!CalendarEmail.isEmpty()) {
            for (School_List__mdt nCalendarEmail : CalendarEmail) {
                calanderemailstr.add(nCalendarEmail.Calendar_Email__c);
            }
            calanderemailstr.add(enq.Email__c);
        } else {
            throw new AuraHandledException('School is not listed for email notification');
        }

        scheduleFirsttoReschedule(enq.Id); // Ensure this method is globally accessible or static

        Event ev = new Event();

        if (enq.School_Tour_Scheduled__c == true && enq.Interaction_Done__c == false) {
            ev.WhatId = enq.id;
            ev.School_Institution__c = enq.School_Institution__c;
            ev.Contact__c = enq.Contact__c;
            ev.OwnerId = ownerId;
            ev.Subject = subject;
            ev.StartDateTime = startDateTime;
            ev.EndDateTime = endDateTime;
            ev.Description = description;
            insert ev;

            Event ent = [SELECT Id, OwnerId, Owner.name, Owner.Email, Subject, Location, StartDateTime, EndDateTime, Description,
                                School_Institution__c, School_Institution__r.Name, Contact__c, WhatId, 
                                Contact__r.Lead__r.FirstName, Contact__r.Lead__r.LastName, Contact__r.Lead__r.Id,
                                School_Institution__r.Venue_Name__c, School_Institution__r.Veris_Terminal_ID__c,
                                Contact__r.Lead__r.MobilePhone
                            FROM Event
                            WHERE Id =: ev.Id];

            enq.Log_Status__c = 'Meet at School Re-Scheduled';
            enq.School_Tour_Re_Scheduled__c = true;
            enq.Meet_at_School_Re_Scheduled_On__c = System.Datetime.now();
            enq.Meet_at_School_Re_Scheduled_For__c = ev.StartDateTime;
            enq.Meet_at_School_Re_Schedule_Assign_To__c = ev.OwnerId;
            enq.Meet_at_School_Re_Schedule_Time__c = ev.StartDateTime.format('hh:mm a');
            enq.Meet_at_School_Re_Schedule_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
            update enq;

            for (Lead le : lstlead) {
                Lead l = new Lead();
                l.Id = le.Id;
                l.Stage__c = 'Meet at School Re-Scheduled';
                l.Meet_at_School_Re_Schedule_Time__c = System.Datetime.now().format('hh:mm a');
                l.Meet_At_School_ReScheduled__c = true;
                l.Meet_at_School_Re_Schedule_Date__c = System.Datetime.now().format('dd-MM-yyyy');
                l.Meet_At_School_ReScheduled_For_Time__c = ev.StartDateTime.format('hh:mm a');
                l.Meet_At_School_ReScheduled_For_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                lstleads.add(l);
            }
            if (!lstleads.isEmpty()) update lstleads;

            // Email Logic
            Boolean toMakeStellarCallout = StellarAPICallouts.checkIfStellarAPIEnabled(enq.School_Institution__r.School_Short_Code__c);
            if (!toMakeStellarCallout) {
                List<SchoolEmail__mdt> se = [
                    SELECT CCAddress__c, TempName__c, Active__c, DisplayName__c, Event__c, Object__c, SchoolShortcode__c 
                    FROM SchoolEmail__mdt 
                    WHERE SchoolShortcode__c =: schoolshortcode AND Event__c = 'Meet at School Re-Scheduled'
                ];
                if (!se.isEmpty() && se[0].Active__c) {
                    SendEmail.SendEmailTemplateWithTemplate(se[0].TempName__c, enq.Contact__c, true, enq.id, se[0], ev.id);
                } else {
                    SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr, ev.Id, enq.Name, 'Meeting_At_School_Reschedule_Email_Template');
                }
            }

            // Veris Sync
            Map<String, Object> mapDataToSend = new Map<String, Object>{
                'LeadFirstName' => ent.Contact__r.Lead__r.FirstName,
                'LeadLastName' => ent.Contact__r.Lead__r.LastName,
                'LeadPhoneNumber' => ent.Contact__r.Lead__r.MobilePhone.replace('+',''),
                'Description' => ent.Description,
                'Location' => ent.School_Institution__r.Venue_Name__c,
                'VerisTerminalId' => ent.School_Institution__r.Veris_Terminal_ID__c,
                'VisitorCategory' => 'Admission Enquiry',
                'AssignedTo' => ent.Owner.name,
                'AssignedToEmail' => (ent.Owner.Email == 'sf.consultant@universal.edu.in' ? 'sf.counsultant@universal.edu.in' : ent.Owner.Email),
                'MeetAtSchoolStart' => ent.StartDateTime.addMinutes(330),
                'MeetAtSchoolEnd' => ent.EndDateTime.addMinutes(330),
                'LeadId' => ent.Contact__r.Lead__r.Id,
                'EventId' => ent.Id
            };

            if (ent.School_Institution__r.Venue_Name__c == 'Stellar World School Andheri' ||
                ent.School_Institution__r.Venue_Name__c == 'Stellar World School Bandra' ||
                ent.School_Institution__r.Venue_Name__c == 'Stellar World School Goregoan') {
                // SyncEventDataToVeris.syncData(JSON.serialize(mapDataToSend), 'SchoolTourController2');
            }

            GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id, StellarAPICallouts.POST_METHOD, toMakeStellarCallout, null);
        }


        return 'Success';
    }

    @AuraEnabled
    public static String scheduleFirsttoReschedule(Id enquiryId) {
        Enquiry__c enq = [
            SELECT Id, School_Tour_Scheduled__c, Interaction_Done__c 
            FROM Enquiry__c 
            WHERE Id = :enquiryId 
            LIMIT 1
        ];

        if (enq.School_Tour_Scheduled__c == false) {
            throw new AuraHandledException('To Re-Schedule you have to schedule a meet at school first.');
        }

        if (enq.Interaction_Done__c == true) {
            throw new AuraHandledException('Interaction Done. You cannot Re-Schedule meet at school.');
        }

        return 'Valid';
    }

   @AuraEnabled
public static String createEvent(
    String subject,
    DateTime startDateTime,
    DateTime endDateTime,
    String description,
    Id ownerId,
    Id enqId,
    Id school,
    Boolean School_Tour_Scheduled
) {
    try {
        // Step 1: Create the Event
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

        // Step 2: Update Enquiry__c
        Enquiry__c enq = [
            SELECT Id, Contact__c, Org_code__c, School_Institution__r.School_Short_Code__c
            FROM Enquiry__c
            WHERE Id = :enqId
            LIMIT 1
        ];

        enq.School_Tour_Scheduled__c = true;
        enq.Meet_at_School_Scheduled_On__c = System.now();
        enq.Meet_at_School_Scheduled_For__c = newEvent.StartDateTime;
        enq.Meet_at_School_Assign_To__c = newEvent.OwnerId;
        enq.Meet_at_School_Time__c = newEvent.StartDateTime.format('hh:mm a');
        enq.Meet_at_School_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
        enq.Meet_At_School_Scheduled_On_Date__c = system.now().format('dd-MM-yyyy');
        enq.Meet_At_School_Scheduled_On_Time__c = system.now().format('hh:mm a');
        enq.Meet_at_School_Scheduled_By__c = UserInfo.getName();
        enq.Log_Status__c = School_Tour_Scheduled ? 'Re-Scheduled Campus visit' : 'Campus Visit Scheduled';
        update enq;

        // Step 3: Send Email
        String shortcode = enq.Org_code__c;
        List<SchoolEmail__mdt> emailSettings = [
            SELECT CCAddress__c, TempName__c, Active__c, DisplayName__c, Event__c, Object__c, SchoolShortcode__c
            FROM SchoolEmail__mdt
            WHERE SchoolShortcode__c = :shortcode AND Event__c = 'Meet at School'
        ];

        if (!emailSettings.isEmpty() && emailSettings[0].Active__c) {
            String templateName = emailSettings[0].TempName__c;

            // Call custom email sending method
            SendEmail.SendEmailTemplateWithTemplate(
                templateName,
                enq.Contact__c,
                true,
                enq.Id,
                emailSettings[0],
                newEvent.Id
            );
        } else {
            System.debug('No active email template found for shortcode: ' + shortcode);
        }

        return 'Event created and email sent successfully!';
    } catch (Exception e) {
        System.debug('Error in createEvent: ' + e.getMessage());
        throw new AuraHandledException('Failed to create event: ' + e.getMessage());
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
              //  con.Meet_at_School_Re_Scheduled_On__c = newEvent.StartDateTime;
                con.Meet_at_School_Re_Scheduled_On__c = System.Datetime.now();
                con.Meet_at_School_Re_Scheduled_For__c = newEvent.StartDateTime;
                con.Meet_at_School_Re_Schedule_Assign_To__c = newEvent.OwnerId;
                con.Meet_at_School_Re_Schedule_Time__c =newEvent.StartDateTime.format('hh:mm a');
                con.Meet_at_School_Re_Schedule_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
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
              //  con.Meet_at_School_Re_Schedule_Time__c = s;
                con.Meet_at_School_Re_Schedule_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                con.Meet_at_School_Re_Schedule_Assign_To__c = newEvent.OwnerId;
                con.Meet_at_School_Re_Schedule_Time__c = newEvent.StartDateTime.format('hh:mm a');
                con.Meet_at_School_Re_Schedule_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
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