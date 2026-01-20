({
    handleSave: function(component, event, helper) {
        // debugger;
        if (component.find("fuploader").get("v.files") && component.find("fuploader").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },

    doInit: function(component, event, helper) {
        // debugger;
        helper.getPic(component, event, helper);
    },

    handleFilesChange: function(component, event, helper) {

        const reader = new FileReader();
        reader.addEventListener('load', (event) => {
            // debugger;
            var src = event.target.result;
            var ext = src.split(';')[0].split('/')[1];
            component.set('v.photoExt', ext);
            component.set('v.sourceData', src);
        });
        reader.readAsDataURL(component.find("fuploader").get("v.files")[0]);
    },

})