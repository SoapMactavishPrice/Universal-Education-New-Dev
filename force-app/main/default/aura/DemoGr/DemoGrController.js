({
    doInit: function(component, event, helper) {        
        const pageRef = component.get("v.pageReference");
        if (pageRef && pageRef.state && pageRef.state.code) {
            component.set("v.orgcode", pageRef.state.code);
        }

        const orgcode = component.get("v.orgcode");
        console.log("Org Code: " + orgcode);

        // 🔹 Check for specific org codes
        if (orgcode === 'STELRA' || orgcode === 'STELRB' || orgcode === 'STELRG') {
            component.set("v.enquiryLabel", "Enter Curiosity No");
            component.set("v.enquiryIdLabel", "Enter Curiosity id");
            component.set("v.enquiryPrefix", "CUR/2026-2027/");
        } else {
            component.set("v.enquiryLabel", "Enter Enquiry No");
            component.set("v.enquiryIdLabel", "Enter Enquiry Id");
            component.set("v.enquiryPrefix", "ENQ/2026-2027/");
        }

        console.log("Enquiry Prefix: " + component.get("v.enquiryPrefix"));

        // Call helpers
        helper.getEducationPicklistValues(component, event);
        helper.getOccupationPicklistValues(component, event);
        helper.getHowPicklistValues(component, event);
        helper.GetImage(component, event);
    },
    handleSearch:function(component, event, helper) {
        
        helper.Search(component, event);
        
    },
    handlecancel:function(component, event, helper) {
        component.set("v.isSuccess",true);
        component.set( "v.Enqid",'');
        component.set( "v.leadid",'');
        component.set("v.enqno", component.get("v.enquiryPrefix"));
    },
    handleBack:function(component, event, helper) {
        component.set("v.isSuccess",true);
        component.set("v.isError",false);
        component.set( "v.Enqid",'');
        component.set( "v.leadid",'');
        component.set("v.enqno", component.get("v.enquiryPrefix"));
    },
    handleSave : function(component, event, helper) {
        console.log('hi');
        var allValid = component.find('contact').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        var contact2=  component.find('contact2');
        if( contact2.get("v.value")=='')
        {
            contact2.checkValidity();
            contact2.showHelpMessageIfInvalid()
            allValid=false;           
        }
        else{
            if(allValid){
                allValid=true;  
            } 
        }
        var contact3=  component.find('contact3');
        if( contact3.get("v.value")=='')
        {
            contact3.checkValidity();
            contact3.showHelpMessageIfInvalid()
            allValid=false;           
        }
        else{
             if(allValid){
                allValid=true;  
            }  
        }
        var contact4=  component.find('contact4');
        if( contact4.get("v.value")=='')
        {
            contact4.checkValidity();
            contact4.showHelpMessageIfInvalid()
             if(allValid){
                allValid=true;  
            }           
        }
        else{
             if(allValid){
                allValid=true;  
            }    
        }
        var contact5=  component.find('contact5');
        if( contact5.get("v.value")=='')
        {
            contact5.checkValidity();
              contact5.showHelpMessageIfInvalid()
             if(allValid){
                allValid=true;  
            }          
        }
        else{
             if(allValid){
                allValid=true;  
            }   
        }
        var contact6=  component.find('contact6');
        if( contact6.get("v.value")=='')
        {
            contact6.checkValidity();
            contact6.showHelpMessageIfInvalid()
            allValid=false;           
        }
        else{
            if(allValid){
                allValid=true;  
            }  
        }
        
        if (allValid) {
            var currentAcc = component.get("v.enq");
            var action = component.get("c.UpdateDemo");
            console.log(JSON.stringify(currentAcc));
            action.setParams({ "re" : currentAcc,"rId":component.get("v.id") });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);;
                if (state === "SUCCESS") {
                    var reqResponse = response.getReturnValue();
                    console.log(reqResponse);
                    if(reqResponse=="true")
                    {
                        component.set( "v.isError",true);
                        component.set( "v.result",true);
                         component.set( "v.Enqid",'');
                        component.set( "v.leadid",'');
                        component.set( "v.enqno",'ENQ/2026-2027/');
                        
                    }else
                    {
                        component.set("v.errorMsg", 'Somthing went wrong');
                        component.set("v.isError",true);
                        component.set( "v.result",false);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    }
})