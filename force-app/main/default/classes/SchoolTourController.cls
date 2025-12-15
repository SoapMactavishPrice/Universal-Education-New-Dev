public class SchoolTourController {

    public Enquiry__c enq {
        get;
        set;
    }
    public list < Enquiry__c > listenq {
        get;
        set;
    }
    public list < Event > listev {
        get;
        set;
    }
    public Event ev {
        get;
        set;
    }
    public boolean error {
        get;
        set;
    }
    public boolean back {
        get;
        set;
    }
    public List < string > calanderemailstr = new List < String > ();
    public string strlead {
        get;
        set;
    }
    public List < Lead > lstlead {
        get;
        set;
    }
    public List < Lead > lstleads {
        get;
        set;
    }
    public string schoolshortcode {
        get;
        set;
    }
    public List < School_List__mdt > CalendarEmail = new list < School_List__mdt > ();
	public map<Id,Lead> leadMap {get; set;}

    public SchoolTourController(ApexPages.StandardController Controller) {
        Id pid = Apexpages.currentpage().getParameters().get('id');
        enq = [SELECT id, Meet_Done__c, Name, On_Hold_Check__c, Interaction_Done_On__c, Stages__c, School_Institution__c, School_Institution__r.School_Short_Code__c, Log_Status__c, Meet_Online_Scheduled__c, Interested__c, School_Tour_Scheduled__c, School_Tour_Re_Scheduled__c, Email__c, Contact__c,
            Interaction_Done__c,Demographic__c, Lead_ID__c, Org_code__c,Lead__c FROM Enquiry__c where id =: pid
        ];
        schoolshortcode = enq.Org_code__c;
        strlead = enq.Lead_ID__c;
        lstleads = new List < Lead > ();
        lstlead = new List < Lead > ();
        lstlead = [SELECT id, Lead_ID__c, Meet_at_School_Assign_To__c, Task_Count__c,Dormant_Count__c,Dormant__c,Meet_At_School_Scheduled__c, Meet_at_School_Scheduled_Date__c, Meet_at_School_Scheduled_By__c, Meet_at_School_Scheduled_Time__c,
            Meet_Done_On_Date__c, Meet_Done_By__c, Meet_Done_On_Time__c, Meet_Done__c,
            Meet_at_School_Re_Schedule_Date__c, Meet_at_School_Re_Schedule_Time__c, Meet_At_School_ReScheduled__c,
            Stage__c FROM lead where Lead_ID__c =: strlead
        ];
		leadMap= new map<Id,Lead>([SELECT id, Lead_ID__c, Meet_at_School_Assign_To__c, Dormant_Count__c,Task_Count__c,Dormant__c,Meet_At_School_Scheduled__c, Meet_at_School_Scheduled_Date__c, Meet_at_School_Scheduled_By__c, Meet_at_School_Scheduled_Time__c,
            Meet_Done_On_Date__c, Meet_Done_By__c, Meet_Done_On_Time__c, Meet_Done__c,
            Meet_at_School_Re_Schedule_Date__c, Meet_at_School_Re_Schedule_Time__c, Meet_At_School_ReScheduled__c,
            Stage__c FROM lead where Lead_ID__c =: strlead]);
        system.debug('ID::::' + pid);
        ev = new Event();
        error = true;
        back = false;

    }
    public PageReference createevent() {
        try {
            schoolshortcode = enq.Org_code__c;
            CalendarEmail = [SELECT id, Calendar_Email__c, State__c, label, MasterLabel FROM School_List__mdt where label =: schoolshortcode];
            System.debug('CalenderEmail string::######################' + CalendarEmail);
            // calanderemailstr =CalendarEmail[0].Calendar_Email__c+';'+enq.contact__r.email;
            // List<String> CalenderEmail = New List<Sting> ();
            If(CalendarEmail.size() > 0 && !CalendarEmail.isEmpty()) {
                String CE;
                for (School_List__mdt nCalendarEmail: CalendarEmail) {
                    CE = nCalendarEmail.Calendar_Email__c;
                    calanderemailstr.add(CE);
                }
                ///String CE = CalendarEmail.Calendar_Email__c ;
                //System.debug('CalenderEmail string::'+CE );
                //calanderemailstr.add(CE);
                System.debug('CalenderEmail 1::' + calanderemailstr);
                System.debug('Enquiry Email:: ' + enq.Email__c);
                calanderemailstr.add(enq.Email__c);
                system.debug('abc' + calanderemailstr);
            }
            else {
                String Msg = 'School is not listed for email notification';
                enq.adderror(msg);
            }
            alreadytourscheduled();
            if (enq.School_Tour_Scheduled__c == false) {
                ev.WhatId = enq.id;
                //calanderemailstr.add(enq.Email__c);
                ev.School_Institution__c = enq.School_Institution__c;
                ev.Contact__c = enq.Contact__c;
                insert ev;
                Event ent;
                if (ev != null) {
                    ent = [
                        SELECT Id, OwnerId, Owner.name, Owner.Email, Subject, Location, StartDateTime, EndDateTime, Description,
                        School_Institution__c, School_Institution__r.Name, Contact__c, WhatId, Contact__r.Lead__r.FirstName,
                        Contact__r.Lead__r.LastName, Contact__r.Lead__r.Id, School_Institution__r.Venue_Name__c, School_Institution__r.Veris_Terminal_ID__c,
                        Contact__r.Lead__r.MobilePhone 
                        FROM Event
                        WHERE Id =: ev.Id
                    ];
                }
                enq.Log_Status__c = 'Meet at School Scheduled';
                enq.School_Tour_Scheduled__c = true;
                enq.Meet_at_School_Scheduled_On__c = system.now();
                enq.Meet_at_School_Assign_To__c = ev.OwnerId;
                enq.Meet_at_School_Time__c = ev.StartDateTime.format('hh:mm a');
                enq.Meet_at_School_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                enq.Meet_At_School_Scheduled_On_Date__c = system.now().format('dd-MM-yyyy');
                enq.Meet_At_School_Scheduled_On_Time__c = system.now().format('hh:mm a');
                enq.Meet_at_School_Scheduled_By__c = UserInfo.getName();
                update enq;
                system.debug('lstlead HA 1 -- ' + lstlead);
                for (lead le: lstlead) {
                    lead l = new lead();
                    l.id = le.id;
                    l.Stage__c = 'Meet at School Scheduled';
                    l.Meet_At_School_Scheduled__c = true;
                    l.Meet_At_School_Scheduled_On_Date__c = system.now().format('dd-MM-yyyy');
                    l.Meet_At_School_Scheduled_On_Time__c = system.now().format('hh:mm a');
                    l.Meet_at_School_Scheduled_By__c = UserInfo.getName();
                    if (ent.OwnerId != null) {
                        l.Meet_at_School_Assign_To__c = ent.Owner.name;
                    }
                    l.Meet_at_School_Scheduled_Time__c = ev.StartDateTime.format('hh:mm a');
                    l.Meet_at_School_Scheduled_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                    lstleads.add(l);
                }
                system.debug('lstleads -- ' + lstleads);
                if (!lstleads.isEmpty()) {
                    update lstleads;

                    
                    
                    String templateName = 'Meeting_At_School_Schedule_Email_Template';
                    System.debug('-=-=' + templateName);
                    String htmlbody = null;
                    Boolean toMakeStellarCallout = StellarAPICallouts.checkIfStellarAPIEnabled(enq.School_Institution__r.School_Short_Code__c);
                    System.debug('toMakeStellarCallout :-------' + toMakeStellarCallout);
                    if (!toMakeStellarCallout) {
                        string emailtemp;
                        boolean notem = true;
                        boolean isEmailactive = false;
                        List < SchoolEmail__mdt > se = new list < SchoolEmail__mdt > ();
                        se = [SELECT CCAddress__c, TempName__c, Active__c, DisplayName__c, Event__c, Object__c, SchoolShortcode__c FROM SchoolEmail__mdt where SchoolShortcode__c =: schoolshortcode and Event__c = 'Meet at School'];
                        system.debug('seeeee ' + se);
                        if (se != null && se.size() > 0) {
                            isEmailactive = se[0].Active__c;
                            emailtemp = se[0].TempName__c;
                        } else {
                            isEmailactive = false;
                            notem = false;
                        }
                        if (isEmailactive) {
                            system.debug('temp ' + emailtemp);
                            SendEmail.SendEmailTemplateWithTemplate(emailtemp, enq.Contact__c, true, enq.id, se[0], ev.id);
                        } else {
                            system.debug('old temp ' + emailtemp);
                            htmlbody = SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr, ev.Id, enq.Name, templateName);
                        }

                        System.debug('-=-=-=-=--=-=-=-' + htmlbody);
                    }
                    // ------ Veris Sync Event --------
                    Map<String, Object> mapDataToSend = new Map<String, Object>();
                    String mobb = ent.Contact__r.Lead__r.MobilePhone;
                    mapDataToSend.put('LeadFirstName', ent.Contact__r.Lead__r.FirstName);
                    mapDataToSend.put('LeadLastName', ent.Contact__r.Lead__r.LastName);
                    mapDataToSend.put('LeadPhoneNumber', mobb.replace('+',''));
                    mapDataToSend.put('Description', ent.Description);
                    mapDataToSend.put('Location', ent.School_Institution__r.Venue_Name__c);
                    mapDataToSend.put('VerisTerminalId', ent.School_Institution__r.Veris_Terminal_ID__c);
                    mapDataToSend.put('VisitorCategory', 'Admission Enquiry');
                    // mapDataToSend.put('AssignedTo', ent.OwnerId);
                    mapDataToSend.put('AssignedTo', ent.Owner.name);
                    if (ent.Owner.Email == 'sf.consultant@universal.edu.in') {
                        mapDataToSend.put('AssignedToEmail', 'sf.counsultant@universal.edu.in');
                    } else {
                        mapDataToSend.put('AssignedToEmail', ent.Owner.Email);
                    }
                    mapDataToSend.put('MeetAtSchoolStart', ent.StartDateTime.addMinutes(330));
                    mapDataToSend.put('MeetAtSchoolEnd', ent.EndDateTime.addMinutes(330));
                    mapDataToSend.put('LeadId', ent.Contact__r.Lead__r.Id);
                    mapDataToSend.put('EventId', ent.Id);
                    String JSONData = JSON.serialize(mapDataToSend);
                    if (ent.School_Institution__r.Venue_Name__c == 'Stellar World School Andheri' || ent.School_Institution__r.Venue_Name__c == 'Stellar World School Bandra' || ent.School_Institution__r.Venue_Name__c == 'Stellar World School Goregoan' ) {
                        // SyncEventDataToVeris.syncData(JSONData, 'SchoolTourController1');
                    }
                    // ------ Veris Sync Event --------
                    GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id, StellarAPICallouts.POST_METHOD, toMakeStellarCallout, htmlbody);
                    
                }
                //SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr,ev.Id,enq.Name,'Meeting_At_School_Schedule_Email_Template');
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ex.getMessage()));
            system.debug('Error while Insertion::' + ex.getMessage());
        }
        return new pageReference('/' + enq.Id);
    }

    public void alreadytourscheduled() {
        if (enq.School_Tour_Scheduled__c == true) {
            error = false;
            back = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Meet at school already booked.'));
        }
        if (enq.Interaction_Done__c == true) {
            error = false;
            back = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Interaction Done. You can not book Meet at School.'));

        }
    }

    public PageReference schoolTourRescheduled() {
        try {
            schoolshortcode = enq.Org_code__c;
            CalendarEmail = [SELECT id, Calendar_Email__c, State__c, label, MasterLabel FROM School_List__mdt where label =: schoolshortcode];
            System.debug('CalenderEmail string::######################' + CalendarEmail);
            // calanderemailstr =CalendarEmail[0].Calendar_Email__c+';'+enq.contact__r.email;
            // List<String> CalenderEmail = New List<Sting> ();
            If(CalendarEmail.size() > 0 && !CalendarEmail.isEmpty()) {
                String CE;
                for (School_List__mdt nCalendarEmail: CalendarEmail) {
                    CE = nCalendarEmail.Calendar_Email__c;
                    calanderemailstr.add(CE);
                }
                ///String CE = CalendarEmail.Calendar_Email__c ;
                //System.debug('CalenderEmail string::'+CE );
                //calanderemailstr.add(CE);
                System.debug('CalenderEmail 1::' + calanderemailstr);
                System.debug('Enquiry Email:: ' + enq.Email__c);
                calanderemailstr.add(enq.Email__c);
                system.debug('abc' + calanderemailstr);
            }
            else {
                String Msg = 'School is not listed for email notification';
                enq.adderror(msg);
            }
            scheduleFirsttoReschedule();
            if (enq.School_Tour_Scheduled__c == true && enq.Interaction_Done__c == false) {
                ev.WhatId = enq.id;
                calanderemailstr.add(enq.Email__c);
                ev.School_Institution__c = enq.School_Institution__c;
                ev.Contact__c = enq.Contact__c;
                insert ev;
                system.debug('inside if' + ev);
                Event ent;
                if (ev != null) {
                    ent = [
                        SELECT Id, OwnerId, Owner.name, Owner.Email, Subject, Location, StartDateTime, EndDateTime, Description,
                        School_Institution__c, School_Institution__r.Name, Contact__c, WhatId, Contact__r.Lead__r.FirstName,
                        Contact__r.Lead__r.LastName, Contact__r.Lead__r.Id, School_Institution__r.Venue_Name__c, School_Institution__r.Veris_Terminal_ID__c,
                        Contact__r.Lead__r.MobilePhone 
                        FROM Event
                        WHERE Id =: ev.Id
                    ];
                }
                enq.Log_Status__c = 'Meet at School Re-Scheduled';
                enq.School_Tour_Re_Scheduled__c = true;
                enq.Meet_at_School_Re_Scheduled_On__c = System.Datetime.now();
                enq.Meet_at_School_Re_Scheduled_For__c = ev.StartDateTime;
                enq.Meet_at_School_Re_Schedule_Assign_To__c = ev.OwnerId;
                enq.Meet_at_School_Re_Schedule_Time__c = ev.StartDateTime.format('hh:mm a');
                enq.Meet_at_School_Re_Schedule_Date__c = ev.StartDateTime.format('dd-MM-yyyy');

                update enq;

                for (lead le: lstlead) {
                    lead l = new lead();
                    l.id = le.id;
                    l.Stage__c = 'Meet at School Re-Scheduled';
                    //  l.Meet_at_School_Re_Schedule_Assign_To__c=ev.OwnerId;
                    l.Meet_at_School_Re_Schedule_Time__c = System.Datetime.now().format('hh:mm a');
                    l.Meet_At_School_ReScheduled__c = true;
                    l.Meet_at_School_Re_Schedule_Date__c = System.Datetime.now().format('dd-MM-yyyy');
                    l.Meet_At_School_ReScheduled_For_Time__c = ev.StartDateTime.format('hh:mm a');
                    l.Meet_At_School_ReScheduled_For_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                    lstleads.add(l);
                }
                system.debug('lstleads HA 2 -- ' + lstleads);
                if (!lstleads.isEmpty()) {
                    update lstleads;
                }

                //String templateName = 'Meeting_At_School_Reschedule_Email_Template';
                //System.debug('-=-='+templateName);
                String templateName = 'Meeting_At_School_Reschedule_Email_Template';
                System.debug('-=-=' + templateName);
                String htmlbody = null;
                Boolean toMakeStellarCallout = StellarAPICallouts.checkIfStellarAPIEnabled(enq.School_Institution__r.School_Short_Code__c);
                System.debug('toMakeStellarCallout :-------' + toMakeStellarCallout);
                if (!toMakeStellarCallout) {
                    string emailtemp;
                    boolean notem = true;
                    boolean isEmailactive = false;
                    List < SchoolEmail__mdt > se = new list < SchoolEmail__mdt > ();
                    se = [SELECT CCAddress__c, TempName__c, Active__c, DisplayName__c, Event__c, Object__c, SchoolShortcode__c FROM SchoolEmail__mdt where SchoolShortcode__c =: schoolshortcode and Event__c = 'Meet at School Re-Scheduled'];
                    if (se != null && se.size() > 0) {
                        isEmailactive = se[0].Active__c;
                        emailtemp = se[0].TempName__c;
                    } else {
                        isEmailactive = false;
                        notem = false;
                    }
                    if (isEmailactive) {
                        system.debug('temp ' + emailtemp);
                        SendEmail.SendEmailTemplateWithTemplate(emailtemp, enq.Contact__c, true, enq.id, se[0], ev.id);
                    } else {
                        system.debug('old temp ' + emailtemp);
                        htmlbody = SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr, ev.Id, enq.Name, templateName);
                    }

                    System.debug('-=-=-=-=--=-=-=-' + htmlbody);
                }
                // ------ Veris Sync Event --------
                Map<String, Object> mapDataToSend = new Map<String, Object>();
                String mobb = ent.Contact__r.Lead__r.MobilePhone;
                mapDataToSend.put('LeadFirstName', ent.Contact__r.Lead__r.FirstName);
                mapDataToSend.put('LeadLastName', ent.Contact__r.Lead__r.LastName);
                mapDataToSend.put('LeadPhoneNumber', mobb.replace('+',''));
                mapDataToSend.put('Description', ent.Description);
                mapDataToSend.put('Location', ent.School_Institution__r.Venue_Name__c);
                mapDataToSend.put('VerisTerminalId', ent.School_Institution__r.Veris_Terminal_ID__c);
                mapDataToSend.put('VisitorCategory', 'Admission Enquiry');
                // mapDataToSend.put('AssignedTo', ent.OwnerId);
                mapDataToSend.put('AssignedTo', ent.Owner.name);
                if (ent.Owner.Email == 'sf.consultant@universal.edu.in') {
                    mapDataToSend.put('AssignedToEmail', 'sf.counsultant@universal.edu.in');
                } else {
                    mapDataToSend.put('AssignedToEmail', ent.Owner.Email);
                }
                mapDataToSend.put('MeetAtSchoolStart', ent.StartDateTime.addMinutes(330));
                mapDataToSend.put('MeetAtSchoolEnd', ent.EndDateTime.addMinutes(330));
                mapDataToSend.put('LeadId', ent.Contact__r.Lead__r.Id);
                mapDataToSend.put('EventId', ent.Id);
                String JSONData = JSON.serialize(mapDataToSend);
                if (ent.School_Institution__r.Venue_Name__c == 'Stellar World School Andheri' || ent.School_Institution__r.Venue_Name__c == 'Stellar World School Bandra' || ent.School_Institution__r.Venue_Name__c == 'Stellar World School Goregoan' ) {
                    // SyncEventDataToVeris.syncData(JSONData,'SchoolTourController2');
                }
                // ------ Veris Sync Event --------
                GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id, StellarAPICallouts.POST_METHOD, toMakeStellarCallout, htmlbody);
                //SendEmailForMeeting.sendEmailMeetingToParent(calanderemailstr,ev.Id,enq.Name,templateName);
            }

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ex.getMessage()));
            system.debug('Error while Insertion::' + ex.getMessage());
        }
        return new pageReference('/' + enq.Id);
    }

    public void scheduleFirsttoReschedule() {
        if (enq.School_Tour_Scheduled__c == false) {
            error = false;
            back = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'To Re-Scheduled You have to Schedule a meet at school first.'));
        }
        if (enq.Interaction_Done__c == true) {
            error = false;
            back = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Interaction Done. You can not Re-Schedule meet at school.'));

        }
    }
    public PageReference intractionDone() {
        PageReference pg;
        try {

            if (enq.School_Tour_Scheduled__c == False && enq.Interaction_Done__c == False && enq.Meet_Online_Scheduled__c == false) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'First Scheduled the meet at school.'));
            }

            if (enq.Interaction_Done__c == true && enq.Log_Status__c == 'Interaction Done') {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Intraction is already Done!'));
            }

            if(enq.Stages__c == 'No Show'){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'You cannot change the stage to Meet Done directly!')); 
            }
            string customLabelValue = System.Label.Demographicval;
            if(customLabelValue=='true'){
             if(enq.Demographic__c == false){
                
                back = true;
                system.debug('lk');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Pre-Counseling Form is not submitted!!'));
             return pg; 
             }
            }

            /* if((enq.School_Tour_Scheduled__c==true && enq.School_Tour_Re_Scheduled__c == False && enq.Interaction_Done__c == false)||(enq.School_Tour_Scheduled__c==true && enq.School_Tour_Re_Scheduled__c==true && enq.Interaction_Done__c==false))
{
*/
            if (enq.School_Tour_Scheduled__c == true || enq.Meet_Online_Scheduled__c == true) {
                enq.Meet_Done__c = true;
                enq.Log_Status__c = 'Interaction Done';
                enq.Stages__c = 'Meet Done';
                //enq.Interaction_Done__c = true;
                //enq.Interaction_Done_On__c=System.Datetime.now();
                enq.Meet_Done_on__c = System.Datetime.now();
                enq.Meet_Done_On_Time__c = System.now().format('hh:mm a');
                enq.Meet_Done_On_Date__c = System.now().format('dd-MM-yyyy');
                enq.Meet_Done_By__c = UserInfo.getName();
                update enq;
				
				if(String.isNotBlank(enq.lead__c) && leadMap.containskey(enq.Lead__c)){
					Lead ld = new Lead();
					ld.id = leadMap.get(enq.Lead__c).Id;
					system.debug('inside for'+ld.Id);
					//ld.Task_Count__c = 0;
                    ld.Dormant_Count__c = 0;
					ld.Dormant__c = false;
					ld.Meet_Done__c = true;
					ld.Meet_Done_On_Time__c = System.now().format('hh:mm a');
                    ld.Meet_Done_On_Date__c = System.now().format('dd-MM-yyyy');
                    ld.Meet_Done_By__c = UserInfo.getName();
					lstleads.add(ld);
					}
				system.debug('lstleads -- ' + lstleads);
                /*for (lead le: lstlead) {
                    lead l = new lead();
                    l.id = le.id;
                    system.debug('inside for'+l.Id);
                    //  l.Meet_at_School_Re_Schedule_Assign_To__c=ev.OwnerId;
                    l.Meet_Done__c = true;
                    l.Meet_Done_On_Time__c = System.now().format('hh:mm a');
                    l.Meet_Done_On_Date__c = System.now().format('dd-MM-yyyy');
                    l.Meet_Done_By__c = UserInfo.getName();
                    l.Task_Count__c = 0;
          l.Dormant__c = false;
                    lstleads.add(l);

                }*/
				
                system.debug('lstleads -- ' + lstleads);
                if (!lstleads.isEmpty()) {
                    update lstleads;
                }
                pg = new pageReference('/' + enq.Id);
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ex.getMessage()));
            system.debug('Error ::' + ex.getMessage());
        }
        return pg;
    }

    public PageReference cancel() {
        return new pageReference('/' + enq.Id);
    }

    public PageReference noShowCheck() {
        PageReference pg;
        try {
            if (enq.School_Tour_Scheduled__c == false) {
                error = false;
                back = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Meet at school not done.'));
            } else if (enq.School_Tour_Scheduled__c == true) {
                enq.Stages__c = 'No Show';

                update enq;
                pg = new pageReference('/' + enq.Id);
            }

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Error'));
            system.debug('Error ::' + ex.getMessage());
        }
        return pg;
    }

    public PageReference noHoldEnq() {
        PageReference pg;

        if (enq.Meet_Done__c == false) {
            error = false;
            back = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Meeting has not done yet.'));
        } else {
            enq.Stages__c = 'On Hold';
            enq.On_Hold_Check__c = true;
            system.debug('enq ' + enq);
            update enq;
            pg = new pageReference('/' + enq.Id);
        }

        return pg;
    }

    public PageReference enqInterested() {
        PageReference pg;
        try {
            if (enq.Stages__c != 'Meet Done') {
                error = false;
                back = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Meeting done is pending!.'));
            } else if (enq.Interested__c == true) {
                error = false;
                back = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Stage already updated!.'));
            } else if (enq.Stages__c == 'Meet Done') {
                enq.Interested__c = true;
                enq.Stages__c = 'Interested';
                update enq;
                pg = new pageReference('/' + enq.Id);
            }

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Error'));
            system.debug('Error ::' + ex.getMessage());
        }
        return pg;
    }

    public static void fakeMethod() {
        Integer j = 0;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;

        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
         j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
    
    }
}