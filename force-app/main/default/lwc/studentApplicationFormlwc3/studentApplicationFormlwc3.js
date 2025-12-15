import { LightningElement, api, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import StellarWatermark from "@salesforce/resourceUrl/StellarWatermark";
import EIS_Watermark from "@salesforce/resourceUrl/EIS_Watermark";
import Primus_Watermark from "@salesforce/resourceUrl/Primus_Watermark";
import Universal_Watermark from "@salesforce/resourceUrl/Universal_Watermark";
import Alpha_Watermark from "@salesforce/resourceUrl/Alpha_Watermark";
import IHS_Watermark from "@salesforce/resourceUrl/IHS_Watermark";

import getEnquiryObject from '@salesforce/apex/StudentApplicationFormController.getEnquiryObject';
import getApplicationFormId from '@salesforce/apex/StudentApplicationFormController.getApplicationFormId';
import saveStudentInfoPage3 from '@salesforce/apex/StudentApplicationFormController.saveStudentInfoPage3';
import getDocumentValidations from '@salesforce/apex/StudentApplicationFormController.getDocumentValidations';
import getUploadedDocumentsInPage3 from '@salesforce/apex/StudentApplicationFormController.getUploadedDocumentsInPage3';
import getDisclosure from '@salesforce/apex/StudentApplicationFormController.getDisclosure';

export default class StudentApplicationFormlwc extends LightningElement {

    @api eid;

    @track leadId;

    @track applicationFormId;

    @api currentStep;

    @api schoolLogo;

    @track stellarWatermark;

    @api schoolCard;

    @track formData = {};

    @track enquiryObject = {};

    @track disclosureHtmlObject = {};

    @track documentValidations;

    @track documentUploadObject = {
        isSingleParentFather:false,
        isSingleParentMother:false,
        isStudentPhotoUploaded: false,
        isFatherPhotoUploaded: false,
        isMotherPhotoUploaded: false,
        isFatherSignatureUploaded: false,
        isMotherSignatureUploaded: false
    };

    @track isMobile = false;

    @track isSaveClicked = false;

    @track studentFiles = {
        studentPhoto: null,
        fatherPhoto: null,
        motherPhoto: null,
        fatherSignature: null,
        motherSignature: null
    };

    @track isModalOpen = false;

    @track acceptedFormats = ['.png', '.jpg', '.jpeg'];

    @track isFormC1ModalOpen = false;
    @track isFormCModalOpen = false;
    @track isFormDModalOpen = false;
    @track isFormE1ModalOpen = false;
    @track isFormE2ModalOpen = false;

    @track isFormC1Agreed = false;
    @track isFormCAgreed = false;
    @track isFormDAgreed = false;
    @track isFormE1Agreed = false;
    @track isFormE2Agreed = false;

    @track disableAgreeFormC1 = true;
    @track disableAgreeFormC = true;
    @track disableAgreeFormD = true;
    @track disableAgreeFormE1 = true;
    @track disableAgreeFormE2 = true;

    get waterMarkClass() {
        return this.isMobile ? 'watermarkMobile' : 'watermark';
    }

    get uploadDivClass() {
        return this.isMobile ? "slds-box slds-align_absolute-center" : "slds-box slds-align_absolute-center"
    }

    get itemSize() {
        return this.isMobile ? '12' : '10';
    }

    get showFormC1() {
        return this.disclosureHtmlObject.formC1;
    }
    get showFormC() {
        return this.disclosureHtmlObject.formC;
    }
    get showFormD() {
        return this.disclosureHtmlObject.formD;
    }
    get showFormE1() {
        return this.disclosureHtmlObject.formE1;
    }
    get showFormE2() {
        return this.disclosureHtmlObject.formE2;
    }

    get formC1Name() {
        return this.disclosureHtmlObject.formC1?.name;
    }
    get formCName() {
        return this.disclosureHtmlObject.formC?.name;
    }
    get formDName() {
        return this.disclosureHtmlObject.formD?.name;
    }
    get formE1Name() {
        return this.disclosureHtmlObject.formE1?.name;
    }
    get formE2Name() {
        return this.disclosureHtmlObject.formE2?.name;
    }

    /**
     * Success Message
     */
    get showStudentPhotoUploadedText() {
        return this.documentUploadObject.isStudentPhotoUploaded || (this.studentFiles.studentPhoto != null && 'fileName' in this.studentFiles.studentPhoto && 'base64' in this.studentFiles.studentPhoto);
    }
    get showFatherPhotoUploadedText() {
        return this.documentUploadObject.isFatherPhotoUploaded || (this.studentFiles.fatherPhoto != null && 'fileName' in this.studentFiles.fatherPhoto && 'base64' in this.studentFiles.fatherPhoto);
    }
    get showMotherPhotoUploadedText() {
        return this.documentUploadObject.isMotherPhotoUploaed || (this.studentFiles.motherPhoto != null && 'fileName' in this.studentFiles.motherPhoto && 'base64' in this.studentFiles.motherPhoto);
    }
    get showFatherSignUploadedText() {
        return this.documentUploadObject.isFatherSignatureUploaded || (this.studentFiles.fatherSignature != null && 'fileName' in this.studentFiles.fatherSignature && 'base64' in this.studentFiles.fatherSignature);
    }
    get showMotherSignUploadedText() {
        return this.documentUploadObject.isMotherSignatureUploaded || (this.studentFiles.motherSignature != null && 'fileName' in this.studentFiles.motherSignature && 'base64' in this.studentFiles.motherSignature);
    }

    /**
     * Validations
     */
    get showStudentPhotoValidation() {
        return this.isSaveClicked && !this.showStudentPhotoUploadedText;
    }

    get showFathePhotoValidation() {
        return this.isSaveClicked && (this.documentValidations.isGuardian || !this.documentValidations.isSingleParentMother) && !this.showFatherPhotoUploadedText;
    }

    get showFatherSignatureValidation() {
        return this.isSaveClicked && (this.documentValidations.isGuardian || !this.documentValidations.isSingleParentMother) && !this.showFatherSignUploadedText;
    }

    get showMotherPhotoValidation() {
        return this.isSaveClicked && (this.documentValidations.isGuardian || !this.documentValidations.isSingleParentFather) && !this.showMotherPhotoUploadedText;
    }

    get showMotherSignatureValidation() {
        return this.isSaveClicked && (this.documentValidations.isGuardian || !this.documentValidations.isSingleParentFather) && !this.showMotherSignUploadedText;
    }

    get showFormC1Validation() {
        return this.isSaveClicked && this.disclosureHtmlObject.formC1 && !this.isFormC1Agreed;
    }

    get showFormCValidation() {
        return this.isSaveClicked && this.disclosureHtmlObject.formC && !this.isFormCAgreed;
    }

    get showFormDValidation() {
        return this.isSaveClicked && this.disclosureHtmlObject.formD && !this.isFormDAgreed;
    }

    get showFormE1Validation() {
        return this.isSaveClicked && this.disclosureHtmlObject.formE1 && !this.isFormE1Agreed;
    }

    get showFormE2Validation() {
        return this.isSaveClicked && this.disclosureHtmlObject.formE2 && !this.isFormE2Agreed;
    }

    get wholeValidation() {
        return !this.showStudentPhotoValidation &&
                !this.showFathePhotoValidation &&
                !this.showMotherPhotoValidation &&
                !this.showFatherSignatureValidation &&
                !this.showMotherSignatureValidation &&
                !this.showFormC1Validation &&
                !this.showFormCValidation &&
                !this.showFormDValidation &&
                !this.showFormE1Validation &&
                !this.showFormE2Validation;
    }

    connectedCallback() {

        getApplicationFormId({ enquiryId: this.eid })
            .then(result => {
                this.applicationFormId = result;
                console.log('Application Form Id:', this.applicationFormId);
                getDocumentValidations({studentId: this.applicationFormId}).then((result)=>{
                    this.documentValidations = result;
                }).catch((error)=>{
                    console.error('Error fetching Document Validations', error);
                    this.showToast('Error', error?.body?.message, 'error');
                })
                getUploadedDocumentsInPage3({studentId: this.applicationFormId}).then((result)=>{
                    console.log('upload result', result);
                    this.documentUploadObject = result;
                }).catch((error)=>{
                    console.error('Error fetching Uploaded Documents', error);
                    this.showToast('Error', error?.body?.message, 'error');
                })
                getEnquiryObject({ enquiryId: this.eid })
                    .then(result => {
                        console.log('getEnquiryObject result', result);
                        this.enquiryObject = result;
                        this.leadId = this.enquiryObject.Lead__c;

                        getDisclosure({studentId: this.applicationFormId, schoolId: this.enquiryObject.School_Institution__c, classId: this.enquiryObject.Seeking_Grade__c, academicYear: this.enquiryObject.Academic_Year__c}).then((result)=>{
                            console.log('Disclosure Object', result);
                            this.disclosureHtmlObject = result;
                        }).catch((error)=>{
                            console.error('Error fetching Disclosure Object', error);
                            this.showToast('Error', error?.body?.message, 'error');
                        })
                    })
                    .catch(error => {
                        console.error('Error fetching Lead Id:', error);
                    });
            })
            .catch(error => {
                this.error = error;
                console.error('Error fetching Application Form Id:', error);
            });

        this.checkIfMobile();
        window.addEventListener('resize', this.checkIfMobile.bind(this));
    }

    disconnectedCallback() {
        window.removeEventListener('resize', this.checkIfMobile.bind(this));
    }

    checkIfMobile() {
        this.isMobile = window.innerWidth <= 700;
    }

    handleCustomUploadClick() {
        this.template.querySelector('.hidden-upload').click();
    }

    handleUploadFinished(event) {
        // your upload finished logic
        console.log('Upload finished:', event.detail.files);
    }

    /**
     * Show Form Methods
     */

    showFormC1Modal() {
        console.log('showFormC1Modal');
        this.isFormC1ModalOpen = true;
    }
    showFormCModal() {
        console.log('showFormCModal');
        this.isFormCModalOpen = true;
    }
    showFormDModal() {
        console.log('showFormDModal');
        this.isFormDModalOpen = true;
    }
    showFormE1Modal() {
        console.log('showFormE1Modal');
        this.isFormE1ModalOpen = true;
    }
    showFormE2Modal() {
        console.log('showFormE2Modal');
        this.isFormE2ModalOpen = true;
    }

    /**
     * Agree handle methods
     */

    handleFormC1Agree() {
        this.isFormC1Agreed = true;
        this.isFormC1ModalOpen = false;
    }
    
    handleFormCAgree() {
        this.isFormCAgreed = true;
        this.isFormCModalOpen = false;
    }

    handleFormDAgree() {
        this.isFormDAgreed = true;
        this.isFormDModalOpen = false;
    }

    handleFormE1Agree() {
        this.isFormE1Agreed = true;
        this.isFormE1ModalOpen = false;
    }

    handleFormE2Agree() {
        this.isFormE2Agreed = true;
        this.isFormE2ModalOpen = false;
    }

    /**
     * Cancel handle methods
     */

    handleFormC1Cancel() {
        this.isFormC1Agreed = false;
        this.isFormC1ModalOpen = false;
    }
    handleFormCCancel() {
        this.isFormCAgreed = false;
        this.isFormCModalOpen = false;
    }

    handleFormDCancel() {
        this.isFormDAgreed = false;
        this.isFormDModalOpen = false;
    }

    handleFormE1Cancel() {
        this.isFormE1Agreed = false;
        this.isFormE1ModalOpen = false;
    }

    handleFormE2Cancel() {
        this.isFormE2Agreed = false;
        this.isFormE2ModalOpen = false;
    }

    /**
     * scroll handler
     */

    handleScrollFormC1(event) {
        const element = event.target;
        const isAtBottom = element.scrollTop + element.clientHeight >= element.scrollHeight - 2;

        if (isAtBottom) {
            this.disableAgreeFormC1 = false;
        }
    }
    handleScrollFormC(event) {
        const element = event.target;
        const isAtBottom = element.scrollTop + element.clientHeight >= element.scrollHeight - 2;

        if (isAtBottom) {
            this.disableAgreeFormC = false;
        }
    }
    handleScrollFormD(event) {
        const element = event.target;
        const isAtBottom = element.scrollTop + element.clientHeight >= element.scrollHeight - 2;

        if (isAtBottom) {
            this.disableAgreeFormD = false;
        }
    }
    handleScrollFormE1(event) {
        const element = event.target;
        const isAtBottom = element.scrollTop + element.clientHeight >= element.scrollHeight - 2;

        if (isAtBottom) {
            this.disableAgreeFormE1 = false;
        }
    }
    handleScrollFormE2(event) {
        const element = event.target;
        const isAtBottom = element.scrollTop + element.clientHeight >= element.scrollHeight - 2;

        if (isAtBottom) {
            this.disableAgreeFormE2 = false;
        }
    }


    renderedCallback() {
        if (this.schoolCard == 'ihs') {
            this.stellarWatermark = IHS_Watermark;
        } else if (this.schoolCard == 'esib') {
            this.stellarWatermark = EIS_Watermark;
        } else if (this.schoolCard == 'alpha') {
            this.stellarWatermark = Alpha_Watermark;
        } else if (this.schoolCard == 'primus') {
            this.stellarWatermark = Primus_Watermark;
        } else if (this.schoolCard == 'universal') {
            this.stellarWatermark = Universal_Watermark;
        } else if (this.schoolCard == 'initializer') {
            this.stellarWatermark = StellarWatermark;
        }

        if (this.isFormCModalOpen && this.disclosureHtmlObject.formC) {
            const container = this.template.querySelector('.formC');
            if (container) {
                container.innerHTML = this.disclosureHtmlObject.formC.terms;
            }
        } else if (this.isFormDModalOpen && this.disclosureHtmlObject.formD) {
            const container = this.template.querySelector('.formD');
            if (container) {
                container.innerHTML = this.disclosureHtmlObject.formD.terms;
            }
        } else if (this.isFormE1ModalOpen && this.disclosureHtmlObject.formE1) {
            const container = this.template.querySelector('.formE1');
            if (container) {
                container.innerHTML = this.disclosureHtmlObject.formE1.terms;
            }
        } else if (this.isFormE2ModalOpen && this.disclosureHtmlObject.formE2) {
            const container = this.template.querySelector('.formE2');
            if (container) {
                container.innerHTML = this.disclosureHtmlObject.formE2.terms;
            }
        }

        if (this.isFormCModalOpen) {
            const scrollEl = this.template.querySelector('.formC1High');
            if (scrollEl && scrollEl.scrollHeight <= scrollEl.clientHeight) {
                // No scrollbar → content fits → enable button
                this.disableAgreeFormC1 = false;
            }
        } else if (this.isFormCModalOpen) {
            const scrollEl = this.template.querySelector('.formCHigh');
            if (scrollEl && scrollEl.scrollHeight <= scrollEl.clientHeight) {
                // No scrollbar → content fits → enable button
                this.disableAgreeFormC = false;
            }
        } else if (this.isFormDModalOpen) {
            const scrollEl = this.template.querySelector('.formDHigh');
            if (scrollEl && scrollEl.scrollHeight <= scrollEl.clientHeight) {
                // No scrollbar → content fits → enable button
                this.disableAgreeFormD = false;
            }
        } else if (this.isFormE1ModalOpen) {
            const scrollEl = this.template.querySelector('.formE1High');
            if (scrollEl && scrollEl.scrollHeight <= scrollEl.clientHeight) {
                // No scrollbar → content fits → enable button
                this.disableAgreeFormE1 = false;
            }
        } else if (this.isFormE2ModalOpen) {
            const scrollEl = this.template.querySelector('.formE2High');
            if (scrollEl && scrollEl.scrollHeight <= scrollEl.clientHeight) {
                // No scrollbar → content fits → enable button
                this.disableAgreeFormE2 = false;
            }
        }
    }

    get cardClass() {
        return 'cards ' + this.schoolCard;
    }

    @track formList = [
        { id: 'formC', label: 'Form C - Declaration By Parents/Guardians' },
        { id: 'formD', label: 'Form D - Code of Conduct for Parents/Guardians' },
        { id: 'formE1', label: 'Form E1 - Fee Terms & Conditions' },
        { id: 'formE2', label: 'Form E2 - Fee Structure' }
    ];

    get isStep1() { return this.currentStep == 1; }
    get isStep2() { return this.currentStep == 2; }
    get isStep3() { return this.currentStep == 3; }
    get isStep4() { return this.currentStep == 4; }

    get isSingleParent() {
        return this.formData.isSingleParent ? this.formData.isSingleParent : false;
    }

    activeSection = ['photosAndSign', 'formPages'];

    @track relationOptions = [
            { label: 'Father', value: 'father' },
            { label: 'Mother', value: 'mother' },
            { label: '--None--', value: 'none' }
        ]


    handleHeaderChange(event) {
        let field = event.target.dataset.id;
        
        let value = event.target.checked ? event.target.checked : (event.target.value ? event.target.value : event.detail.recordId);

        console.log('field', field);
        console.log('value', value);

        this.formData[field] = value;
    }

    navigateToNext() {
        this.currentStep = parseInt(this.currentStep);
        this.formData.page = this.currentStep + 1
        this.dispatchEvent(new CustomEvent('navigate', { detail: this.formData }));
    }

    navigateToPrev() {
        this.formData.page = this.currentStep - 1
        this.dispatchEvent(new CustomEvent('navigate', { detail: this.formData }));
    }

    @track uploadFields = [
        { label: 'Student Photo', dataId: 'studentPhoto', isStudentPhoto: true, previewUrl: null, fileName: '' },
        { label: 'Father / Guardian Photo', dataId: 'fatherPhoto', isFatherPhoto: true, previewUrl: null, fileName: '' },
        { label: 'Mother / Guardian Photo', dataId: 'motherPhoto', isMotherPhoto: true, previewUrl: null, fileName: '' },
        { label: 'Father / Guardian Signature', dataId: 'fatherSignature', isFatherSign: true, previewUrl: null, fileName: '' },
        { label: 'Mother / Guardian Signature', dataId: 'motherSignature', isMotherSign: true, previewUrl: null, fileName: '' }
    ];

    openFileDialog(event) {
        // Programmatically trigger file input
        let dataId = event.currentTarget.dataset.id;
        this.template.querySelector('.'+dataId).click();
    }

    showToast(title, msg, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: msg,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    handleFileChange(event) {
        const dataId = event.target.dataset.id;
        const file = event.target.files[0];

        const allowedExtensions = ['jpg', 'jpeg', 'png'];
        const fileName = file.name.toLowerCase();
        const extension = fileName.split('.').pop();

        if (!allowedExtensions.includes(extension)) {
            event.target.value = null;
            alert('Only image formats are allowed.');
            return;
        }

        if (!file) {
            alert('No file selected.');
            return;
        }

        if (file.size > 1048576) {
            alert('File too large. Maximum allowed size is 1MB.');
            return;
        }

        const reader = new FileReader();
        reader.onload = () => {
            const base64 = reader.result.split(',')[1];

            // Save to studentFiles in the format Apex expects
            this.studentFiles = {
                ...this.studentFiles,
                [dataId]: {
                    fileName: file.name,
                    base64: base64
                }
            };

            // Optionally update UI
            const index = this.uploadFields.findIndex(f => f.dataId === dataId);
            if (index !== -1) {
                this.uploadFields[index].fileName = file.name;
                this.uploadFields[index].previewUrl = reader.result;
                this.uploadFields = [...this.uploadFields];
            }

            console.log('Prepared file:', this.studentFiles);
        };

        reader.onerror = () => {
            this.showToast('Error', 'Error reading file.', 'error');
        };

        reader.readAsDataURL(file);
    }



    saveDetails() {
        this.showWaiter();
        this.isSaveClicked = true;
        if (this.wholeValidation) {
            let jsonToUpload1 = {}

            jsonToUpload1['StudentPhoto-' + this.applicationFormId] = this.studentFiles.studentPhoto;
            jsonToUpload1['FatherPhoto-' + this.applicationFormId] = this.studentFiles.fatherPhoto;

            let jsonToUpload2 = {}

            jsonToUpload2['MotherPhoto-' + this.applicationFormId] = this.studentFiles.motherPhoto;
            jsonToUpload2['FatherSignaturePhoto-' + this.applicationFormId] = this.studentFiles.fatherSignature;
            jsonToUpload2['MotherSignaturePhoto-' + this.applicationFormId] = this.studentFiles.motherSignature;
            
            saveStudentInfoPage3({filesToUpload: jsonToUpload1, studentId: this.applicationFormId}).then((result)=>{
                if (result == 'Success') {
                    saveStudentInfoPage3({filesToUpload: jsonToUpload2, studentId: this.applicationFormId}).then((result)=>{
                        if (result == 'Success') {
                            this.navigateToNext();
                        } else {
                            this.hideWaiter();
                            console.error('error', result);
                            this.showToast('Error', result, 'error');
                        }
                    }).catch((error)=>{
                        this.hideWaiter();
                        console.error('error', error);
                        this.showToast('Error', error?.body?.message, 'error');
                    })
                } else {
                    this.hideWaiter();
                    console.error('error', result);
                    this.showToast('Error', result, 'error');
                }
            }).catch((error)=>{
                this.hideWaiter();
                console.error('error', error);
                this.showToast('Error', error?.body?.message, 'error');
            })
        } else {
            this.hideWaiter();
            alert('Please fix all validations before submitting');
            // this.showToast('Error', 'Please fix all validations before submitting', 'error');
        }
    }

    showWaiter() {
        console.log('In show Waiter');
        this.dispatchEvent(new CustomEvent('waiter', {
            detail: {
                show: true
            }
        }));
    }

    hideWaiter() {
        console.log('In hide Waiter');
        this.dispatchEvent(new CustomEvent('waiter', {
            detail: {
                show: false
            }
        }));
    }


    
}