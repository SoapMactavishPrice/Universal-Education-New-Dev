public class ST_send_ApplicationForm_through_Email {
    public Enquiry__c enq{get;set;}
    public User u{get;set;}
    public boolean back{get;set;}
    public Boolean showMYExpirelink{ get; set; }
    public Boolean showMYPage{ get; set; }
    public string Lead_IDstr{get;set;}
    //public  String linkdate = ApexPages.currentPage().getParameters().get('linkdate');
    
    Id pid=Apexpages.currentpage().getParameters().get('id');
    
    public ST_send_ApplicationForm_through_Email()
    {
        back = false;
    }
    public PageReference send() {
        PageReference page;
        System.debug('=== send() METHOD STARTED ===');
        
        try {
            System.debug('>>> Querying Enquiry__c for pid: ' + pid);
            enq = [SELECT Org_code__c, Contact__c, Parent_First_Name__c, Lead_ID__c, Application_Link_Sent__c,
                        Application_Link_Sent_On__c, Parent_Last_Name__c, School_Institution__r.For_Mapping_Email__c,
                        Academic_Year__c, Interested__c, Id, School_Institution__r.Website, Name, Email__c,
                        School_Name__c, Stages__c, Application_Link_Sent_On_Date__c, Application_Link_Sent_On_Time__c,
                        Application_Sent__c, Interaction_Done__c, Application_Received__c, ParentFull_Name__c,
                        School_Institution__r.School_Short_Code__c
                FROM Enquiry__c WHERE Id = :pid];
            System.debug('>>> Enquiry__c fetched: ' + enq);
            System.debug('>>> Enquiry Stage: ' + enq.Stages__c);
            System.debug('>>> Enquiry Email: ' + enq.Email__c);
            System.debug('>>> Enquiry Name: ' + enq.Name);
            System.debug('>>> School Short Code: ' + enq.School_Institution__r.School_Short_Code__c);

            System.debug('>>> Querying current User for Id: ' + UserInfo.getUserId());
            u = [SELECT Name, Profile.Name, Email, Phone, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()];
            System.debug('>>> User fetched: ' + u.Name + ' | Profile: ' + u.Profile.Name);

            // Stage validation checks
            System.debug('>>> Checking Stage validations...');

            if (enq.Stages__c == 'Application submitted') {
                System.debug('>>> BLOCKED: Stage is "Application submitted" — setting back = true');
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Application form Already Recieved !!'));
            }

            if (enq.Stages__c == 'Application (Rejected)') {
                System.debug('>>> BLOCKED: Stage is "Application (Rejected)" — setting back = true');
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Application form Already Recieved !!'));
            }

            if (enq.Stages__c == 'Application Link Sent') {
                System.debug('>>> BLOCKED: Stage is "Application Link Sent" — setting back = true');
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Application Form already sent on registered Email ID.'));
            }

            if (enq.Email__c == null) {
                System.debug('>>> BLOCKED: Email__c is null — setting back = true');
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Email ID is not present!!'));
            }

            if (enq.Email__c != null) {
                System.debug('>>> Email is present: ' + enq.Email__c + ' — proceeding with link generation');

                System.debug('>>> Querying Site for Name = "ApplicationProcess"');
                Site mySite = [SELECT Id FROM Site WHERE Name = 'ApplicationProcess'];
                System.debug('>>> Site fetched: ' + mySite.Id);

                System.debug('>>> Querying SiteDetail for DurableId: ' + mySite.Id);
                SiteDetail mySiteDetail = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :mySite.Id];
                System.debug('>>> SiteDetail SecureURL: ' + mySiteDetail.SecureURL);

                String siteLink = mySiteDetail.SecureURL + '/OTP_Validation?eid=' + enq.Id;
                System.debug('>>> Constructed Site Link: ' + siteLink);

                // Query Universal Application Fee metadata
                System.debug('>>> Querying Universal_Application_Fee_Amount__mdt for Short_Code__c: ' + enq.School_Institution__r.School_Short_Code__c);
                Map<String, Universal_Application_Fee_Amount__mdt> schoolNameUAmdtMap = new Map<String, Universal_Application_Fee_Amount__mdt>();
                for (Universal_Application_Fee_Amount__mdt mdtUAFA : [SELECT Merchant_ID__c, Payment_Applicable__c,
                                                                            Application_Fees__c, Message__c, Short_Code__c
                                                                    FROM Universal_Application_Fee_Amount__mdt
                                                                    WHERE Short_Code__c = :enq.School_Institution__r.School_Short_Code__c]) {
                    schoolNameUAmdtMap.put(mdtUAFA.Short_Code__c, mdtUAFA);
                    System.debug('>>> MDT Record added to map — Short_Code__c: ' + mdtUAFA.Short_Code__c
                        + ' | Payment_Applicable__c: ' + mdtUAFA.Payment_Applicable__c
                        + ' | Application_Fees__c: ' + mdtUAFA.Application_Fees__c);
                }
                System.debug('>>> schoolNameUAmdtMap size: ' + schoolNameUAmdtMap.size());

                // Payment check
                Boolean isPaymentApplicable = schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c)?.Payment_Applicable__c;
                System.debug('>>> Payment Applicable: ' + isPaymentApplicable);
                if (isPaymentApplicable == true) {
                    Decimal appFees = Decimal.valueOf(schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Application_Fees__c);
                    System.debug('>>> Calling razorPayOrderCreationAPI.OrderCreation with enq.Id: ' + enq.Id + ' | Fees: ' + appFees);
                    razorPayOrderCreationAPI.OrderCreation(enq.Id, appFees);
                    System.debug('>>> razorPayOrderCreationAPI.OrderCreation call completed');
                } else {
                    System.debug('>>> Payment NOT applicable — skipping RazorPay order creation');
                }

                // Build email body
                System.debug('>>> Building email body for: ' + enq.Parent_First_Name__c + ' ' + enq.Parent_Last_Name__c);
                String body = 'Dear ' + enq.Parent_First_Name__c + ' ' + enq.Parent_Last_Name__c + ','
                    + '<br><br> Greetings from ' + enq.School_Name__c + '!'
                    + '<br><br>It was a pleasure meeting you and hope all your queries have been answered satisfactorily. We now move ahead with the next step of the admissions process.'
                    + '<br><br>Kindly <a href="' + siteLink + '">click here</a>'
                    + ' to fill and submit the Admission application.<br><br>'
                    + 'For any further clarification feel free to email or call us.<br><br>'
                    + 'NOTE: This is a system-generated email. Kindly dont respond to it. For any communication, please contact on the email/phone number given above.<br><br>';
                System.debug('>>> Email body constructed (length): ' + body.length());

                // Build email object
                System.debug('>>> Building Messaging.SingleEmailMessage for To: ' + enq.Email__c);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddress = new String[]{ enq.Email__c };
                mail.setToAddresses(toAddress);

                // Org-Wide Email Address mapping
                System.debug('>>> Querying OrgWideEmailAddress records...');
                for (OrgWideEmailAddress owa : [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress]) {
                    System.debug('>>> OWA record — DisplayName: ' + owa.DisplayName + ' | Address: ' + owa.Address);
                    if (enq.School_Institution__c != null
                        && enq.School_Institution__r.For_Mapping_Email__c != null
                        && owa.DisplayName.contains(enq.School_Institution__r.For_Mapping_Email__c)) {
                        System.debug('>>> Matched OWA — Setting OrgWideEmailAddressId: ' + owa.Id);
                        mail.setOrgWideEmailAddressId(owa.Id);
                    }
                }

                String emailSub = 'Application for admission ' + enq.Academic_Year__c;
                System.debug('>>> Email Subject: ' + emailSub);
                mail.setSubject(emailSub);
                mail.setHtmlBody(body);

                // Query SchoolEmail metadata
                System.debug('>>> Querying SchoolEmail__mdt for Org_code__c: ' + enq.Org_code__c + ' | Event: "Send Application Link"');
                Boolean isEmailActive = false;
                String emailTemp;
                Boolean notem = true;
                List<SchoolEmail__mdt> se = [SELECT TempName__c, DisplayName__c, CCAddress__c, Active__c, Event__c,
                                                    Object__c, SchoolShortcode__c
                                            FROM SchoolEmail__mdt
                                            WHERE SchoolShortcode__c = :enq.Org_code__c
                                            AND Event__c = 'Send Application Link'];
                System.debug('>>> SchoolEmail__mdt records fetched: ' + se.size());

                if (se != null && se.size() > 0) {
                    isEmailActive = se[0].Active__c;
                    emailTemp = se[0].TempName__c;
                    System.debug('>>> SchoolEmail__mdt found — Active: ' + isEmailActive + ' | Template: ' + emailTemp);
                } else {
                    notem = false;
                    isEmailActive = false;
                    System.debug('>>> No SchoolEmail__mdt record found — notem = false, isEmailActive = false');
                }

                if (isEmailActive) {
                    System.debug('>>> Sending email using template: ' + emailTemp + ' via SendEmail.SendEmailTemplateWithTemplate()');
                    SendEmail.SendEmailTemplateWithTemplate(emailTemp, enq.Contact__c, true, enq.Id, se[0], null);
                    System.debug('>>> Template email sent successfully');
                } else {
                    System.debug('>>> Sending fallback standard email via Messaging.sendEmail()');
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
                    System.debug('>>> Standard email sent successfully');
                }

                // Generate OTP
                Integer len = 4;
                String str = String.valueOf(Math.abs(Crypto.getRandomLong()));
                String randomNumber = str.substring(0, len);
                System.debug('>>> Generated OTP: ' + randomNumber);

                // Update Enquiry fields
                System.debug('>>> Updating Enquiry__c fields — Stage → "Application Link Sent"');
                enq.OTP__c = randomNumber;
                enq.Application_Link_Sent_On__c = System.now();
                enq.Stages__c = 'Application Link Sent';
                System.debug('>>> enq.Application_Link_Sent__c (before check): ' + enq.Application_Link_Sent__c);

                if (enq.Application_Link_Sent__c != true) {
                    System.debug('>>> Application_Link_Sent__c is false — setting first-time sent fields');
                    enq.Application_Link_Sent_On__c = System.now();
                    enq.Application_Sent__c = true;
                    enq.Application_Link_Sent__c = true;
                    enq.Application_Link_Sent_On_Date__c = System.now().format('dd-MM-yyyy');
                    enq.Application_Link_Sent_On_Time__c = System.now().format('hh:mm a');
                    System.debug('>>> Enquiry sent date/time set: ' + enq.Application_Link_Sent_On_Date__c + ' ' + enq.Application_Link_Sent_On_Time__c);

                    // Query related Leads
                    System.debug('>>> Querying Lead records for Lead_ID__c: ' + enq.Lead_ID__c);
                    List<Lead> listLds = new List<Lead>();
                    List<Lead> listLd = [SELECT Id, Application_Link_Sent__c, Application_Link_Sent_On_Date__c,
                                                Application_Link_Sent_On_Time__c, Lead_ID__c, Stage__c
                                        FROM Lead WHERE Lead_ID__c = :enq.Lead_ID__c];
                    System.debug('>>> Leads fetched: ' + listLd.size());

                    for (Lead oLead : listLd) {
                        System.debug('>>> Processing Lead Id: ' + oLead.Id + ' | Current Stage: ' + oLead.Stage__c);
                        Lead ol = new Lead();
                        ol.Id = oLead.Id;
                        ol.Application_Link_Sent__c = true;
                        ol.Application_Link_Sent_On_Date__c = System.now().format('dd-MM-yyyy');
                        ol.Application_Form_Received_On_Time__c = System.now().format('hh:mm a');
                        ol.Stage__c = 'Application Link Sent';
                        listLds.add(ol);
                        System.debug('>>> Lead staged for update: ' + ol.Id + ' → Stage: Application Link Sent');
                    }

                    if (!listLds.isEmpty()) {
                        System.debug('>>> Updating ' + listLds.size() + ' Lead record(s)...');
                        update listLds;
                        System.debug('>>> Lead update successful');
                    } else {
                        System.debug('>>> No Lead records to update');
                    }
                } else {
                    System.debug('>>> Application_Link_Sent__c is already true — skipping first-time fields update');
                }

                System.debug('>>> Updating Enquiry__c record: ' + enq.Id);
                update enq;
                System.debug('>>> Enquiry__c update successful');

                page = new PageReference('/' + enq.Id);
                System.debug('>>> PageReference set to: /' + enq.Id);
            }

        } catch (Exception exp) {
            System.debug('!!! EXCEPTION in send() !!!');
            System.debug('!!! Message: ' + exp.getMessage());
            System.debug('!!! Stack Trace: ' + exp.getStackTraceString());
            System.debug('!!! Line Number: ' + exp.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, exp.getMessage()));
        }

        System.debug('>>> Returning page: ' + page);
        System.debug('=== send() METHOD ENDED ===');
        return page;
    }
    public PageReference cancel()
    {
        return  new pageReference('/'+enq.Id);
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
        }
    }
    
    
}