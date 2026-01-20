({
    uploadHelper : function(component, event) {
        component.set('v.loadMessage', 'Uploading')
        var file = component.find("fuploader").get("v.files")[0];


         const reader = new FileReader();
        reader.addEventListener('load', (event) => {
            // debugger;
            var src = event.target.result;
            this.upload(component, file, src.match(/,(.*)$/)[1])
        });
        reader.readAsDataURL(file);
    },

    getPic: function (component, event, helper) {
        // debugger
        var id = component.get('v.parentId');
        var name = component.get('v.photoName');
        // console.log(name);
        try {
            if (name) {
                // console.log('sendingparams for getpic ', {  parent: id.toString(), photoName: name  })
            }

        var action = component.get('c.getPic');
        action.setParams({
            parent : id.toString(),
            photoName: name
        });
        action.setCallback(this, function(response) {
            // debugger;
            // var url = 'https://universaleducation--newdev--c.cs57.content.force.com/servlet/servlet.FileDownload?file=';
            var state = response.getState();
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                // console.log('success', data);
                if (data && data.length > 0) {
                    component.set('v.sourceData', data);
                }
            }
            else {
                console.log('error',response.getError());
            }
        })
        } catch (error) {
            console.log(error);
        }
        $A.enqueueAction(action)
    },

    upload: function(component, file, base64Data) {
        var action = component.get("c.saveAttachment");
        // console.log('setting params');
        // console.table({
        //     parentId: component.get("v.parentId"),
        //     fileName: component.get('v.photoName'),
        //     base64Data: base64Data,
        //     contentType: file.type,
        //     ext: component.get('v.photoExt')
        // });
        action.setParams({
            parentId: component.get("v.parentId"),
            fileName: component.get('v.photoName')  ,
            base64Data: base64Data,
            contentType: file.type,
            ext: component.get('v.photoExt')
        });
        action.setCallback(this, function(response) {
            //component.set("v.message", "Image uploaded");
            // console.log('Returned Data', response)
            var state = response.getState();
            if(state === 'SUCCESS') {
                component.set('v.loadMessage', 'Upload Successful')
            } else {
                component.set('v.loadMessage', 'Upload Failed')
            }
        });
        //component.set("v.message", "Uploading...");
        $A.enqueueAction(action);
    }

})