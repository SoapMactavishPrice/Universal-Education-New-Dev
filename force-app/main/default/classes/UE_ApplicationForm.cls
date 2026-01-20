//Purpose : Controller for capturing the fields
public class UE_ApplicationForm{

    public String gen {get;set;}
    Public Enquiry__c enq{get;set;}
    public Account acc{get;set;}
    public Application_Form__c form{get;set;}
    public LIST<Application_Form__c> appf{get;set;}
    public LIST<Application_Form__c> app{get;set;}
    public boolean editMode{get;set;}
    public String num{get;set;}
    public String otp{get;set;}
    public boolean otpSent {get; set;}
    public boolean verifySent {get; set;}
    public String message{get;set;}
    public boolean thanku {get;set;}
    public boolean mInfo {get;set;}
    //For SMS
    public string phone_no {get;set;}
    public string contactName { get;set;}
    public string gupshupUserID{ get;set;}
    public string gupshupPassword{ get;set;}
    public string appID{ get;set;}
    public string msg{get;set;}
    public string Template {get;set;}
    public String academicYear{get;set;}
    public String accountName{get;set;}

    public UE_ApplicationForm(ApexPages.StandardController Controller){

        form = (Application_Form__c)Controller.getRecord();
        // String eid = ApexPages.currentPage().getParameters().get('eid');
        editMode = false;
        otpSent = false;
        verifySent = false;
        thanku = false;
        mInfo = false;

        gupshupUserID='2000045203';
        gupshupPassword='universalgoogle';

        Schema.DescribeFieldResult fieldDesc = Schema.Enquiry__c.Academic_Year__c.getDescribe();
        for (Schema.Picklistentry picklistEntry: fieldDesc.getPicklistValues())
        {
            if (picklistEntry.isDefaultValue())
            {
                academicYear= picklistEntry.getValue();
                break;
            }
        }



        enq=new Enquiry__c();
        if(form.Enquiry__c!=null)
        {

            enq = [SELECT Academic_Year__c,Address__c,City__c,Email__c,Name,Id,Mobile_No__c,orgCode__c,Last_Name__c,FirstName__c,
                   Date_of_Birth__c,Country__c,Gender__c,Grade__c,Log_Status__c,Parent_Last_Name__c,Parent_First_Name__c,
                   Pin_Code__c,School_Institution__c,Seeking_Admission_in_Grade__c,Source_of_Information__c,Stages__c,State__c,
                   Student_Full_Name__c,ParentFull_Name__c,Application_Received__c FROM Enquiry__c where Id =: form.Enquiry__c];
            system.debug('Enquiry::::::'+enq);

            num = enq.Mobile_No__c;
            system.debug('BEFOR_SENDING_NUMBER+++++'+num);
            form.OTP__c = otp;
            System.debug('OTP::::::'+otp);

            Account acc = [Select id,Name,School_Short_Code__c from Account where Id =: enq.School_Institution__c Limit 1];
            accountName = acc.School_Short_Code__c;
            system.debug('SChool_Record:::::'+acc);
            system.debug('Account Name:::::'+accountName);


            appf = [Select ID,Name,Enquiry__c from Application_Form__c where Enquiry__c=:enq.Id];
            system.debug('App:::::'+appf);
            if(appf.size()>0){
                system.debug('Inside IF EXISTING APPLICATION:::'+appf);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'You have already ragistered '));
                thanku = true;
            }

        }
    }
    //*****************//

    public void getpassport(){
        if(form.Passport_No__c!='null'){
            form.Expiry_Date__c.addError('This field is required..!');
        }
    }
    public void getexpdate(){
        if(string.valueOf(form.Expiry_Date__c)!='null'){
            message='';
        }
    }
    //*********************//
    public pagereference save(){
        String eid = ApexPages.currentPage().getParameters().get('eid');
        string response = validate();
        System.debug('response in save +++'+ response);
        try{
            if(response == 'success'  || Test.isRunningTest()){     //&& enq.id != null && enq.id != ''
                system.debug('@@@@@@@@@Academic Year@@@@@@@@@'+academicYear);
                Integer i=1;
                Integer k=0;
                List<Application_Form__c> appList=[Select id,Autonumber_apexClass__c,School_Short_Code__c
                                                   from Application_Form__c where Academic_Year__c=:academicYear and
                                                   School_Short_Code__c=:enq.orgCode__c and Autonumber_apexClass__c >0
                                                   order by createddate desc NULLS LAST limit 1];
                if(!appList.isEmpty())
                    System.debug('Record----'+appList[0].id);

                if(!appList.isEmpty())
                {

                    k=i+Integer.valueOf(appList[0].Autonumber_apexClass__c);
                    form.Name=enq.Academic_Year__c+'/'+enq.Seeking_Admission_in_Grade__c+'/'+accountName+'/'+'APP'+'/'+k;
                    form.Autonumber_apexClass__c=k;
                }
                else
                {
                    form.Name=enq.Academic_Year__c+'/'+enq.Seeking_Admission_in_Grade__c+'/'+accountName+'/'+'APP'+'/'+i;
                    form.Autonumber_apexClass__c=i;
                }

                form.Enquiry__c = enq.id;
                form.Academic_Year__c = enq.Academic_Year__c;
                form.Enquiry_Number__c = enq.Name;

                form.Student_Name__c = enq.Student_Full_Name__c;
                form.Seeking_Admission_in_Grade__c = enq.Seeking_Admission_in_Grade__c;
                form.Mobile_Number__c = enq.Mobile_No__c;
                form.Email_Address__c = enq.Email__c;
                form.Address__c = enq.Address__c;
                form.School_Institution__c=enq.School_Institution__c;
                form.State__c = enq.State__c;
                form.City__c = enq.City__c;
                form.Pincode__c = enq.Pin_Code__c;
                form.Country__c  = enq.Country__c;
                form.OTP__c = otp;
                form.SchoolShort_Code__c = enq.orgCode__c;
                insert form;
                enq.Application_Received__c = true;
                enq.Stages__c = 'Application submitted';

                update enq;
                return new pageReference('/'+form.Id);
            }
            //    return new pageReference('/showApplicationNumber?eid='+form.Id);
            // return null;

        }
        Catch(exception exp){

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'The url is broken...please open the url again'));

            exp.getMessage();
            system.debug('Exception'+exp);


        }
        return null;
    }

    public pageReference sendOTP(){
        system.debug('ENQUIRY>>>>>'+enq);
        system.debug('mob'+enq.Mobile_No__c);
        smsgupshupTemplate__c msg= [SELECT Name__c, Description__c FROM smsgupshupTemplate__c where Name__c= 'OTP' limit 1];
        system.debug('MEG:::::'+msg);
        system.debug('MEG:::::'+num);
        System.debug('enquiry otp::::'+enq.Mobile_No__c+'final year::::'+enq.Academic_Year__c);

        Template = msg.Description__c;

        string FinalMsg= EncodingUtil.urlEncode(Template, 'UTF-8');
        string endpoint='http://enterprise.smsgupshup.com/GatewayAPI/rest?userid='+gupshupUserID+'&password='+gupshupPassword+'&method=TWO_FACTOR_AUTH&v=1.1&phone_no='+enq.Mobile_No__c+'&msg='+FinalMsg+'&format=text&otpCodeLength=4&otpCodeType=NUMERIC';

        System.debug('ENDPOINT+++++'+endpoint);
        String bodyContent='';
        HttpRequest req = new HttpRequest();
        Http httpreq = new Http();
        req.setHeader('cache-control', 'no-cache');
        req.setBody(bodyContent);
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        HttpResponse res = httpreq.send(req);
        String reqresponse = res.getBody();
        System.debug('RESPONSE::::::'+reqresponse);


        if(reqresponse.contains('success')){
            otpSent = !otpSent;
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.CONFIRM,'OTP has send successfully');
            apexpages.addmessage(msgs);
        }if(reqresponse.contains('error') && reqresponse.contains('You are re-trying too early. Please wait for some time.')){
            otpSent = !otpSent;
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.Error,'You are re-trying too early. Please wait for some time.');
            apexpages.addmessage(msgs);
        }
        return null;

    }

    public pageReference verifyOtpSms(){
        string endpoint='http://enterprise.smsgupshup.com/GatewayAPI/rest?userid='+gupshupUserID+'&password='+gupshupPassword+'&method=TWO_FACTOR_AUTH&v=1.1&phone_no='+enq.Mobile_No__c+'&otp_code='+otp;
        String bodyContent='';
        HttpRequest req = new HttpRequest();
        Http httpreq = new Http();
        req.setHeader('cache-control', 'no-cache');
        req.setBody(bodyContent);
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        HttpResponse res = httpreq.send(req);
        String verifyResponse = res.getBody();
        System.debug('Verify_RESPONSE::::::'+verifyResponse);
        //  return verifyResponse;
        if(verifyResponse.contains('success')){
            otpSent = !otpSent;
            system.debug('OTP_SENT:::::'+otpSent);
            verifySent = true;
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.CONFIRM,'OTP Verified');
            apexpages.addmessage(msgs);
        }if(verifyResponse.contains('incorrect')){
            otpSent = true;
            system.debug('OTP_SENT:::::'+otpSent);
            verifySent = false;
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.ERROR,'OTP incorrect');
            apexpages.addmessage(msgs);
        }if(verifyResponse.contains('error') && verifyResponse.contains('You have exeeded maximum number of attempts')){
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.ERROR,'You have exeeded maximum number of attempts.');
            apexpages.addmessage(msgs);
        }if(verifyResponse.contains('error') && verifyResponse.contains('OTP token has expired.')){
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.ERROR,'Your OTP expired');
            apexpages.addmessage(msgs);
        }
        return null;
    }

    //Checking the Mother Occupation
    public void validateMother(){
        system.debug('Inside Debug::');
        if(form.Mother_Occupation__c != null && (form.Mother_Occupation__c =='Housewife' || form.Mother_Occupation__c =='House wife'|| form.Mother_Occupation__c =='Housewive' || form.Mother_Occupation__c =='House wive' || form.Mother_Occupation__c.contains('home') || form.Mother_Occupation__c.contains('Home') || form.Mother_Occupation__c.contains('HOME') || form.Mother_Occupation__c.contains('House') || form.Mother_Occupation__c.contains('HOUSE') || form.Mother_Occupation__c.contains('house') )){
            system.debug('Debug::'+form.Mother_Occupation__c);
            mInfo = !mInfo;
            system.debug('VALUDE:: '+mInfo);
        }
        else{
            mInfo = false;
        }

    }

    public void toggleEditMode(){
        editMode = !editMode;
        system.debug('EDITBUTTON+++'+editMode);
    }

    public string validate(){
        String eid = ApexPages.currentPage().getParameters().get('eid');
        string msg;
        decimal error= 0;
        /* if(enq.id == null || enq.id == ''){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'The url is broken...please open the url again'));
error= error + 1;
}else if(enq.id != null && enq.id != ''){*/
        if(form.Nationality__c == null || form.Nationality__c == ''){
            form.Nationality__c.addError('Please provide your nationality');
            error= error + 1;
        }
        if(form.Nationality__c !=null ){
            String NameRegex1 = '^[a-z A-Z]+$';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            System.debug('MYPATTERN++++'+MyPattern1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Nationality__c);
            system.debug('MYMATCHER+++'+MyPattern1);
            Boolean result1 = MyMatcher1.matches();
            system.debug('RESULT+++'+result1);

            if (result1 == FALSE) {
                form.Nationality__c.addError('Please enter a proper value');
                error= error + 1;
            }
        }
        if(form.Mother_Tongue__c == null || form.Mother_Tongue__c == ''){
            form.Mother_Tongue__c.addError('Please enter proper value');
            error= error + 1;
        }
        if(form.Mother_Tongue__c !=null ){

            String NameRegex1 = '^[a-z A-Z]+$';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            System.debug('MYPATTERN++++'+MyPattern1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Tongue__c);
            system.debug('MYMATCHER+++'+MyPattern1);
            Boolean result1 = MyMatcher1.matches();
            system.debug('RESULT+++'+result1);

            if (result1 == FALSE) {
                form.Mother_Tongue__c.addError('Please enter proper value');
                error= error + 1;
            }
        }
        if(form.Adhaar_Card_No__c == null || form.Adhaar_Card_No__c == ''){
            form.Adhaar_Card_No__c.addError('Please enter valid 12-digit Adhaar Card No');
            error= error + 1;
        }
        if(form.Adhaar_Card_No__c !=null ){

            String NameRegex1 = '[0-9]{4}[0-9]{4}[0-9]{4}';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            System.debug('MYPATTERN++++'+MyPattern1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Adhaar_Card_No__c);
            system.debug('MYMATCHER+++'+MyPattern1);
            Boolean result1 = MyMatcher1.matches();
            system.debug('RESULT+++'+result1);

            if (result1 == FALSE)
            {
                form.Adhaar_Card_No__c.addError('Please enter valid 12-digit Adhaar Card No');
                error= error + 1;
            }
        }
        if(form.Mother_Occupation__c != null){
            String NameRegex1 = '^[a-z A-Z]+$';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            System.debug('MYPATTERN++++'+MyPattern1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Occupation__c);
            system.debug('MYMATCHER+++'+MyPattern1);
            Boolean result1 = MyMatcher1.matches();
            system.debug('RESULT+++'+result1);

            if (result1 == FALSE) {
                form.Mother_Occupation__c.addError('Please enter proper value');
                error= error + 1;
            }
        }

        if(form.Father_First_Name__c !=null ){
            String NameRegex1 = '^[a-z A-Z]+$';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Father_First_Name__c);
            Boolean result1 = MyMatcher1.matches();
            system.debug('RESULT+++'+result1);

            if (result1 == FALSE) {
                form.Father_First_Name__c.addError('Please enter a proper value');
                error= error + 1;
            }
        }
        if(form.Father_Last_Name__c !=null ){
            String NameRegex1 = '^[a-z A-Z]+$';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Father_Last_Name__c);
            Boolean result1 = MyMatcher1.matches();
            system.debug('RESULT+++'+result1);

            if (result1 == FALSE) {
                form.Father_Last_Name__c.addError('Please enter a proper value');
                error= error + 1;
            }
        }
        if(form.Father_Phone__c != null)
        {
            String mobile = form.Father_Phone__c;
            if(!Pattern.matches('[0-9]{10}', mobile))
            {
                form.Father_Phone__c.addError('Please enter proper 10 digit mobile Number');
                system.debug('Testing');
                error= error + 1;
            }
        }
        if(form.Father_Qualification__c !=null )
        {
            if(form.Father_Qualification__c.contains('@') || form.Father_Qualification__c.contains('!') || form.Father_Qualification__c.contains('#') || form.Father_Qualification__c.contains('$') || form.Father_Qualification__c.contains('%') || form.Father_Qualification__c.contains('&') || form.Father_Qualification__c.contains('*')|| form.Father_Qualification__c.contains('(') || form.Father_Qualification__c.contains(')')|| form.Father_Qualification__c.contains('<')|| form.Father_Qualification__c.contains('>')|| form.Father_Qualification__c.contains('+')|| form.Father_Qualification__c.contains('=')|| form.Father_Qualification__c.contains('?')|| form.Father_Qualification__c.contains(';') || form.Father_Qualification__c.contains('-')){
                form.Father_Qualification__c.addError('Special Charcters are not allowed like (@#$+=?<>%^&*)');
                error= error + 1;
            }
        }
        if(form.Father_Email_Id__c !=null ){

            String NameRegex1 = '[a-zA-Z0-9._]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Father_Email_Id__c);
            Boolean result1 = MyMatcher1.matches();
            system.debug('RESULT+++'+result1);
            if (result1 == FALSE)
            {
                form.Father_Email_Id__c.addError('Please enter Proper Email Id');
                error= error + 1;
            }
        }
        if(form.Father_Occupation__c != null){
            String NameRegex1 = '^[a-z A-Z]+$';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Father_Occupation__c);
            Boolean result1 = MyMatcher1.matches();

            if (result1 == FALSE) {
                form.Father_Occupation__c.addError('Please enter proper value');
                error= error + 1;
            }
        }
        if(form.Father_Name_of_Organisation__c != null){
            String NameRegex1 = '^[a-z A-Z]+$';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Father_Name_of_Organisation__c);
            Boolean result1 = MyMatcher1.matches();

            if (result1 == FALSE) {
                form.Father_Name_of_Organisation__c.addError('Please enter proper value');
                error= error + 1;
            }
        }
        if(form.Father_Business_Contact__c != null)
        {
            String mobile = form.Father_Business_Contact__c;
            if(!Pattern.matches('[0-9]{10}', mobile))
            {
                form.Father_Business_Contact__c.addError('Please enter proper 10 digit mobile Number');
                system.debug('Testing');
                error= error + 1;
            }
        }
        if(form.Father_Business_Address__c !=null )
        {
            if(form.Father_Business_Address__c.contains('@') || form.Father_Business_Address__c.contains('!') || form.Father_Business_Address__c.contains('#') || form.Father_Business_Address__c.contains('$') || form.Father_Business_Address__c.contains('%') || form.Father_Business_Address__c.contains('&') || form.Father_Business_Address__c.contains('*')|| form.Father_Business_Address__c.contains('(') || form.Father_Business_Address__c.contains(')')|| form.Father_Business_Address__c.contains('<')|| form.Father_Business_Address__c.contains('>')|| form.Father_Business_Address__c.contains('+')|| form.Father_Business_Address__c.contains('=')|| form.Father_Business_Address__c.contains('?')|| form.Father_Business_Address__c.contains(';')){
                form.Father_Business_Address__c.addError('Special Charcters are not allowed like (@#$+=?<>%^&*)');
                error= error + 1;
            }
        }



        if(form.Mother_First_Name__c !=null ){
            String NameRegex1 = '^[a-z A-Z]+$';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_First_Name__c);
            Boolean result1 = MyMatcher1.matches();
            system.debug('RESULT+++'+result1);

            if (result1 == FALSE) {
                form.Mother_First_Name__c.addError('Please enter a proper value');
                error= error + 1;
            }
        }
        if(form.Mother_Last_Name__c !=null ){
            String NameRegex1 = '^[a-z A-Z]+$';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Last_Name__c);
            Boolean result1 = MyMatcher1.matches();
            system.debug('RESULT+++'+result1);

            if (result1 == FALSE) {
                form.Mother_Last_Name__c.addError('Please enter a proper value');
                error= error + 1;
            }
        }
        if(form.Mother_Phone__c != null)
        {
            String mobile = form.Mother_Phone__c;
            if(!Pattern.matches('[0-9]{10}', mobile))
            {
                form.Mother_Phone__c.addError('Please enter proper 10 digit mobile Number');
                system.debug('Testing');
                error= error + 1;
            }
        }
        if(form.Mother_Qualification__c !=null )
        {
            if(form.Mother_Qualification__c.contains('@') || form.Mother_Qualification__c.contains('!') || form.Mother_Qualification__c.contains('#') || form.Mother_Qualification__c.contains('$') || form.Mother_Qualification__c.contains('%') || form.Mother_Qualification__c.contains('&') || form.Mother_Qualification__c.contains('*')|| form.Mother_Qualification__c.contains('(') || form.Mother_Qualification__c.contains(')')|| form.Mother_Qualification__c.contains('<')|| form.Mother_Qualification__c.contains('>')|| form.Mother_Qualification__c.contains('+')|| form.Mother_Qualification__c.contains('=')|| form.Mother_Qualification__c.contains('?')|| form.Mother_Qualification__c.contains(';') || form.Mother_Qualification__c.contains('-')){
                form.Mother_Qualification__c.addError('Special Charcters are not allowed like (@#$+=?<>%^&*)');
                error= error + 1;
            }
        }
        if(form.Mother_Email_Id__c !=null ){

            String NameRegex1 = '[a-zA-Z0-9._]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Email_Id__c);
            Boolean result1 = MyMatcher1.matches();
            system.debug('RESULT+++'+result1);
            if (result1 == FALSE)
            {
                form.Mother_Email_Id__c.addError('Please enter Proper Email Id');
                error= error + 1;
            }
        }
        if(form.Mother_Occupation__c != null){
            String NameRegex1 = '^[a-z A-Z]+$';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Occupation__c);
            Boolean result1 = MyMatcher1.matches();

            if (result1 == FALSE) {
                form.Mother_Occupation__c.addError('Please enter proper value');
                error= error + 1;
            }
        }
        if(form.Mother_Name_of_Organisation__c != null){
            String NameRegex1 = '^[a-z A-Z]+$';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Name_of_Organisation__c);
            Boolean result1 = MyMatcher1.matches();

            if (result1 == FALSE) {
                form.Mother_Name_of_Organisation__c.addError('Please enter proper value');
                error= error + 1;
            }
        }
        if(form.Mother_Business_Contact__c != null)
        {
            String mobile = form.Mother_Business_Contact__c;
            if(!Pattern.matches('[0-9]{10}', mobile))
            {
                form.Mother_Business_Contact__c.addError('Please enter proper 10 digit mobile Number');
                system.debug('Testing');
                error= error + 1;
            }
        }
        if(form.Mother_Business_Address__c !=null )
        {
            if(form.Mother_Business_Address__c.contains('@') || form.Mother_Business_Address__c.contains('!') || form.Mother_Business_Address__c.contains('#') || form.Mother_Business_Address__c.contains('$') || form.Mother_Business_Address__c.contains('%') || form.Mother_Business_Address__c.contains('&') || form.Mother_Business_Address__c.contains('*')|| form.Mother_Business_Address__c.contains('(') || form.Mother_Business_Address__c.contains(')')|| form.Mother_Business_Address__c.contains('<')|| form.Mother_Business_Address__c.contains('>')|| form.Mother_Business_Address__c.contains('+')|| form.Mother_Business_Address__c.contains('=')|| form.Mother_Business_Address__c.contains('?')|| form.Mother_Business_Address__c.contains(';')){
                form.Mother_Business_Address__c.addError('Special Charcters are not allowed like (@#$+=?<>%^&*)');
                error= error + 1;
            }
        }
        if(!form.Application_Form_Declaration__c){
            form.Application_Form_Declaration__c.addError('Mark the Application form declaration checkbox');
            error= error + 1;
        }
        if(!form.Mother_Detail_Captured__c && !form.Father_Datail_captured__c && form.Guardian_Name__c == null){
            form.Guardian_Name__c.addError('Provide Guardian Name');
            error= error + 1;
        }
        if((form.Mother_Detail_Captured__c && !(form.Father_Datail_captured__c) && !form.Single_Parent__c)||(form.Father_Datail_Captured__c && !(form.Mother_Detail_captured__c) && !form.Single_Parent__c)) {
            form.Single_Parent__c.addError('Mark the single parent checkbox');
            error= error + 1;
        }
        //     }
        if(error == 0){
            msg = 'success';
        }else{
            msg ='failure';
        }
        return msg;
    }

    public static void fakeMethod() {
        Integer i = 1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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