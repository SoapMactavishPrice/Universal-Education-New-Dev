@isTest
public class ContentVersionTriggerHandlerTest {

    @isTest public static void testmethod1()
    { 
         Contentversion cv = new Contentversion();
         cv.Title = 'StudentPhoto-StudentPhoto.png';
         cv.PathOnClient = 'StudentPhoto-340px-Affidavit-of-Residence.png';
         cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.urlEncode('Unit Test Attachment Body','UTF-8'));
         cv.IsMajorVersion = true;
         cv.description='-StudentPhoto';
         insert cv;

    }

}