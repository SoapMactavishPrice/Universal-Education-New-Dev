@RestResource(urlMapping = '/getLeadDetails')
global class getLeadDetailsAPI {
    
    @HttpGet
    global static void doGet() {
        
        API_log__c api_log = new API_log__c();
        api_log.Name = 'getLeadDetails';
        api_log.Apex_Class_Name__c = 'getLeadDetailsAPI';
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        String jSONRequestBody = request.requestBody.toString().replace('\n', '');
        
        api_log.Request_Body__c = jSONRequestBody;
        api_log.Request_Date_and_Time__c = Datetime.now();
        
        JSON2ApexData jsonObj = JSON2ApexData.parse(jSONRequestBody);
        system.debug('jsonObj'+jsonObj);
        
        try {
            
            Map<String, Object> responseDataMap = new Map<String, Object>();
            
            if (String.isBlank(jsonObj.customerNumber) || String.isBlank(jsonObj.DIDNumber)) {
                throw new IllegalArgumentException('customerNumber and DIDNumber cannot be blank');
            } else {
                
                String schoolShortCode = '';
                String schoolSkillCode = '';
                
                List <Account> schoolList = [
                    SELECT Id, Name, School_Short_Code__c, Centralized_Calling_Team__c, Skill_Name__c
                    FROM Account
                    WHERE DID_Number__c = :jsonObj.DIDNumber
                    LIMIT 1
                ];
                
                if (schoolList.size() > 0) {
                    
                    schoolShortCode = schoolList[0].School_Short_Code__c;
                    schoolSkillCode = schoolList[0].Skill_Name__c;
                    
                    List<User> centralTeamList = [
                        SELECT Id, Name, Email, Phone
                        FROM User WHERE
                        Profile.Name = 'Communication Executive (CE)'
                        AND IsActive = true
                    ];
                    
                    List<Map<String,String>> centralTeamDetailMapList = new List<Map<String,String>>();
                    
                    for (User usr : centralTeamList) {
                        Map<String, String> mapName = new Map<String, String>();
                        mapName.put('Name', usr.Name);
                        mapName.put('Email', usr.Email);
                        mapName.put('Phone', usr.Phone);
                        centralTeamDetailMapList.add(mapName);
                    }
                    
                    List<Lead> leadList = [
                        SELECT Id, Name, School_Short_Code__c, MobilePhone, Meet_Done__c, Owner.Name, Owner.Email, Owner.Phone
                        FROM Lead
                        WHERE MobilePhone = :jsonObj.customerNumber
                        AND School_Short_Code__c = :schoolShortCode
                    ];
                    
                    if (leadList.size() > 0)  {
                        if (schoolList[0].Centralized_Calling_Team__c) {
                            // Map<String, String> schoolTeamDetailMap = new Map<String, String>();
                            responseDataMap.put('Name', leadList[0].Owner.Name);
                            responseDataMap.put('Email', leadList[0].Owner.Email);
                            responseDataMap.put('Phone', leadList[0].Owner.Phone);
                            if (leadList[0].Meet_Done__c) {
                                // responseDataMap.put('SchoolTeam', schoolTeamDetailMap);
                                responseDataMap.put('SkillName', schoolSkillCode);
                            } else {
                                // responseDataMap.put('CentralTeam', schoolTeamDetailMap);
                                responseDataMap.put('SkillName', 'Central_Team');
                            }
                        } else {
                            // Map<String, String> schoolTeamDetailMap = new Map<String, String>();
                            responseDataMap.put('Name', leadList[0].Owner.Name);
                            responseDataMap.put('Email', leadList[0].Owner.Email);
                            responseDataMap.put('Phone', leadList[0].Owner.Phone);
                            // schoolTeamDetailMap.put('SchoolShortCode', leadList[0].School_Short_Code__c);
                            responseDataMap.put('SkillName', schoolSkillCode);
                            // responseDataMap.put('SchoolTeam', schoolTeamDetailMap);
                        }
                        responseDataMap.put('Type', 'Existing');
                        // responseDataMap.put('LeadId', leadList[0].Id);
                        responseDataMap.put('LeadName', leadList[0].Name);
                    } else {
                        responseDataMap.put('Type', 'New');
                        // responseDataMap.put('CentralTeam', centralTeamDetailMapList);
                        if (schoolList[0].Centralized_Calling_Team__c) {
                            responseDataMap.put('SkillName', 'Central_Team');
                        } else {
                            responseDataMap.put('SkillName', schoolSkillCode);
                        }
                    }
                    responseDataMap.put('status', 'Success');
                    
                } else {
                    throw new IllegalArgumentException('DIDNumber '+jsonObj.DIDNumber+ ' is not associated to any school');  
                }
                
                // if (schoolList.size() > 0) {
                
                //     schoolShortCode = schoolList[0].School_Short_Code__c;
                
                //     List<User> centralTeamList = [
                //         SELECT Id, Name, Email, Phone
                //         FROM User WHERE
                //         Profile.Name = 'Communication Executive (CE)'
                //         AND IsActive = true
                //     ];
                
                //     List<Map<String,String>> centralTeamDetailMapList = new List<Map<String,String>>();
                
                //     List<Lead> leadList = [
                //         SELECT Id, Name, School_Short_Code__c, MobilePhone, Meet_Done__c, Owner.Name, Owner.Email, Owner.Phone
                //         FROM Lead
                //         WHERE MobilePhone = :jsonObj.customerNumber
                //         AND School_Short_Code__c = :schoolShortCode
                //     ];
                
                //     if (leadList.size() > 0)  {
                //         if (leadList[0].Meet_Done__c) {
                //             responseDataMap.put('Name', leadList[0].Owner.Name);
                //             responseDataMap.put('Email', leadList[0].Owner.Email);
                //             responseDataMap.put('Phone', leadList[0].Owner.Phone);
                //         } else {
                //             responseDataMap.put('Name', centralTeamList[0].Name);
                //             responseDataMap.put('Email', centralTeamList[0].Email);
                //             responseDataMap.put('Phone', centralTeamList[0].Phone);
                //         }
                //         // responseDataMap.put('Type', 'Existing');
                //         // responseDataMap.put('LeadId', leadList[0].Id);
                //         // responseDataMap.put('LeadName', leadList[0].Name);
                //     } else {
                //         // responseDataMap.put('Type', 'New');
                //         responseDataMap.put('Name', centralTeamList[0].Name);
                //         responseDataMap.put('Email', centralTeamList[0].Email);
                //         responseDataMap.put('Phone', centralTeamList[0].Phone);
                //     }
                //     // responseDataMap.put('status', 'Success');
                
                // } else {
                //   throw new IllegalArgumentException('DIDNumber '+jsonObj.DIDNumber+ ' is not associated to any school');  
                // }
                
                // responseDataMap.put('status','success');
                response.addHeader('Content-Type', 'application/json');
                response.responseBody = Blob.valueOf(JSON.serialize(responseDataMap));
                response.statusCode = 200;
            }
            
        } catch (Exception e) {
            Map < String, Object > responseDataMap = new Map < String, Object > ();
            
            responseDataMap.put('status', 'Fail');
            responseDataMap.put('message', e.getMessage());
            responseDataMap.put('message2', e.getLineNumber());
            response.responseBody = Blob.valueOf(JSON.serialize(responseDataMap));
            response.addHeader('Content-Type', 'application/json');
            response.statusCode = 400;
            system.debug(e.getlineNumber()+'-'+e.getMessage());
            
            api_log.Response_Body__c = e.getlineNumber()+' || '+e.getMessage();
            api_log.API_Log_Status__c = 'Failure';
            api_log.Response_Code__c = '400';
        }
        
        api_log.Response_Date_and_Time__c = Datetime.now();
        insert api_log;
        
    }
    
    public class JSON2ApexData {
        public String customerNumber;
        public String DIDNumber;
    }
    
    public static JSON2ApexData parse(String json) {
        return (JSON2ApexData) System.JSON.deserialize(json, JSON2ApexData.class);
    }
    
}