({
	getEducationPicklistValues: function(component, event) {
        
        var action = component.get("c.getEducationFieldValue");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var fieldMap = [];
                for(var key in result){
                    fieldMap.push({key: key, value: result[key]});
                }
                component.set("v.fieldMapEducation", fieldMap);
                console.log(fieldMap);
            }
        });
        $A.enqueueAction(action);
		
	},
    getOccupationPicklistValues: function(component, event) {
        
        var action = component.get("c.getOccupationFieldValue");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var fieldMap = [];
                for(var key in result){
                    fieldMap.push({key: key, value: result[key]});
                }
                component.set("v.fieldMapOccupation", fieldMap);
            }
        });
        $A.enqueueAction(action);
		
	},
    getHowPicklistValues: function(component, event) {
        
        var action = component.get("c.getHearabValue");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var fieldMap = [];
                for(var key in result){
                    fieldMap.push({key: key, value: result[key]});
                }
                component.set("v.fieldMapHow", fieldMap);
            }
        });
        $A.enqueueAction(action);
		
	},
     Search: function(component, event) {
        console.log('v.enqno', component.get("v.enqno"));
        console.log('v.orgcode', component.get("v.orgcode"));
        console.log('v.leadid', component.get("v.leadid"));
        var action = component.get("c.getEnqDetails");
          action.setParams({
                "enqno": component.get("v.enqno"),
                "orgcode": component.get("v.orgcode"),
              "leadid":component.get("v.leadid"),
              "enqid":component.get("v.Enqid")
            });
        action.setCallback(this, function(response) {
             component.set("v.isEditable",false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var reqResponse = response.getReturnValue();
                console.log(reqResponse);
              if( reqResponse.NoRecord=="0" || reqResponse.NoRecord=="2")
              {
                  component.set("v.isError",true);
                  component.set( "v.result",false);
                  //component.set("v.isSuccess",false);
                  if(reqResponse.NoRecord=="0"){
                  component.set("v.errorMsg", 'Enquiry number not found, Please use below alternates');
                  }
                   if(reqResponse.NoRecord=="2"){
                  component.set("v.errorMsg", 'Enquiry number not found, Please use below alternates');
                  }
                  
                 
              }
                 if(reqResponse.NoRecord=="1"){
                     if(reqResponse.Demographic)
                     {
                       component.set("v.isEditable",true);
                
                     }
                     else
                     {
                         component.set("v.isEditable",false);
                     }
                     console.log(reqResponse.cfName);
                        component.set("v.isError",false);
                   component.set("v.isSuccess",false);
                     component.set("v.cfName",reqResponse.cfName);
                     component.set("v.cLName",reqResponse.cLName);
                    component.set("v.dob",reqResponse.dob);
                    component.set("v.gender",reqResponse.gender);
                    component.set("v.mobileno",reqResponse.mobileno);
                     component.set("v.email",reqResponse.email);
                     component.set("v.leadname",reqResponse.leadname);
                     component.set("v.grade",reqResponse.grade);
                      component.set("v.id",reqResponse.id);
                     component.set("v.Relation",reqResponse.Relation);
                     
                      component.set("v.enq.Demographic_Pin_code__c",reqResponse.Pin);
                    component.set("v.enq.Apartment_Society__c",reqResponse.Appartment);
                     component.set("v.enq.Locality__c",reqResponse.Locality);
                     component.set("v.enq.Mother_s_Educational_Qualifications__c",reqResponse.MEducation);
                     component.set("v.enq.Father_s_Educational_Qualifications__c",reqResponse.FEducation);
                      component.set("v.enq.Current_school__c",reqResponse.Cschool); //NP_Finesse060324
                    //  component.set("v.enq.Mother_s_Educational_Qualifications__c",reqResponse.id);
                     
                     component.set("v.enq.Father_s_Occupation__c",reqResponse.Foccupation);
                     component.set("v.enq.Mother_s_Occupation__c",reqResponse.Moccupation);
                      component.set("v.enq.Mother_Other_Occupation__c",reqResponse.MotherOther);
                     component.set("v.enq.FatherOther_Occupation__c",reqResponse.FatherOther);
                     component.set("v.enq.How_did_you_hear_about_us__c",reqResponse.How);
                     console.log(reqResponse.id);
                     
                  }
               
            }
        });
        $A.enqueueAction(action);
		
	},
    GetImage: function(component, event) {
        
        var action = component.get("c.GetImage");
         action.setParams({"rId":component.get("v.orgcode") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result ="$Resource." +  response.getReturnValue();
               
                console.log(result);
                component.set("v.imageName", $A.get(result));
                console.log(component.get("v.imageName"));
            }
        });
        $A.enqueueAction(action);
		
	},
})