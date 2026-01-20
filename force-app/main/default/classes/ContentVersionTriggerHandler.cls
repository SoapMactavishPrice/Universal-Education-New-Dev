public class ContentVersionTriggerHandler {
	public static void doAfterInsert(List<ContentVersion> cvList) {
        if(!cvList.IsEmpty()){
            List<ContentDistribution> cdListToInsert = new List<ContentDistribution>();
            for(ContentVersion cv : cvList){
                cdListToInsert.add(new ContentDistribution(
                    ContentVersionId = cv.Id,
                    Name = cv.Title
                ));
            }
            if(!cdListToInsert.IsEmpty())INSERT cdListToInsert;
            System.debug(cdListToInsert); //your ContentDistribution which will have public & download URL for the file.
        }
    }
}