@IsTest
public class JSON2Apex_Test {
    
    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{'+
        ' \"kind\": \"calendar#event\",'+
        '\"etag\": \"\\\"3291052103826000\\\"\",'+
        '\"id\": \"fc14572hvpsca2tl17uu0c26uo\",'+
        ' \"status\": \"confirmed\",'+
        ' \"htmlLink\": \"https://www.google.com/calendar/event?eid=ZmMxNDU3Mmh2cHNjYTJ0bDE3dXUwYzI2dW8gbm90aWZpY2F0aW9uQHVuaXZlcnNhbC5lZHUuaW4\",'+
        ' \"created\": \"2022-02-22T10:34:11.000Z\",'+
        ' \"updated\": \"2022-02-22T10:34:11.913Z\",'+
        ' \"summary\": \"Online Admissions Meeting \",'+
        ' \"creator\": {'+
        ' \"email\": \"notification@universal.edu.in\",'+
        '  \"self\": true'+
        ' },'+
        ' \"organizer\": {'+
        '  \"email\": \"notification@universal.edu.in\",'+
        '  \"self\": true'+
        ' },'+
        ' \"start\": {'+
        '  \"dateTime\": \"2022-02-22T16:03:00+05:30\",'+
        '  \"timeZone\": \"Asia/Kolkata\"'+
        ' },'+
        ' \"end\": {'+
        ' \"dateTime\": \"2022-02-23T16:03:00+05:30\",'+
        ' \"timeZone\": \"Asia/Kolkata\"'+
        '},'+
        ' \"iCalUID\": \"fc14572hvpsca2tl17uu0c26uo@google.com\",'+
        ' \"sequence\": 0,'+
        ' \"attendees\": ['+
        '  {'+
        '  \"email\": \"raw221007@gmail.com\",'+
        '   \"displayName\": \"Universal Education\",'+
        '   \"responseStatus\": \"needsAction\"'+
        ' },'+
        ' {'+
        '   \"email\": \"admissions.malad@universal.edu.in\",'+
        '   \"responseStatus\": \"needsAction\"'+
        '  }'+
        '],'+
        ' \"hangoutLink\": \"https://meet.google.com/frt-svan-mmd\",'+
        ' \"conferenceData\": {'+
        '  \"createRequest\": {'+
        '  \"requestId\": \"00U72000000BWpNEAW\",'+
        '   \"conferenceSolutionKey\": {'+
        '   \"type\": \"hangoutsMeet\"'+
        '  },'+
        '   \"status\": {'+
        '   \"statusCode\": \"success\"'+
        '  }'+
        ' },'+
        '  \"entryPoints\": ['+
        '  {'+
        '   \"entryPointType\": \"video\",'+
        '   \"uri\": \"https://meet.google.com/frt-svan-mmd\",'+
        '   \"label\": \"meet.google.com/frt-svan-mmd\"'+
        '   }'+
        '],'+
        ' \"conferenceSolution\": {'+
        ' \"key\": {'+
        '  \"type\": \"hangoutsMeet\"'+
        ' },'+
        ' \"name\": \"Google Meet\",'+
        ' \"iconUri\": \"https://fonts.gstatic.com/s/i/productlogos/meet_2020q4/v6/web-512dp/logo_meet_2020q4_color_2x_web_512dp.png\"'+
        ' },'+
        '  \"conferenceId\": \"frt-svan-mmd\",'+
        ' \"signature\": \"AKpSKUtkjYiN3ipi5FFIBKTgB8DH\"'+
        ' },'+
        ' \"reminders\": {'+
        '  \"useDefault\": true'+
        ' },'+
        ' \"eventType\": \"default\"'+
        '}';
        JSON2Apex r = JSON2Apex.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.Status objStatus = new JSON2Apex.Status(System.JSON.createParser(json));
        System.assert(objStatus != null);
        System.assert(objStatus.statusCode == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.ConferenceData objConferenceData = new JSON2Apex.ConferenceData(System.JSON.createParser(json));
        System.assert(objConferenceData != null);
        System.assert(objConferenceData.createRequest == null);
        System.assert(objConferenceData.entryPoints == null);
        System.assert(objConferenceData.conferenceSolution == null);
        System.assert(objConferenceData.conferenceId == null);
        System.assert(objConferenceData.signature == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.ConferenceSolutionKey objConferenceSolutionKey = new JSON2Apex.ConferenceSolutionKey(System.JSON.createParser(json));
        System.assert(objConferenceSolutionKey != null);
        System.assert(objConferenceSolutionKey.type == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.Reminders objReminders = new JSON2Apex.Reminders(System.JSON.createParser(json));
        System.assert(objReminders != null);
        System.assert(objReminders.useDefault == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex objJSON2Apex = new JSON2Apex(System.JSON.createParser(json));
        System.assert(objJSON2Apex != null);
        System.assert(objJSON2Apex.kind == null);
        System.assert(objJSON2Apex.etag == null);
        System.assert(objJSON2Apex.id == null);
        System.assert(objJSON2Apex.status == null);
        System.assert(objJSON2Apex.htmlLink == null);
        System.assert(objJSON2Apex.created == null);
        System.assert(objJSON2Apex.updated == null);
        System.assert(objJSON2Apex.summary == null);
        System.assert(objJSON2Apex.creator == null);
        System.assert(objJSON2Apex.organizer == null);
        System.assert(objJSON2Apex.start == null);
        System.assert(objJSON2Apex.end_Z == null);
        System.assert(objJSON2Apex.iCalUID == null);
        System.assert(objJSON2Apex.sequence == null);
        System.assert(objJSON2Apex.attendees == null);
        System.assert(objJSON2Apex.hangoutLink == null);
        System.assert(objJSON2Apex.conferenceData == null);
        System.assert(objJSON2Apex.reminders == null);
        System.assert(objJSON2Apex.eventType == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.ConferenceSolution objConferenceSolution = new JSON2Apex.ConferenceSolution(System.JSON.createParser(json));
        System.assert(objConferenceSolution != null);
        System.assert(objConferenceSolution.key == null);
        System.assert(objConferenceSolution.name == null);
        System.assert(objConferenceSolution.iconUri == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.Start objStart = new JSON2Apex.Start(System.JSON.createParser(json));
        System.assert(objStart != null);
        System.assert(objStart.dateTime_Z == null);
        System.assert(objStart.timeZone == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.CreateRequest objCreateRequest = new JSON2Apex.CreateRequest(System.JSON.createParser(json));
        System.assert(objCreateRequest != null);
        System.assert(objCreateRequest.requestId == null);
        System.assert(objCreateRequest.conferenceSolutionKey == null);
        System.assert(objCreateRequest.status == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.Attendees objAttendees = new JSON2Apex.Attendees(System.JSON.createParser(json));
        System.assert(objAttendees != null);
        System.assert(objAttendees.email == null);
        System.assert(objAttendees.displayName == null);
        System.assert(objAttendees.responseStatus == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.Creator objCreator = new JSON2Apex.Creator(System.JSON.createParser(json));
        System.assert(objCreator != null);
        System.assert(objCreator.email == null);
        System.assert(objCreator.self == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.EntryPoints objEntryPoints = new JSON2Apex.EntryPoints(System.JSON.createParser(json));
        System.assert(objEntryPoints != null);
        System.assert(objEntryPoints.entryPointType == null);
        System.assert(objEntryPoints.uri == null);
        System.assert(objEntryPoints.label == null);
    }
}