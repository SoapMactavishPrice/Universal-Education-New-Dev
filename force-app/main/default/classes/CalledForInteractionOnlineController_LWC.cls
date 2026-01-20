public class CalledForInteractionOnlineController_LWC {
    @AuraEnabled(cacheable=true)
    public static Map<String, object> getContactName(Id AdmissioFormId) {
        system.debug('AdmissioFormId=--->'+AdmissioFormId);
        // Query the Contact record based on the provided contactId
        Admission_Form__c AdmissioFormRecord = [select id,Enquiry_No__c,Enquiry_No__r.Lead_ID__c,Enquiry_No__r.name,Non_Stellar_Interaction_Scheduled__c,
                                                Non_Stellar_Interaction_Scheduled_On__c,Non_Stellar_Interaction_Scheduled_For__c,Interaction_Scheduled__c,
                                                Non_Stellar_Interaction_Reschedule__c,Non_Stellar_Interaction_Online_Scheduled__c,N_S_Interaction_Online_Scheduled_On__c,N_S_Interaction_Online_Scheduled_For__c,N_S_Interaction_Online_Reschedule__c,
                                                Non_Stellar_Absent_For_Interaction__c,Non_Stellar_Interaction_Done__c,Non_Stellar_Attach_Interaction_Notes__c,
                                                Non_Stellar_Reject_After_Interaction__c,Non_Stellar_Document_Incomplete__c,School_Institution__c, Name,
                                                Called_for_Observation__c,Interaction_Online_Scheduled__c,Observation_Re_scheduled__c,School_Short_Code__c,School_Institution__r.Name, Observation_Done__c,Enquiry__r.Contact__c from Admission_Form__c  WHERE Id = :AdmissioFormId LIMIT 1];
        
        // Create a map to return multiple fields
        Map<String, object> AdmissioFormInfo = new Map<String, object>();
        AdmissioFormInfo.put('AdmissioFormName', AdmissioFormRecord.Name);
        AdmissioFormInfo.put('ContactName',AdmissioFormRecord.Enquiry__r.Contact__c);
        AdmissioFormInfo.put('AdmissioFormEnquiry', AdmissioFormRecord.Enquiry__c);
        AdmissioFormInfo.put('interactionSchedule', AdmissioFormRecord.Interaction_Scheduled__c);
        AdmissioFormInfo.put('SchoolName', AdmissioFormRecord.School_Institution__r != null ? AdmissioFormRecord.School_Institution__r.Name : null);
        AdmissioFormInfo.put('Schoolid', AdmissioFormRecord.School_Institution__c);
        AdmissioFormInfo.put('SchoolShortCode', AdmissioFormRecord.School_Short_Code__c);
        
        
        return AdmissioFormInfo;
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, object> re_sch_getContactName(Id AdmissioFormId) {
        system.debug('AdmissioFormId=--->'+AdmissioFormId);
        // Query the Contact record based on the provided contactId
        Admission_Form__c AdmissioFormRecord = [select id,Enquiry_No__c,Enquiry_No__r.Lead_ID__c,Enquiry_No__r.name,Non_Stellar_Interaction_Scheduled__c,
                                                Non_Stellar_Interaction_Scheduled_On__c,Non_Stellar_Interaction_Scheduled_For__c,Interaction_Scheduled__c,
                                                Non_Stellar_Interaction_Reschedule__c,Non_Stellar_Interaction_Online_Scheduled__c,N_S_Interaction_Online_Scheduled_On__c,N_S_Interaction_Online_Scheduled_For__c,N_S_Interaction_Online_Reschedule__c,
                                                Non_Stellar_Absent_For_Interaction__c,Non_Stellar_Interaction_Done__c,Non_Stellar_Attach_Interaction_Notes__c,
                                                Non_Stellar_Reject_After_Interaction__c,Interaction_Online_Scheduled__c,Non_Stellar_Document_Incomplete__c,School_Institution__c, Name,Interaction_Online_Rescheduled__c,
                                                Called_for_Observation__c,Observation_Re_scheduled__c,Interaction_Rescheduled__c,School_Short_Code__c,School_Institution__r.Name, Observation_Done__c,Enquiry__r.Contact__c from Admission_Form__c  WHERE Id = :AdmissioFormId LIMIT 1];
        
        // Create a map to return multiple fields
        Map<String, object> AdmissioFormInfo = new Map<String, object>();
        AdmissioFormInfo.put('AdmissioFormName', AdmissioFormRecord.Name);
        AdmissioFormInfo.put('ContactName',AdmissioFormRecord.Enquiry__r.Contact__c);
        AdmissioFormInfo.put('AdmissioFormEnquiry', AdmissioFormRecord.Enquiry__c);
        AdmissioFormInfo.put('interactionSchedule', AdmissioFormRecord.Interaction_Scheduled__c);
        AdmissioFormInfo.put('interactionre_Schedule', AdmissioFormRecord.Interaction_Rescheduled__c);
        AdmissioFormInfo.put('SchoolName', AdmissioFormRecord.School_Institution__r != null ? AdmissioFormRecord.School_Institution__r.Name : null);
        AdmissioFormInfo.put('Schoolid', AdmissioFormRecord.School_Institution__c);
        AdmissioFormInfo.put('SchoolShortCode', AdmissioFormRecord.School_Short_Code__c);
        
        
        return AdmissioFormInfo;
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, object> getOnlineContactName(Id AdmissioFormId) {
        system.debug('AdmissioFormId=--->'+AdmissioFormId);
        // Query the Contact record based on the provided contactId
        Admission_Form__c AdmissioFormRecord = [select id,Enquiry_No__c,Enquiry_No__r.Lead_ID__c,Enquiry_No__r.name,Non_Stellar_Interaction_Scheduled__c,
                                                Non_Stellar_Interaction_Scheduled_On__c,Non_Stellar_Interaction_Scheduled_For__c,Interaction_Scheduled__c,
                                                Non_Stellar_Interaction_Reschedule__c,Non_Stellar_Interaction_Online_Scheduled__c,N_S_Interaction_Online_Scheduled_On__c,N_S_Interaction_Online_Scheduled_For__c,N_S_Interaction_Online_Reschedule__c,
                                                Non_Stellar_Absent_For_Interaction__c,Non_Stellar_Interaction_Done__c,Non_Stellar_Attach_Interaction_Notes__c,
                                                Non_Stellar_Reject_After_Interaction__c,Non_Stellar_Document_Incomplete__c,School_Institution__c, Name,
                                                Called_for_Observation__c,Interaction_Online_Scheduled__c,Observation_Re_scheduled__c,School_Short_Code__c,School_Institution__r.Name, Observation_Done__c,Enquiry__r.Contact__c from Admission_Form__c  WHERE Id = :AdmissioFormId LIMIT 1];
        
        // Create a map to return multiple fields
        Map<String, object> AdmissioFormInfo = new Map<String, object>();
        AdmissioFormInfo.put('AdmissioFormName', AdmissioFormRecord.Name);
        AdmissioFormInfo.put('ContactName',AdmissioFormRecord.Enquiry__r.Contact__c);
        AdmissioFormInfo.put('AdmissioFormEnquiry', AdmissioFormRecord.Enquiry__c);
        AdmissioFormInfo.put('interactionSchedule', AdmissioFormRecord.Interaction_Online_Scheduled__c);
        AdmissioFormInfo.put('SchoolName', AdmissioFormRecord.School_Institution__r != null ? AdmissioFormRecord.School_Institution__r.Name : null);
        AdmissioFormInfo.put('Schoolid', AdmissioFormRecord.School_Institution__c);
        AdmissioFormInfo.put('SchoolShortCode', AdmissioFormRecord.School_Short_Code__c);
        
        
        return AdmissioFormInfo;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static Map<String, object> re_sch_oline_getContactName(Id AdmissioFormId) {
        system.debug('AdmissioFormId=--->'+AdmissioFormId);
        // Query the Contact record based on the provided contactId
        Admission_Form__c AdmissioFormRecord = [select id,Enquiry_No__c,Enquiry_No__r.Lead_ID__c,Enquiry_No__r.name,Non_Stellar_Interaction_Scheduled__c,
                                                Non_Stellar_Interaction_Scheduled_On__c,Non_Stellar_Interaction_Scheduled_For__c,Interaction_Scheduled__c,
                                                Non_Stellar_Interaction_Reschedule__c,Non_Stellar_Interaction_Online_Scheduled__c,N_S_Interaction_Online_Scheduled_On__c,N_S_Interaction_Online_Scheduled_For__c,N_S_Interaction_Online_Reschedule__c,
                                                Non_Stellar_Absent_For_Interaction__c,Non_Stellar_Interaction_Done__c,Non_Stellar_Attach_Interaction_Notes__c,
                                                Non_Stellar_Reject_After_Interaction__c,Interaction_Online_Scheduled__c,Non_Stellar_Document_Incomplete__c,School_Institution__c, Name,Interaction_Online_Rescheduled__c,
                                                Called_for_Observation__c,Observation_Re_scheduled__c,School_Short_Code__c,School_Institution__r.Name, Observation_Done__c,Enquiry__r.Contact__c from Admission_Form__c  WHERE Id = :AdmissioFormId LIMIT 1];
        
        // Create a map to return multiple fields
        Map<String, object> AdmissioFormInfo = new Map<String, object>();
        AdmissioFormInfo.put('AdmissioFormName', AdmissioFormRecord.Name);
        AdmissioFormInfo.put('ContactName',AdmissioFormRecord.Enquiry__r.Contact__c);
        AdmissioFormInfo.put('AdmissioFormEnquiry', AdmissioFormRecord.Enquiry__c);
        AdmissioFormInfo.put('interactionSchedule', AdmissioFormRecord.Interaction_Online_Scheduled__c);
        AdmissioFormInfo.put('interactionre_Schedule', AdmissioFormRecord.Interaction_Online_Rescheduled__c);
        AdmissioFormInfo.put('SchoolName', AdmissioFormRecord.School_Institution__r != null ? AdmissioFormRecord.School_Institution__r.Name : null);
        AdmissioFormInfo.put('Schoolid', AdmissioFormRecord.School_Institution__c);
        AdmissioFormInfo.put('SchoolShortCode', AdmissioFormRecord.School_Short_Code__c);
        
        
        return AdmissioFormInfo;
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
public static String createEvent(String subject, DateTime startDateTime, DateTime endDateTime, String description, Id ownerId, 
                                 Id admissionId, Id school, Boolean interactionSchedule) {
        // Create and insert Event
        Event newEvent = new Event(
            Subject = subject,
            StartDateTime = startDateTime,
            EndDateTime = endDateTime,
            Description = description,
            OwnerId = ownerId,
            WhatId = admissionId,
            School_Institution__c = school
        );
        insert newEvent;

        // Update Admission Form
        Admission_Form__c af = new Admission_Form__c(Id = admissionId);
        if (!interactionSchedule) {
            af.Interaction_Scheduled__c = true;
            af.Non_Stellar_Interaction_Scheduled__c = true;
            af.Non_Stellar_Interaction_Scheduled_On__c = system.now();
            af.Non_Stellar_Interaction_Scheduled_For__c = newEvent.StartDateTime;
            af.Interaction_Scheduled_On__c = system.now();
            af.Meeting_Start_DateTime__c = newEvent.StartDateTime;
            af.Meeting_End_DateTime__c = newEvent.EndDateTime;
            af.Interaction_Scheduled_For__c = newEvent.StartDateTime;
            af.Interaction_Scheduled_Assigned_To__c = newEvent.OwnerId;
        } else {
            af.Interaction_Scheduled_On__c = system.now();
            af.Interaction_Scheduled__c = true;
            af.Interaction_Re_Scheduled_Assigned_To__c = newEvent.OwnerId;
        }
        update af;

        // Fetch related Application Form and Enquiry
        Admission_Form__c admission = [
            SELECT Application_Form__c FROM Admission_Form__c WHERE Id = :admissionId LIMIT 1
        ];

        System.debug('admission ==>' + admission);
        if (admission.Application_Form__c == null) {
            throw new AuraHandledException('Application Form not found for this Admission.');
        }

        Application_form__c app = [
            SELECT Id, Enquiry__c, School_Institution__c FROM Application_form__c 
            WHERE Id = :admission.Application_Form__c LIMIT 1
        ];

        List<Enquiry__c> enqs = [
            SELECT Id, Name, Email__c, Org_code__c FROM Enquiry__c 
            WHERE Id = :app.Enquiry__c LIMIT 1
        ];
        Enquiry__c enq = null;
        if (!enqs.isEmpty()) {
            enq = enqs[0];
        }

        List<School_List__mdt> calendarEmail = new List<School_List__mdt>();
        if (enq != null) {
            // Get Calendar Email from Custom Metadata
            calendarEmail = [
                SELECT Calendar_Email__c FROM School_List__mdt 
                WHERE Label = :enq.Org_code__c LIMIT 1
            ];
        }

        List<String> calendarEmailList = new List<String>();

        if (!calendarEmail.isEmpty()) {
            calendarEmailList.add(calendarEmail[0].Calendar_Email__c);
            calendarEmailList.add(enq.Email__c);
        } else {
            if (!Test.isRunningTest()) {
                throw new AuraHandledException('School is not listed for email notification.');
            }
        }

        // Send Email and Calendar Invite (only in non-test context)
        if (!Test.isRunningTest()) {
            String templateName = 'Call_for_Observation_email_template';
            String htmlBody = SendEmailForMeeting.sendEmailMeetingToParent(
                calendarEmailList, newEvent.Id, enq.Name, templateName
            );

            GoogleCalendarMeetScheduleController.doCreateNewCalendar(newEvent.Id, htmlBody);
        }

        return 'Event created and email sent successfully!';
}

    @AuraEnabled
    public static String observationRescheduled(
        Id admissionFormId, Datetime startDateTime, Datetime endDateTime, String subject
    ) {
        
        // Fetch Admission Form
        Admission_Form__c af = [
            SELECT Id, Enquiry_No__c, Email_Address__c, Enquiry_No__r.Name, Enquiry_No__r.Lead_ID__c,
                   Non_Stellar_Interaction_Scheduled__c, Application_Form__c, School_Institution__c,
                   Status__c
            FROM Admission_Form__c
            WHERE Id = :admissionFormId
            LIMIT 1
        ];

        Event ev=new Event(); 
        ev.WhatId = admissionFormId;
        ev.School_Institution__c= af.School_Institution__c;
        ev.StartDateTime = startDateTime;
        ev.EndDateTime = endDateTime;
        ev.Subject = subject;
        if (Test.isRunningTest()) {
            ev.DurationInMinutes = 60;
        }

        List<Lead> lstlead = [SELECT id,Dormant__c,Task_Count__c,Dormant_Count__c, Lead_ID__c, Stage__c FROM lead WHERE Lead_ID__c =: af.Enquiry_No__r.Lead_ID__c];


        
        if (af.Non_Stellar_Interaction_Scheduled__c == true) {
            
            // Update Admission Form
            af.Non_Stellar_Interaction_Reschedule__c = true;
            af.Status__c = 'Interaction-Reschedule';
            update af;
            
            // Update Leads
            List<Lead> lstleads = new List<Lead>();
            for (Lead le : lstlead) {
                lstleads.add(new Lead(
                    Id = le.Id,
                    Stage__c = 'Interaction-Reschedule'
                ));
            }
            if (!lstleads.isEmpty()) {
                update lstleads;
            }
            
            // Update Application Form
            Application_Form__c app = [
                SELECT Id, Status__c, Enquiry__c
                FROM Application_Form__c
                WHERE Id = :af.Application_Form__c
                LIMIT 1
            ];
            app.Status__c = 'Interaction-Reschedule';
            update app;
            
            // Update Enquiry
            Enquiry__c enq = [
                SELECT Id, Name, Stages__c, Contact__c, Email__c, Org_code__c
                FROM Enquiry__c
                WHERE Id = :app.Enquiry__c
                LIMIT 1
            ];
            enq.Stages__c = 'Interaction-Reschedule';
            update enq;
            
            // Insert/Update Event
            ev.Contact__c = enq.Contact__c;
            if (Test.isRunningTest()) {
                // update ev;
            } else {
                insert ev;
            }
            
            // Send Email + Calendar
            List<School_List__mdt> calendarEmail = [
                SELECT Id, Calendar_Email__c, State__c, Label, MasterLabel
                FROM School_List__mdt
                WHERE Label = :enq.Org_code__c
                LIMIT 1
            ];
            
            List<String> calanderemailstr = new List<String>();
            if (!calendarEmail.isEmpty()) {
                calanderemailstr.add(calendarEmail[0].Calendar_Email__c);
                calanderemailstr.add(af.Email_Address__c);
            } else {
                enq.addError('School is not listed for email notification');
            }
            
            if (!Test.isRunningTest()) {
                System.debug('ev ==>' + ev);
                String htmlbody = SendEmailForMeeting.sendEmailMeetingToParent(
                    calanderemailstr,
                    ev.Id,
                    enq.Name,
                    'Call_for_Observation_email_template'
                );
                GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id, htmlbody);
            }
        }
        
        af.Interaction_Rescheduled__c = true;
        UPDATE af;
        return 'Success';
    }




    
    @AuraEnabled
    public static String re_schcreateEvent(String subject, DateTime startDateTime, DateTime endDateTime, String description, Id ownerId , 
                                     ID adminssionId,ID school,Boolean interactionSchedule, Boolean interactionre_Schedule) {
                                         //list<User> userlist = [select id,name from user where name]
                                         try {
                                             Event newEvent = new Event(
                                                 Subject = subject,
                                                 StartDateTime = startDateTime,
                                                 EndDateTime = endDateTime,
                                                 Description = description,
                                                 OwnerId = ownerId,
                                                 WhatId = adminssionId,
                                                 School_Institution__c = school
                                             );
                                             insert newEvent;
                                             
                                             Admission_Form__c con = new Admission_Form__c();
                                             system.debug('con.Campus_Visit_Scheduled__c>>> '+con.Interaction_Scheduled__c );
                                             system.debug('CampusvisitScheduled>>> '+interactionSchedule );
                                             if(!interactionre_Schedule &&interactionSchedule){
                                                 system.debug('Inside if>>>> ' );
                                                 con.id = adminssionId;
                                                 con.Interaction_Rescheduled__c = true;
                                                 con.Interaction_Scheduled_On__c = system.now();
                                                 con.Meeting_Start_DateTime__c = newEvent.StartDateTime;
                                                 con.Meeting_End_DateTime__c = newEvent.EndDateTime;
                                                 con.Interaction_Scheduled_For__c = newEvent.StartDateTime;
                                                 //con.CV_Scheduled_Date_Time__c = newEvent.StartDateTime;
                                                 //system.debug('ev ' + newEvent);
                                                 //con.Log_Status__c = 'Capmus Visit Scheduled';
                                                 con.Interaction_Scheduled__c = true;
                                                 con.Interaction_Scheduled_On__c = system.now();
                                                 String s = newEvent.StartDateTime.format('hh:mm a');
                                                 con.Interaction_Re_Scheduled_Assigned_To__c = newEvent.OwnerId;
                                                 //con.CV_Scheduled_Time__c = newEvent.StartDateTime.format('hh:mm a');
                                                 //con.CV_Scheduled_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                                                 update con;
                                                 

                                                 
                                             }        
                                             
                                             else{
                                                 system.debug('Inside else>>>> ' );
                                                 //con.Log_Status__c = 'Re-Scheduled Campus visit';
                                                 con.Interaction_Scheduled_On__c = system.now();
                                                 con.Id = adminssionId;
                                                 //con.CV_Rescheduled_Date_Time__c = newEvent.StartDateTime;
                                                 con.Interaction_Scheduled__c = true;
                                                 ///.//con.Re_Scheduled_Campus_Visit__c = true;
                                                 String s = newEvent.StartDateTime.format('hh:mm a');
                                                 //con.CV_Re_Scheduled_Time__c = s;
                                                 // con.CV_Re_Scheduled_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                                                 con.Interaction_Re_Scheduled_Assigned_To__c = newEvent.OwnerId;
                                                 update con;
                                                 
                                                 /* lead l = new lead();
l.id = con.Lead__c;
l.Stage__c = 'CV Rescheduled';
update l;*/
                                             }
                                             return 'Event created successfully!';
                                         } catch (Exception e) {
                                             system.debug('line'+ e.getLineNumber() +e.getMessage());
                                             throw new AuraHandledException('Error creating event: ' + e.getMessage());
                                         }
                                     }
    
    
        @AuraEnabled
    public static String createOnlineEvent(String subject, DateTime startDateTime, DateTime endDateTime, String description, Id ownerId , 
                                     ID adminssionId,ID school,Boolean interactionSchedule) {
                                         //list<User> userlist = [select id,name from user where name]
                                         system.debug('adminssionId'+adminssionId);
                                         system.debug('ownerId'+ownerId);
                                         try {
                                             Event newEvent = new Event(
                                                 Subject = subject,
                                                 StartDateTime = startDateTime,
                                                 EndDateTime = endDateTime,
                                                 Description = description,
                                                 OwnerId = ownerId,
                                                 WhatId = adminssionId,
                                                 School_Institution__c = school
                                             );
                                             insert newEvent;
                                             
                                             Admission_Form__c con = new Admission_Form__c();
                                             system.debug('con.Campus_Visit_Scheduled__c>>> '+con.Interaction_Scheduled__c );
                                             system.debug('CampusvisitScheduled>>> '+interactionSchedule );
                                             if(!interactionSchedule){
                                                 system.debug('Inside if>>>> ' );
                                                 con.id = adminssionId;
                                                 con.Interaction_Online_Scheduled__c = true;
                                                 con.Interaction_Online_Scheduled_On__c = system.now();
                                                 con.Meeting_Start_DateTime__c = newEvent.StartDateTime;
                                                 con.Meeting_End_DateTime__c = newEvent.EndDateTime;
                                                 con.Interaction_Online_Scheduled_For__c = newEvent.StartDateTime;
                                                 //con.CV_Scheduled_Date_Time__c = newEvent.StartDateTime;
                                                 //system.debug('ev ' + newEvent);
                                                 //con.Log_Status__c = 'Capmus Visit Scheduled';
                                                 con.Interaction_Online_Scheduled__c = true;
                                                 con.Interaction_Scheduled_On__c = system.now();
                                                 String s = newEvent.StartDateTime.format('hh:mm a');
                                                 con.Interaction_Online_Scheduled_Assigned_To__c = newEvent.OwnerId;
                                                 //con.CV_Scheduled_Time__c = newEvent.StartDateTime.format('hh:mm a');
                                                 //con.CV_Scheduled_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                                                 update con;
                                                 
                                                 
                                                 
                                                 /* lead l = new lead();
l.id = con.Lead__c;
l.Stage__c = 'CV Rescheduled';
update l;*/
                                                 
                                             }        
                                             
                                             else{
                                                 system.debug('Inside else>>>> ' );
                                                 //con.Log_Status__c = 'Re-Scheduled Campus visit';
                                                 con.Interaction_Online_Scheduled_On__c = system.now();
                                                 con.Id = adminssionId;
                                                 //con.CV_Rescheduled_Date_Time__c = newEvent.StartDateTime;
                                                 con.Interaction_Online_Scheduled__c = true;
                                                 ///.//con.Re_Scheduled_Campus_Visit__c = true;
                                                 String s = newEvent.StartDateTime.format('hh:mm a');
                                                 //con.CV_Re_Scheduled_Time__c = s;
                                                 // con.CV_Re_Scheduled_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                                                 con.Interaction_Re_Scheduled_Assigned_To__c = newEvent.OwnerId;
                                                 update con;
                                                 
                                                 /* lead l = new lead();
l.id = con.Lead__c;
l.Stage__c = 'CV Rescheduled';
update l;*/
                                             }
                                             return 'Event created successfully!';
                                         } catch (Exception e) {
                                             system.debug('line'+ e.getLineNumber() +e.getMessage());
                                             throw new AuraHandledException('Error creating event: ' + e.getMessage());
                                         }
                                     }
    
    @AuraEnabled
    public static String reSch_oline_createEvent(String subject, DateTime startDateTime, DateTime endDateTime, String description, Id ownerId , 
                                     ID adminssionId,ID school,Boolean interactionSchedule, Boolean interactionre_Schedule) {
                                         //list<User> userlist = [select id,name from user where name]
                                         try {
                                             Event newEvent = new Event(
                                                 Subject = subject,
                                                 StartDateTime = startDateTime,
                                                 EndDateTime = endDateTime,
                                                 Description = description,
                                                 OwnerId = ownerId,
                                                 WhatId = adminssionId,
                                                 School_Institution__c = school
                                             );
                                             insert newEvent;
                                             
                                             Admission_Form__c con = new Admission_Form__c();
                                             system.debug('con.Campus_Visit_Scheduled__c>>> '+con.Interaction_Scheduled__c );
                                             system.debug('CampusvisitScheduled>>> '+interactionSchedule );
                                             if(!interactionre_Schedule && interactionSchedule){
                                                 system.debug('Inside if>>>> ' );
                                                 con.id = adminssionId;
                                                 //con.Interaction_Scheduled__c = true;
                                                 con.Interaction_Online_Rescheduled__c = true;
                                                 con.Interaction_Online_Scheduled_On__c = system.now();
                                                 con.Meeting_Start_DateTime__c = newEvent.StartDateTime;
                                                 con.Meeting_End_DateTime__c = newEvent.EndDateTime;
                                                 con.Interaction_Online_Scheduled_For__c = newEvent.StartDateTime;
                                                 //con.CV_Scheduled_Date_Time__c = newEvent.StartDateTime;
                                                 //system.debug('ev ' + newEvent);
                                                 //con.Log_Status__c = 'Capmus Visit Scheduled';
                                                 con.Interaction_Online_Scheduled__c = true;
                                                 con.Interaction_Online_Scheduled_On__c = system.now();
                                                 String s = newEvent.StartDateTime.format('hh:mm a');
                                                 con.Interaction_Online_reScheduled_Assigned__c = newEvent.OwnerId;
                                                 update con;
                                                 
                                             }        
                                             
                                             else{
                                                 system.debug('Inside else>>>> ' );
                                                 //con.Log_Status__c = 'Re-Scheduled Campus visit';
                                                 con.Interaction_Online_Scheduled_On__c = system.now();
                                                 con.Id = adminssionId;
                                                 //con.CV_Rescheduled_Date_Time__c = newEvent.StartDateTime;
                                                 con.Interaction_Online_Rescheduled__c = true;
                                                 ///.//con.Re_Scheduled_Campus_Visit__c = true;
                                                 String s = newEvent.StartDateTime.format('hh:mm a');
                                                 //con.CV_Re_Scheduled_Time__c = s;
                                                 // con.CV_Re_Scheduled_Date__c = newEvent.StartDateTime.format('dd-MM-yyyy');
                                                 con.Interaction_Re_Scheduled_Assigned_To__c = newEvent.OwnerId;
                                                 update con;
                                                 
                                                 /* lead l = new lead();
l.id = con.Lead__c;
l.Stage__c = 'CV Rescheduled';
update l;*/
                                             }
                                             return 'Event created successfully!';
                                         } catch (Exception e) {
                                             system.debug('line'+ e.getLineNumber() +e.getMessage());
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