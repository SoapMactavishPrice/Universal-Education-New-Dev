public class ReschedulePhoneCallExtension {
    String meetingURL{get;set;}
    public ReschedulePhoneCallExtension(ApexPages.StandardController Controller){
       
        String cid = Apexpages.currentpage().getParameters().get('id');
         meetingURL='/'+cid;
        List<Event> evList=[Select Id,location,Createddate from Event where whoId=:cid order by createddate desc];
        if(evList.size()>0){
            String Loc=evList[0].location; 
            meetingURL='https://demodesk.com/book/neeraj-garg/phone-call-with-the-admission-team?reschedule='+loc.split('/')[3];
        }
    }
    public PageReference redirectToReschedule(){
        PageReference retURL = new PageReference(meetingURL);
        retURL.setRedirect(true);
        return retURL;
    }
}