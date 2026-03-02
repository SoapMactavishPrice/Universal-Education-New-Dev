@RestResource(urlMapping='/ozonetal/create/task')
global class OzonetalCreateTaskApi {
    
    @HttpPost
    global static void doPost() {
        
        API_log__c api_log = new API_log__c();
        api_log.Name = 'OzonetelCreateTask';
        api_log.Apex_Class_Name__c = 'OzonetelCreateTask_API';
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        String requestBody = request.requestBody.toString().replace('\n', '');
        
        api_log.Request_Body__c = requestBody;
        api_log.Request_Date_and_Time__c = Datetime.now();
        
        TaskModel taskObj = TaskModel.parse(requestBody);
        system.debug('taskObj: ' + taskObj);
        
        try {
            
            Map<String, Object> responseDataMap = new Map<String, Object>();
            
            if (String.isBlank(taskObj.mobileNumber)) {
                throw new IllegalArgumentException('Mobile number cannot be blank');
            }

            String cleanedMobile = taskObj.mobileNumber.replaceAll('[^0-9]', '');
            String likePattern = '%' + cleanedMobile + '%';
            
            List<Lead> leadList = [
                SELECT Id, Name, MobilePhone 
                FROM Lead 
                WHERE MobilePhone LIKE :likePattern
                AND Company = 'Ozonetel Lead'
                LIMIT 1
            ];
            
            if (leadList.isEmpty()) {
                throw new IllegalArgumentException('No Lead found with mobile number: ' + taskObj.mobileNumber);
            }
            
            Lead foundLead = leadList[0];
            
            Task newTask = new Task();
            
            newTask.WhoId = foundLead.Id;
            
            newTask.Subject = String.isNotBlank(taskObj.subject) ? taskObj.subject : 'Call Task';
            newTask.Status = String.isNotBlank(taskObj.status) ? taskObj.status : 'Completed';
            
            if (String.isNotBlank(taskObj.priority)) {
                newTask.Priority = taskObj.priority;
            }
            
            newTask.Subject = 'Missed CTI Lead';
            newTask.Priority = 'Normal';
            newTask.Status = 'Completed';
            newTask.Agent_Status__c = taskObj.agentStatus;
            newTask.AgentId__c = taskObj.agentId;
            newTask.agentNumber__c = taskObj.agentNumber;
            newTask.CallBackTime__c = taskObj.callBackTime;
            newTask.CallEndTime__c = taskObj.callEndTime;
            newTask.CallObject__c = taskObj.callObject;
            newTask.CallStartTime__c = taskObj.callStartTime;
            newTask.callType__c = taskObj.callType;
            newTask.Campaign_Name__c = taskObj.campaignName;
            newTask.Customer_Status__c = taskObj.customerStatus;
            newTask.DID__c = taskObj.did;
            newTask.Disposition__c = taskObj.disposition;
            newTask.Disposition_Description__c = taskObj.dispositionDescription;
            newTask.Duration__c = taskObj.duration;
            newTask.MonitorUcid__c = taskObj.monitorUcid;
            newTask.AudioFile__c = taskObj.audioFile;
            newTask.School_Code__c = taskObj.schoolCode;
            newTask.Skill_Name__c = taskObj.skillName;
            newTask.Transfer_Type__c = taskObj.transferType;
            newTask.TransferTo__c = taskObj.transferTo;
            newTask.ucid__c = taskObj.ucid;
            newTask.UUI__c = taskObj.uui;
            newTask.Call_Status__c = taskObj.callStatus;
            
            insert newTask;
            
            responseDataMap.put('status', 'success');
            responseDataMap.put('message', 'Task Created Successfully');
            responseDataMap.put('taskId', newTask.Id);
            responseDataMap.put('leadId', foundLead.Id);
            responseDataMap.put('leadName', foundLead.Name);
            
            api_log.Response_Body__c = JSON.serialize(responseDataMap);
            api_log.API_Log_Status__c = 'Success';
            api_log.Response_Code__c = '200';
            
            response.addHeader('Content-Type', 'application/json');
            response.responseBody = Blob.valueOf(JSON.serialize(responseDataMap));
            response.statusCode = 200;
            
        } catch (Exception e) {
            Map<String, Object> responseDataMap = new Map<String, Object>();
            
            responseDataMap.put('status', 'Fail');
            responseDataMap.put('message', e.getMessage());
            
            response.responseBody = Blob.valueOf(JSON.serialize(responseDataMap));
            response.addHeader('Content-Type', 'application/json');
            response.statusCode = 400;
            
            system.debug(e.getlineNumber() + '-' + e.getMessage());
            
            api_log.Response_Body__c = e.getlineNumber() + ' || ' + e.getMessage();
            api_log.API_Log_Status__c = 'Failure';
            api_log.Response_Code__c = '400';
        }
        
        api_log.Response_Date_and_Time__c = Datetime.now();
        insert api_log;
    }
    
    public class TaskModel {
        public String mobileNumber;
        
        public String subject;
        public String status;
        public String priority;
        public String callStatus;
        
        public String agentStatus;
        public String agentId;
        public Decimal agentNumber;
        public DateTime callBackTime;
        public DateTime callEndTime;
        public String callObject;
        public DateTime callStartTime;
        public String callType;
        public String campaignName;
        public String customerStatus;
        public String did;
        public String disposition;
        public String dispositionDescription;
        public Decimal duration;
        public String monitorUcid;
        public String audioFile;
        public String schoolCode;
        public String skillName;
        public String transferType;
        public String transferTo;
        public String ucid;
        public String uui;
    }
    
    public static TaskModel parse(String json) {
        return (TaskModel) System.JSON.deserialize(json, TaskModel.class);
    }
}