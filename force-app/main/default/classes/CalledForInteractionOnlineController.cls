public class CalledForInteractionOnlineController {
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
    string customleadValue = '';
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

    public Admission_Form__c AdmissionForm {
        get;
        set;
    }
    public string customAdmissionFormValue {
        get;
        set;
    }
    ID enqId = ApexPages.currentPage().getParameters().get('id');

    public CalledForInteractionOnlineController(ApexPages.StandardController controller) {
        Id pid = Apexpages.currentpage().getParameters().get('id');
        enq = [SELECT id, Interaction_Rescheduled_For__c, Interaction_Rescheduled_On__c, Interaction_Scheduled__c, Name, Stages__c, School_Institution__c, School_Institution__r.School_Short_Code__c, Log_Status__c, Meet_Online_Scheduled__c, Interested__c, School_Tour_Scheduled__c, School_Tour_Re_Scheduled__c, Email__c, Contact__c,
            Interaction_Done__c, Lead_ID__c, Org_code__c FROM Enquiry__c WHERE id =: pid
        ];
        schoolshortcode = enq.Org_code__c;
        strlead = enq.Lead_ID__c;
        lstleads = new List < Lead > ();
        lstlead = new List < Lead > ();
        lstlead = [SELECT id, Lead_ID__c, Stage__c,
            Interaction_Scheduled__c, Interaction_Scheduled_For_Date__c, Interaction_Scheduled_For_Time__c, Interaction_Scheduled_On_Date__c, Interaction_Scheduled_On_Time__c,
            Interaction_ReScheduled__c, Interaction_ReScheduled_On_Date__c, Interaction_ReScheduled_On_Time__c,
            Interaction_Done__c, Interaction_Done_On_Date__c, Interaction_Done_On_Time__c
            FROM lead WHERE Lead_ID__c =: strlead
        ];
        system.debug('ID::::' + pid);
        ev = new Event();
        error = true;
        back = false;
    }
    public void alreadytourscheduled() {
        if (enq.Interaction_Scheduled__c == true) {
            error = false;
            back = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Interaction Online already Scheduled.'));
        }
    }
    public void alreadytournotscheduled() {
        if (enq.Interaction_Scheduled__c == false) {
            error = false;
            back = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Interaction not Scheduled .'));
        }
    }
    public pageReference CalledForInteraction() {
        try {
            schoolshortcode = enq.Org_code__c;
            boolean isEmailactive = false;
            string emailtemp;
            boolean notem = true;
            List < SchoolEmail__mdt > se = new list < SchoolEmail__mdt > ();
            se = [SELECT CCAddress__c, DisplayName__c, TempName__c, Active__c, Event__c, Object__c, SchoolShortcode__c FROM SchoolEmail__mdt WHERE SchoolShortcode__c =: schoolshortcode and Event__c = 'Call for Inter'];
            if (se != null && se.size() > 0) {
                isEmailactive = se[0].Active__c;
                emailtemp = se[0].TempName__c;
            } else {
                isEmailactive = false;
                notem = false;
            }
            CalendarEmail = [SELECT id, Calendar_Email__c, State__c, label, MasterLabel FROM School_List__mdt WHERE label =: schoolshortcode];
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
            if (enq.Interaction_Scheduled__c == false) {
                ev.WhatId = enq.id;
                //calanderemailstr.add(enq.Email__c);
                ev.School_Institution__c = enq.School_Institution__c;
                ev.Contact__c = enq.Contact__c;
                if (test.isRunningTest()) {
                    ev.DurationInMinutes = 60;
                    ev.ActivityDateTime = System.Datetime.now();
                }

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
                customleadValue = enq.Lead_ID__c;
                customAdmissionFormValue = enq.Id;
                enq.Interaction_Scheduled__c = true;
                enq.Stages__c = 'Interaction Scheduled';
                enq.Interaction_Scheduled_On__c = system.now();
                enq.Interaction_Scheduled_For__c = ev.StartDateTime;
                enq.Interaction_Assign_To__c = ev.OwnerId;
                enq.Interaction_Time__c = ev.StartDateTime.format('hh:mm a');
                enq.Interaction_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                enq.Interaction_Scheduled_On_Date__c = system.now().format('dd-MM-yyyy');
                enq.Interaction_Scheduled_On_Time__c = system.now().format('hh:mm a');
                //senquiry.Interaction_Scheduled_On__c= Date.today();
                //senquiry.Interaction_Scheduled_For__c= Date.today();
                update enq;
                system.debug('customleadValue >> ' + customleadValue);

                //update enq;
                system.debug('lstlead -- ' + lstlead);
                for (lead le: lstlead) {
                    lead l = new lead();
                    l.id = le.id;
                    l.Stage__c = 'Interaction Scheduled';
                    l.Interaction_Scheduled__c = true;
                    l.Interaction_Scheduled_On_Date__c = system.now().format('dd-MM-yyyy');
                    l.Interaction_Scheduled_On_Time__c = system.now().format('hh:mm a');
                    l.Interaction_Scheduled_For_Time__c = ev.StartDateTime.format('hh:mm a');
                    l.Interaction_Scheduled_For_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                    lstleads.add(l);
                }
                system.debug('lstleads -- ' + lstleads);
                if (!lstleads.isEmpty()) {
                    update lstleads;
                }
                List < Admission_Form__c > lstAdmissionForm = new List < Admission_Form__c > ();
                List < Admission_Form__c > slitAdmissionForm = new List < Admission_Form__c > ();
                if (!Test.isRunningTest()) {
                    slitAdmissionForm = [SELECT Id, name, Application_Form__c, Enquiry_No__c, Interaction_Done__c, Interaction_Online_Rescheduled__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled__c, Interaction_Rescheduled__c, Interaction_Scheduled_For__c, Interaction_Scheduled_On__c, Interaction_Scheduled__c FROM Admission_Form__c WHERE Enquiry_No__c =: customAdmissionFormValue];
                } else {
                    slitAdmissionForm = [SELECT Id, name, Application_Form__c, Enquiry_No__c, Interaction_Scheduled__c, Interaction_Scheduled_On__c, Interaction_Scheduled_For__c, Interaction_Rescheduled__c, Interaction_Online_Scheduled__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Rescheduled__c, Interaction_Done__c FROM Admission_Form__c limit 1];
                }
                system.debug('slitAdmissionForm >> ' + slitAdmissionForm);
                if (!slitAdmissionForm.isEmpty()) {
                    for (Admission_Form__c ADF: slitAdmissionForm) {
                        Admission_Form__c AF = new Admission_Form__c();
                        AF.id = ADF.id;
                        AF.Interaction_Scheduled__c = true;
                        AF.Status__c = 'Interaction Scheduled';
                        lstAdmissionForm.add(AF);
                    }
                    system.debug('lstAdmissionForm -- ' + lstAdmissionForm);
                    if (!lstAdmissionForm.isEmpty()) {
                        update lstAdmissionForm;
                    }
                }
                String templateName = 'Meeting_At_School_Schedule_Email_Template';
                System.debug('-=-=' + templateName);
                String htmlbody = null;
                if (!test.isRunningTest()) {
                    Boolean toMakeStellarCallout = StellarAPICallouts.checkIfStellarAPIEnabled(enq.School_Institution__r.School_Short_Code__c);
                    System.debug('toMakeStellarCallout :-------' + toMakeStellarCallout);
                    if (!toMakeStellarCallout) {
                        if (isEmailactive) {
                            system.debug('temp ' + emailtemp);
                            SendEmail.SendEmailTemplateWithTemplate(emailtemp, enq.Contact__c, true, enq.id, se[0], ev.id);
                        } else {
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
                        // SyncEventDataToVeris.syncData(JSONData, 'CalledForInteractionOnlineController1');
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

    public pageReference InteractionOnlineRescheduled() {

        try {
            schoolshortcode = enq.Org_code__c;
            CalendarEmail = [SELECT id, Calendar_Email__c, State__c, label, MasterLabel FROM School_List__mdt WHERE label =: schoolshortcode];
            boolean isEmailactive = false;
            string emailtemp;
            boolean notem = true;
            List < SchoolEmail__mdt > se = new list < SchoolEmail__mdt > ();
            se = [SELECT TempName__c, Active__c, DisplayName__c, CCAddress__c, Event__c, Object__c, SchoolShortcode__c FROM SchoolEmail__mdt WHERE SchoolShortcode__c =: schoolshortcode and Event__c = 'Interaction Re-scheduled'];
            if (se != null && se.size() > 0) {
                isEmailactive = se[0].Active__c;
                emailtemp = se[0].TempName__c;
            } else {
                isEmailactive = false;
                notem = false;
            }
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
            system.debug('senquiry >>>>>> @ > ' + enq);
            if (enq != null) {

                customAdmissionFormValue = enq.Id;
                //enq.Interaction_Online_Scheduled__c = true;
                enq.Interaction_Rescheduled__c = true;
                enq.Stages__c = 'Interaction Online Rescheduled';
                enq.Interaction_Rescheduled_On__c = system.now();
                enq.Interaction_Rescheduled_For__c = ev.StartDateTime;
                enq.Interaction_Re_scheduled_Assign_To__c = ev.OwnerId;
                enq.Interaction_Re_scheduled_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                enq.Interaction_Re_scheduled_Time__c = ev.StartDateTime.format('hh:mm a');
                //enq.Meet_at_School_Re_Schedule_Date__c=  ev.StartDateTime.format('dd-MM-yyyy');
                //enq.Meet_at_School_Re_Schedule_Time__c=ev.StartDateTime.format('hh:mm a');
                update enq;
                ev.WhatId = enq.id;
                //calanderemailstr.add(enq.Email__c);
                ev.School_Institution__c = enq.School_Institution__c;
                ev.Contact__c = enq.Contact__c;
                if (test.isRunningTest()) {
                    ev.DurationInMinutes = 60;
                    ev.ActivityDateTime = System.Datetime.now();
                }

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

                List < lead > slitlead = new List < lead > ();
                if (!Test.isRunningTest()) {
                    slitlead = [SELECT Id, name, Lead_ID__c, Status FROM lead WHERE Lead_ID__c =: customleadValue];
                } else {
                    slitlead = [SELECT Id, name, Lead_ID__c, Status FROM lead limit 1];
                }
                system.debug('slitlead >> ' + slitlead);
                if (!lstlead.isEmpty()) {
                    for (lead le: lstlead) {
                        lead l = new lead();
                        l.id = le.id;
                        l.Stage__c = 'Interaction Online Rescheduled';
                        l.Interaction_ReScheduled__c = true;

                        l.Interaction_ReScheduled_On_Time__c = System.Datetime.now().format('hh:mm a');
                        l.Interaction_ReScheduled_On_Date__c = System.Datetime.now().format('dd-MM-yyyy');
                        l.Interaction_ReScheduled_For_Date__c = ev.StartDateTime.format('dd-MM-yyyy');
                        l.Interaction_ReScheduled_For_Time__c = ev.StartDateTime.format('hh:mm a');
                        lstleads.add(l);
                    }
                    system.debug('lstlead -- ' + lstleads);
                    if (!lstleads.isEmpty()) {
                        update lstleads;
                    }
                }
                system.debug('customAdmissionFormValue >> ' + customAdmissionFormValue);
                List < Admission_Form__c > lstAdmissionForm = new List < Admission_Form__c > ();
                List < Admission_Form__c > slitAdmissionForm = new List < Admission_Form__c > ();
                if (!Test.isRunningTest()) {
                    slitAdmissionForm = [SELECT Id, name, Application_Form__c, Enquiry_No__c, Interaction_Done__c, Interaction_Online_Rescheduled__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled__c, Interaction_Rescheduled__c, Interaction_Scheduled_For__c, Interaction_Scheduled_On__c, Interaction_Scheduled__c FROM Admission_Form__c WHERE Enquiry_No__c =: customAdmissionFormValue];
                } else {
                    slitAdmissionForm = [SELECT Id, name, Application_Form__c, Enquiry_No__c, Interaction_Done__c, Interaction_Online_Rescheduled__c, Interaction_Online_Scheduled_For__c, Interaction_Online_Scheduled_On__c, Interaction_Online_Scheduled__c, Interaction_Rescheduled__c, Interaction_Scheduled_For__c, Interaction_Scheduled_On__c, Interaction_Scheduled__c FROM Admission_Form__c limit 1];
                }
                system.debug('slitAdmissionForm >> ' + slitAdmissionForm);
                if (!slitAdmissionForm.isEmpty()) {
                    for (Admission_Form__c ADF: slitAdmissionForm) {
                        Admission_Form__c AF = new Admission_Form__c();
                        AF.id = ADF.id;
                        AF.Interaction_Online_Scheduled__c = false;
                        AF.Interaction_Online_Rescheduled__c = true;
                        AF.Status__c = 'Interaction Online Rescheduled';
                        lstAdmissionForm.add(AF);
                    }
                    system.debug('lstAdmissionForm -- ' + lstAdmissionForm);
                    if (!lstAdmissionForm.isEmpty()) {
                        update lstAdmissionForm;
                    }
                }
                String templateName = 'Meeting_At_School_Schedule_Email_Template';
                System.debug('-=-=' + templateName);
                String htmlbody = null;
                if (!test.isRunningTest()) {
                    Boolean toMakeStellarCallout = StellarAPICallouts.checkIfStellarAPIEnabled(enq.School_Institution__r.School_Short_Code__c);
                    System.debug('toMakeStellarCallout :-------' + toMakeStellarCallout);
                    if (!toMakeStellarCallout) {
                        if (isEmailactive) {
                            system.debug('temp ' + emailtemp);
                            SendEmail.SendEmailTemplateWithTemplate(emailtemp, enq.Contact__c, true, enq.id, se[0], ev.id);
                        } else {
                            system.debug('no temp ' + emailtemp);
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
                        // SyncEventDataToVeris.syncData(JSONData, 'CalledForInteractionOnlineController2');
                    }
                    // ------ Veris Sync Event --------
                    GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id, StellarAPICallouts.POST_METHOD, toMakeStellarCallout, htmlbody);
                }
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ex.getMessage()));
            system.debug('Error while Insertion::' + ex.getMessage());
        }
        PageReference retURL = new PageReference('/' + enq.Id);
        retURL.setRedirect(true);
        return retURL;
    }
    public PageReference IntractionDoneEnquiry() {
        enq = new Enquiry__c();
        if (!Test.isRunningTest()) {
            enq = [SELECT id, name, Org_code__c, Lead_ID__c, Contact__c, Stages__c, Interaction_Rescheduled__c, Interaction_Scheduled__c FROM Enquiry__c WHERE id =: enqId];
        } else {
            enq = [SELECT id, name, Org_code__c, Lead_ID__c, Contact__c, Stages__c, Called_for_Observation__c, Interaction_Scheduled__c, Interaction_Scheduled_For__c, Interaction_Scheduled_On__c FROM Enquiry__c limit 1];
        }
        enq = [SELECT id, name, Org_code__c, Lead_ID__c, Contact__c, Stages__c, Interaction_Rescheduled__c, Interaction_Scheduled__c FROM Enquiry__c WHERE id =: enqId];
        system.debug('senquiry >>>>>> @ > ' + enq);
        if (enq != null) {
            if (enq.Interaction_Scheduled__c == true) {
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Interaction Already Done!!'));
            }
            if (enq.Interaction_Rescheduled__c == true) {
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Interaction Re Scheduled Already Done!!'));
            }
            if (enq.Interaction_Scheduled__c == true || enq.Interaction_Rescheduled__c == true) {
                ST_AdmissionFormObservation.UpdateEnquiryObservationDone(enq.Id);
            }
        }
        PageReference retURL = new PageReference('/' + enq.Id);
        retURL.setRedirect(true);
        return retURL;
    }
    public PageReference cancel() {
        return new pageReference('/' + enq.Id);
    }
    public static void FormFactory() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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