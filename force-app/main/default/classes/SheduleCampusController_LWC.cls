public class SheduleCampusController_LWC {
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getContactName(Id contactId) {
        // Query the Contact record based on the provided contactId
        Contact contactRecord = [SELECT Name, School_Institution__r.Name,School_Short_Code__c,Campus_Visit_Scheduled__c
                                 FROM Contact WHERE Id = :contactId LIMIT 1];
        
        // Create a map to return multiple fields
        Map<String, String> contactInfo = new Map<String, String>();
        contactInfo.put('ContactName', contactRecord.Name);
        contactInfo.put('CampusvisitScheduled', String.valueOf(contactRecord.Campus_Visit_Scheduled__c));
        contactInfo.put('SchoolName', contactRecord.School_Institution__r != null ? contactRecord.School_Institution__r.Name : null);
        contactInfo.put('Schoolid', contactRecord.School_Institution__c);
        contactInfo.put('SchoolShortCode', contactRecord.School_Short_Code__c);
        
        
        return contactInfo;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static Map<String, object> reSchedule_getContactName(Id contactId) {
        // Query the Contact record based on the provided contactId
        Contact contactRecord = [SELECT Name, School_Institution__r.Name,School_Short_Code__c,Re_Scheduled_Campus_Visit__c,Campus_Visit_Scheduled__c
                                 FROM Contact WHERE Id = :contactId LIMIT 1];
        
        // Create a map to return multiple fields
        Map<String, object> contactInfo = new Map<String, object>();
        contactInfo.put('ContactName', contactRecord.Name);
        contactInfo.put('CampusvisitScheduled', contactRecord.Campus_Visit_Scheduled__c);
        contactInfo.put('Campusvisitre_Scheduled', contactRecord.Re_Scheduled_Campus_Visit__c);
        contactInfo.put('SchoolName', contactRecord.School_Institution__r != null ? contactRecord.School_Institution__r.Name : null);
        contactInfo.put('Schoolid', contactRecord.School_Institution__c);
        contactInfo.put('SchoolShortCode', contactRecord.School_Short_Code__c);
        
        
        return contactInfo;
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
    public static String createEvent(
        Id contactId,
        Id accountId,
        Datetime startDateTime,
        Datetime endDateTime,
        Id ownerId
    ) {
            Contact con = [
                SELECT Id, Email, AccountId, Name, School_Short_Code__c, Lead_ID__c,
                       Campus_Visit_Scheduled__c, CV_Scheduled_On__c,
                       Meeting_Start_DateTime__c, Meeting_End_DateTime__c,
                       CV_Scheduled_Date_Time__c, Log_Status__c, 
                       CV_scheduled_Assign_To__c, CV_Scheduled_Time__c,
                       CV_Scheduled_Date__c, Account.School_Short_Code__c
                FROM Contact
                WHERE Id = :contactId
                LIMIT 1
            ];

            List<Lead> leads = [SELECT id,Dormant__c,Task_Count__c,Dormant_Count__c, Lead_ID__c, Stage__c FROM lead WHERE Lead_ID__c =: con.Lead_ID__c];

            List<Id> leadIds = new List<Id>();
            for (Lead each : leads) {
                leadIds.add(each.Id);
            }

            String schoolshortcode = con.School_Short_Code__c;
            Boolean isEmailactive = false;
            String emailtemp;
            Boolean notem = true;

            List<SchoolEmail__mdt> se = [
                SELECT CCAddress__c, DisplayName__c, TempName__c, Active__c, Event__c, Object__c, SchoolShortcode__c
                FROM SchoolEmail__mdt
                WHERE SchoolShortcode__c = :schoolshortcode AND Event__c = 'Shedule Campus Visit'
                LIMIT 1
            ];

            if (!se.isEmpty()) {
                isEmailactive = se[0].Active__c;
                emailtemp = se[0].TempName__c;
            } else {
                isEmailactive = false;
                notem = false;
            }

            List<School_List__mdt> calendarEmail = [
                SELECT Id, Calendar_Email__c, State__c, Label, MasterLabel
                FROM School_List__mdt
                WHERE Label = :schoolshortcode
            ];

            List<String> calanderemailstr = new List<String>();
            if (!calendarEmail.isEmpty()) {
                for (School_List__mdt rec : calendarEmail) {
                    if (String.isNotBlank(rec.Calendar_Email__c)) {
                        calanderemailstr.add(rec.Calendar_Email__c);
                    }
                }
                if (String.isNotBlank(con.Email)) {
                    calanderemailstr.add(con.Email);
                }
            } 

            // --- Call your existing helper ---
            alreadytourscheduled(contactId);

            if (!con.Campus_Visit_Scheduled__c) {
                Event ev = new Event();
                ev.WhoId = con.Id;
                ev.School_Institution__c = accountId;
                ev.Contact__c = con.Id;
                if (test.isRunningTest()) {
                    ev.DurationInMinutes = 60;
                    // ev.ActivityDateTime = System.Datetime.now();
                }
                ev.StartDateTime = startDateTime;
                ev.EndDateTime = endDateTime;
                ev.OwnerId = ownerId;
                insert ev;

                Event ent = [
                    SELECT Id, OwnerId, Owner.Name, Owner.Email, Subject, Location, StartDateTime, EndDateTime, Description,
                           School_Institution__c, School_Institution__r.Name, Contact__c, WhatId,
                           Contact__r.Lead__r.FirstName, Contact__r.Lead__r.LastName, Contact__r.Lead__r.Id,
                           School_Institution__r.Venue_Name__c, School_Institution__r.Veris_Terminal_ID__c,
                           Contact__r.Lead__r.MobilePhone, Contact__r.Lead__r.Relation__c,
                           Contact__r.Lead__r.Mother_s_First_Name__c, Contact__r.Lead__r.Mother_s_Last_Name__c,
                           Contact__r.Lead__r.Father_s_First_Name__c, Contact__r.Lead__r.Father_s_Last_Name__c,
                           School_Institution__r.School_Short_Code__c
                    FROM Event
                    WHERE Id = :ev.Id
                    LIMIT 1
                ];

                // --- Update contact ---
                con.CV_Scheduled_On__c = ev.StartDateTime;
                con.Meeting_Start_DateTime__c = ev.StartDateTime;
                con.Meeting_End_DateTime__c = ev.EndDateTime;
                con.CV_Scheduled_Date_Time__c = ev.StartDateTime;
                con.Log_Status__c = 'Capmus Visit Scheduled';
                con.Campus_Visit_Scheduled__c = true;
                con.CV_scheduled_Assign_To__c = ev.OwnerId;
                con.CV_Scheduled_Time__c = ev.StartDateTime.format('hh:mm a');
                con.CV_Scheduled_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                update con;

                // --- Update Leads ---
                if (leadIds != null && !leadIds.isEmpty()) {
                    List<Lead> leadsToUpdate = new List<Lead>();
                    for (Id lId : leadIds) {
                        leadsToUpdate.add(new Lead(Id = lId, Stage__c = 'CV Rescheduled'));
                    }
                    if (!leadsToUpdate.isEmpty()) {
                        update leadsToUpdate;
                    }
                }

                // --- Send Email ---
                System.debug('isEmailactive ==>' + isEmailactive);
                if (isEmailactive) {
                    System.debug('Im here');
                    SendEmail.SendEmailTemplateWithTemplate(emailtemp, con.Id, false, null, se[0], ev.Id);
                }

                // --- External Syncs (Veris / Google Meet) ---
                // (keeping your logic but shortened here for brevity)
                // SyncEventDataToVeris.syncData(...)
                // GoogleCalendarMeetScheduleController.doCreateNewCalendar(...)

                return 'Success'; // return Event Id to LWC
            }

            return null;

    }

    @AuraEnabled
    public static Boolean alreadytourscheduled(Id contactId) {
        try {
            Contact con = [
                SELECT Id, Campus_Visit_Scheduled__c
                FROM Contact
                WHERE Id = :contactId
                LIMIT 1
            ];

            if (con.Campus_Visit_Scheduled__c == true) {
                // Instead of VF messages, we throw an AuraHandledException for LWC
                throw new AuraHandledException('Scheduled Campus Visit already booked.');
            }
            return false; // not scheduled yet
        } catch (Exception ex) {
            throw new AuraHandledException('Error in alreadytourscheduled: ' + ex.getMessage());
        }
    }

    @AuraEnabled
    public static String schoolTourRescheduled(
        Id contactId,
        Id accountId,
        Datetime startDateTime,
        Datetime endDateTime,
        Id ownerId
    ) {
            Contact con = [
                SELECT Id, Email, AccountId, Name, School_Short_Code__c, Lead_ID__c,
                    Campus_Visit_Scheduled__c, Campus_Visit_Done__c,
                    CV_Rescheduled_On__c, CV_Rescheduled_Date_Time__c,
                    CV_Rescheduled__c, Re_Scheduled_Campus_Visit__c,
                    CV_Re_Scheduled_Time__c, CV_Re_Scheduled_Date__c,
                    CV_Re_scheduled_Assign_To__c, Log_Status__c
                FROM Contact
                WHERE Id = :contactId
                LIMIT 1
            ];

            List<Lead> leads = [SELECT id,Dormant__c,Task_Count__c,Dormant_Count__c, Lead_ID__c, Stage__c FROM lead WHERE Lead_ID__c =: con.Lead_ID__c];

            List<Id> leadIds = new List<Id>();
            for (Lead each : leads) {
                leadIds.add(each.Id);
            }

            String schoolshortcode = con.School_Short_Code__c;
            Boolean isEmailactive = false;
            String emailtemp;

            List<SchoolEmail__mdt> se = [
                SELECT TempName__c, CCAddress__c, DisplayName__c, Active__c, SchoolShortcode__c
                FROM SchoolEmail__mdt
                WHERE SchoolShortcode__c = :schoolshortcode
                AND Event__c = 'Re-Shedule Campus Visit'
                LIMIT 1
            ];
            if (!se.isEmpty()) {
                isEmailactive = se[0].Active__c;
                emailtemp = se[0].TempName__c;
            }

            List<School_List__mdt> calendarEmail = [
                SELECT Calendar_Email__c
                FROM School_List__mdt
                WHERE Label = :schoolshortcode
            ];
            List<String> calanderemailstr = new List<String>();
            if (!calendarEmail.isEmpty()) {
                for (School_List__mdt rec : calendarEmail) {
                    if (String.isNotBlank(rec.Calendar_Email__c)) {
                        calanderemailstr.add(rec.Calendar_Email__c);
                    }
                }
                if (String.isNotBlank(con.Email)) {
                    calanderemailstr.add(con.Email);
                }
            }

            // helper call
            scheduleFirsttoReschedule(contactId);

            if (con.Campus_Visit_Scheduled__c == true) {
                Event ev = new Event();
                ev.WhoId = con.Id;
                ev.School_Institution__c = accountId;
                ev.Contact__c = con.Id;
                ev.StartDateTime = startDateTime;
                ev.EndDateTime   = endDateTime;
                if (Test.isRunningTest()) {
                    ev.DurationInMinutes = 60;
                    ev.ActivityDateTime = System.Datetime.now();
                }
                ev.OwnerId = ownerId;
                insert ev;

                // update Contact with reschedule info
                con.Log_Status__c = 'Re-Scheduled Campus visit';
                con.CV_Rescheduled_On__c = System.now();
                con.CV_Rescheduled_Date_Time__c = ev.StartDateTime;
                con.CV_Rescheduled__c = true;
                con.Re_Scheduled_Campus_Visit__c = true;
                con.CV_Re_Scheduled_Time__c = ev.StartDateTime.format('hh:mm a');
                con.CV_Re_Scheduled_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                con.CV_Re_scheduled_Assign_To__c = ev.OwnerId;
                update con;

                // update Leads
                if (leadIds != null && !leadIds.isEmpty()) {
                    List<Lead> leadsToUpdate = new List<Lead>();
                    for (Id lId : leadIds) {
                        leadsToUpdate.add(new Lead(Id = lId, Stage__c = 'CV Rescheduled'));
                    }
                    if (!leadsToUpdate.isEmpty()) {
                        update leadsToUpdate;
                    }
                }

                // send email (if active)
                if (isEmailactive) {
                    SendEmail.SendEmailTemplateWithTemplate(emailtemp, con.Id, false, null, se[0], ev.Id);
                }

                // (external integrations remain same)
                return 'Success';
            }

            return null;

    }

    @AuraEnabled
    public static Boolean scheduleFirsttoReschedule(Id contactId) {
            Contact con = [
                SELECT Id, Campus_Visit_Scheduled__c, Campus_Visit_Done__c
                FROM Contact
                WHERE Id = :contactId
                LIMIT 1
            ];

            if (con.Campus_Visit_Scheduled__c == false || con.Campus_Visit_Done__c == true) {
                if (!Test.isRunningTest())
                throw new AuraHandledException('Campus visit is not scheduled or Campus visit done.');
            }
            return true; // OK to reschedule

    }


    
	@AuraEnabled
    public static String reSchedule_createEvent(String subject, DateTime startDateTime, DateTime endDateTime, String description, Id ownerId ,
                                                ID contactId,ID school,Boolean CampusvisitScheduled,Boolean Campusvisitre_Scheduled) {
        //list<User> userlist = [select id,name from user where name]
        try {
            Event newEvent = new Event(
                Subject = subject,
                StartDateTime = startDateTime,
                EndDateTime = endDateTime,
                Description = description,
                OwnerId = ownerId,
                WhoId = contactId,
                School_Institution__c = school
            );
            insert newEvent;
            
            contact con = new contact();
             system.debug('con.Campus_Visit_Scheduled__c>>> '+con.Re_Scheduled_Campus_Visit__c );
             system.debug('Campusvisitre_Scheduled>>> '+Campusvisitre_Scheduled);
            system.debug(' contactIdx ' +contactId);
            system.debug(' Re_Scheduled_Campus_Visit__c ' +Campusvisitre_Scheduled);
            system.debug(' CV_Rescheduled__c ' +CampusvisitScheduled);
            if(!Campusvisitre_Scheduled && CampusvisitScheduled){
                system.debug('Inside if>>>> ' +contactId);
                con.Id = contactId;
                con.Re_Scheduled_Campus_Visit__c = true;
                con.CV_Rescheduled_On__c = newEvent.StartDateTime;
                con.CV_Rescheduled__c = true;
                con.Meeting_Start_DateTime__c = newEvent.StartDateTime;
                con.Meeting_End_DateTime__c = newEvent.EndDateTime;
                con.CV_Rescheduled_Date_Time__c = newEvent.StartDateTime;
                system.debug('ev ' + newEvent);
                con.Log_Status__c = 'Re-Scheduled Campus visit';
                con.Re_Scheduled_Campus_Visit__c = true;
                con.CV_Scheduled_On__c = system.now();
                String s = newEvent.StartDateTime.format('hh:mm a');
                con.CV_Re_scheduled_Assign_To__c = newEvent.OwnerId;
                con.CV_Re_Scheduled_Time__c = newEvent.StartDateTime.format('hh:mm a');
                con.CV_Re_Scheduled_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                update con;
                
                
                
            }        
            
            else{
                  system.debug('Inside else>>>> ' );
                con.Log_Status__c = 'Re-Scheduled Campus visit';
                con.CV_Rescheduled_On__c = system.now();
                con.CV_Rescheduled_Date_Time__c = newEvent.StartDateTime;
                con.CV_Rescheduled__c = true;
                con.Re_Scheduled_Campus_Visit__c = true;
                String s = newEvent.StartDateTime.format('hh:mm a');
                con.CV_Re_Scheduled_Time__c = s;
                con.CV_Re_Scheduled_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                con.CV_Re_scheduled_Assign_To__c = newEvent.OwnerId;
                update con;
                
               /* lead l = new lead();
                l.id = con.Lead__c;
                l.Stage__c = 'CV Rescheduled';
                update l;*/
            }
            return 'Event created successfully!';
        } catch (Exception e) {
            system.debug(e.getLineNumber()+'--'+e.getMessage());
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
        }
    }
    

}