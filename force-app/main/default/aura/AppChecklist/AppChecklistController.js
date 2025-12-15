({
    doInit : function(component, event, helper) {
        //debugger
        var objEnq = component.get('v.enquiryObj')
        console.log('objENq  ', objEnq);
        var action = component.get('c.getChecklist');
        action.setParams({'eid': component.get("v.parentId")});
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                for (var a of result.getReturnValue()) {
                    console.log(a.Description__c);
                    a.checked = false;
                    if (a.Description__c.includes('Form C')) {
                        a.checked = objEnq.C === 'true';
                    }
                    else if (a.Description__c.includes('Form-D')) {
                        a.checked = objEnq.D === 'true';
                    }
                    else if (a.Description__c.includes('Form E-1')) {
                        a.checked = objEnq.E1 === 'true';
                    }
                    else if (a.Description__c.includes('Form E-2')) {
                        a.checked = objEnq.E2 === 'true';
                    }
                    console.log(a.checked);
                }
                component.set('v.checklistWrapper', result.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    handleClick : function(component, event, helper) {
        //debugger
        component.set("v.isModalOpen", true);
        var studentNameToShow = '';
        var parentNamesToShowFormC = '';
        var fatherName;
        var motherName;
        var str = '';
        var guardianName;
        var pictureSrcURL='';
        var data = component.get('v.data');
        var index = event.currentTarget.name;
        var formWrapper = component.get("v.checklistWrapper");
        component.set('v.popupHeading',formWrapper[index].Description__c);
        component.set('v.isFormC', false);
        if (formWrapper[index].Description__c.includes('Form C') || formWrapper[index].Description__c.includes('Form H')) {
            if (data) {
                if (data['NameStudent']) {
                    studentNameToShow = data['NameStudent'];
                    component.set('v.studentNameToShow', data['NameStudent']);
                }
                if (data['FirstNameFather'] && data['LastNameFather']) {
                    fatherName = data['FirstNameFather'] + ' ' + data['LastNameFather']
                }
                if (data['FirstNameMother'] && data['LastNameMother']) {
                    motherName = data['FirstNameMother'] + ' ' + data['LastNameMother']
                }
                if (data['NameGuardian']) {
                    guardianName = data['NameGuardian']
                }
                if (fatherName) {
                    parentNamesToShowFormC = fatherName;
                    if (motherName) {
                        if (guardianName) {
                            parentNamesToShowFormC = fatherName + ' &  ' + motherName + ' & ' + guardianName
                        }else {
                            parentNamesToShowFormC = fatherName + ' &  ' + motherName
                        }
                    }
                    if (guardianName) {
                        parentNamesToShowFormC += ' & ' + guardianName;
                    }
                }
                if (!fatherName && motherName) {
                    parentNamesToShowFormC = motherName
                    if (guardianName) {
                        parentNamesToShowFormC = motherName + ' & ' + guardianName
                    }
                }
                if (guardianName && !fatherName && !motherName) {
                    parentNamesToShowFormC = guardianName
                }
                component.set('v.isFormC', true);
                str = "We <b> "+parentNamesToShowFormC+"</b>  parents/guardians of <b> " + studentNameToShow +" </b>";
                if (formWrapper[index].Description__c === 'Form C1') {
                    str = "To,<br>" + data['NameSchool'] +  "<br>" +
                        "We <b> "+parentNamesToShowFormC+"</b>  parents/guardians of <b> " + studentNameToShow +" </b>";
                }
                if (!formWrapper[index].Terms__c.includes(str)) {
                    formWrapper[index].Terms__c = str + formWrapper[index].Terms__c;
                }
  
                // formWrapper[index].Terms__c = str + formWrapper[index].Terms__c;
                component.set('v.parentNamesToShowFormC', parentNamesToShowFormC);
            }
        }
        component.set('v.currentIndex',index);
        component.set('v.popupBody',formWrapper[index].Terms__c);
        component.set('v.pictureSrcURL',formWrapper[index].School_Institution_Logo_URL__c);
    },

    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    populateFormCheckbox: function(component, event, helper) {
        //debugger;
        var currentRec = component.get("v.checklistWrapper")[event.target.name];
        //alert(currentRec);
        var value = currentRec.checked;
        var fieldName = currentRec.Description__c;
        var action = component.get('c.setCheckbox');
        action.setParams({
             'eid': component.get("v.parentId"),
             'fieldName' : fieldName,
             'value' : value
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS") {

            }
        });
        $A.enqueueAction(action);
    },
    agreeTerms: function(component, event, helper) {
        //debugger
        var currentCheckbox = component.get('v.currentIndex');
        var formWrapper = component.get("v.checklistWrapper");
        formWrapper[currentCheckbox].checked = true;

        component.set("v.checklistWrapper", formWrapper);
        component.set("v.isModalOpen", false);
    },
    selectChange : function(component, event, helper) {
        console.log('in select change');
        var checkCmp = event.getSource();
        //alert(checkCmp);
        checkCmp.set("v.value",true);
    },
    agreeCancel : function(component, event, helper){
        component.set("v.isModalOpen", false);
    }
    
})