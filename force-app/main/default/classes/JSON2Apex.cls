public class JSON2Apex {

    public class Status {
        public String statusCode {get;set;} 

        public Status(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'statusCode') {
                            statusCode = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Status consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ConferenceData {
        public CreateRequest createRequest {get;set;} 
        public List<EntryPoints> entryPoints {get;set;} 
        public ConferenceSolution conferenceSolution {get;set;} 
        public String conferenceId {get;set;} 
        public String signature {get;set;} 

        public ConferenceData(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'createRequest') {
                            createRequest = new CreateRequest(parser);
                        } else if (text == 'entryPoints') {
                            entryPoints = arrayOfEntryPoints(parser);
                        } else if (text == 'conferenceSolution') {
                            conferenceSolution = new ConferenceSolution(parser);
                        } else if (text == 'conferenceId') {
                            conferenceId = parser.getText();
                        } else if (text == 'signature') {
                            signature = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ConferenceData consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ConferenceSolutionKey {
        public String type {get;set;} 

        public ConferenceSolutionKey(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ConferenceSolutionKey consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Reminders {
        public Boolean useDefault {get;set;} 

        public Reminders(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'useDefault') {
                            useDefault = parser.getBooleanValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Reminders consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public String kind {get;set;} 
    public String etag {get;set;} 
    public String id {get;set;} 
    public String status {get;set;} 
    public String htmlLink {get;set;} 
    public String created {get;set;} 
    public String updated {get;set;} 
    public String summary {get;set;} 
    public Creator creator {get;set;} 
    public Creator organizer {get;set;} 
    public Start start {get;set;} 
    public Start end_Z {get;set;} // in json: end
    public String iCalUID {get;set;} 
    public Integer sequence {get;set;} 
    public List<Attendees> attendees {get;set;} 
    public String hangoutLink {get;set;} 
    public ConferenceData conferenceData {get;set;} 
    public Reminders reminders {get;set;} 
    public String eventType {get;set;} 

    public JSON2Apex(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'kind') {
                        kind = parser.getText();
                    } else if (text == 'etag') {
                        etag = parser.getText();
                    } else if (text == 'id') {
                        id = parser.getText();
                    } else if (text == 'status') {
                        status = parser.getText();
                    } else if (text == 'htmlLink') {
                        htmlLink = parser.getText();
                    } else if (text == 'created') {
                        created = parser.getText();
                    } else if (text == 'updated') {
                        updated = parser.getText();
                    } else if (text == 'summary') {
                        summary = parser.getText();
                    } else if (text == 'creator') {
                        creator = new Creator(parser);
                    } else if (text == 'organizer') {
                        organizer = new Creator(parser);
                    } else if (text == 'start') {
                        start = new Start(parser);
                    } else if (text == 'end') {
                        end_Z = new Start(parser);
                    } else if (text == 'iCalUID') {
                        iCalUID = parser.getText();
                    } else if (text == 'sequence') {
                        sequence = parser.getIntegerValue();
                    } else if (text == 'attendees') {
                        attendees = arrayOfAttendees(parser);
                    } else if (text == 'hangoutLink') {
                        hangoutLink = parser.getText();
                    } else if (text == 'conferenceData') {
                        conferenceData = new ConferenceData(parser);
                    } else if (text == 'reminders') {
                        reminders = new Reminders(parser);
                    } else if (text == 'eventType') {
                        eventType = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class ConferenceSolution {
        public ConferenceSolutionKey key {get;set;} 
        public String name {get;set;} 
        public String iconUri {get;set;} 

        public ConferenceSolution(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'key') {
                            key = new ConferenceSolutionKey(parser);
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'iconUri') {
                            iconUri = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ConferenceSolution consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Start {
        public String dateTime_Z {get;set;} // in json: dateTime
        public String timeZone {get;set;} 

        public Start(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'dateTime') {
                            dateTime_Z = parser.getText();
                        } else if (text == 'timeZone') {
                            timeZone = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Start consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class CreateRequest {
        public String requestId {get;set;} 
        public ConferenceSolutionKey conferenceSolutionKey {get;set;} 
        public Status status {get;set;} 

        public CreateRequest(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'requestId') {
                            requestId = parser.getText();
                        } else if (text == 'conferenceSolutionKey') {
                            conferenceSolutionKey = new ConferenceSolutionKey(parser);
                        } else if (text == 'status') {
                            status = new Status(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'CreateRequest consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Attendees {
        public String email {get;set;} 
        public String displayName {get;set;} 
        public String responseStatus {get;set;} 

        public Attendees(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'displayName') {
                            displayName = parser.getText();
                        } else if (text == 'responseStatus') {
                            responseStatus = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Attendees consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Creator {
        public String email {get;set;} 
        public Boolean self {get;set;} 

        public Creator(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'self') {
                            self = parser.getBooleanValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Creator consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class EntryPoints {
        public String entryPointType {get;set;} 
        public String uri {get;set;} 
        public String label {get;set;} 

        public EntryPoints(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'entryPointType') {
                            entryPointType = parser.getText();
                        } else if (text == 'uri') {
                            uri = parser.getText();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'EntryPoints consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static JSON2Apex parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new JSON2Apex(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    private static List<Attendees> arrayOfAttendees(System.JSONParser p) {
        List<Attendees> res = new List<Attendees>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Attendees(p));
        }
        return res;
    }
    private static List<EntryPoints> arrayOfEntryPoints(System.JSONParser p) {
        List<EntryPoints> res = new List<EntryPoints>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new EntryPoints(p));
        }
        return res;
    }
}