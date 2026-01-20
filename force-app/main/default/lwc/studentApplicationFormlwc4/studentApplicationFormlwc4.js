import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import StellarWatermark from '@salesforce/resourceUrl/StellarWatermark';
import EIS_Watermark from "@salesforce/resourceUrl/EIS_Watermark";
import Primus_Watermark from "@salesforce/resourceUrl/Primus_Watermark";
import Universal_Watermark from "@salesforce/resourceUrl/Universal_Watermark";
import Alpha_Watermark from "@salesforce/resourceUrl/Alpha_Watermark";
import IHS_Watermark from "@salesforce/resourceUrl/IHS_Watermark";

import getEnquiryObject from '@salesforce/apex/StudentApplicationFormController.getEnquiryObject';
import getApplicationFormId from '@salesforce/apex/StudentApplicationFormController.getApplicationFormId';
import saveStudentInfoPage3 from '@salesforce/apex/StudentApplicationFormController.saveStudentInfoPage3';
import getDocumentValidations from '@salesforce/apex/StudentApplicationFormController.getDocumentValidations';
import isChildBelowGrade1 from '@salesforce/apex/StudentApplicationFormController.isChildBelowGrade1';

export default class DocumentUploadForm extends LightningElement {
    @api eid;

    @track leadId;

    @track applicationFormId;

    @api recordId; // To attach files to a record (e.g., Contact/Account)

    @track stellarlogo;

    @track stellarWatermark;

    @api currentStep;

    @api schoolCard;

    @track formData = {};

    @track isMobile = false;

    @track isSaveClicked = false;

    @track studentFiles = {};

    @track documentValidations = {};

    @track enquiryObject = {};

    @track isBelowGrade1 = false;

    @track sectionsTitle = ["For Foreign Nationals", "Student's Documents", "Parent's Documents", "Guardian's Documents"];

    get waterMarkClass() {
        return this.isMobile ? 'watermarkMobile' : 'watermark';
    }

    connectedCallback() {
        getEnquiryObject({ enquiryId: this.eid })
            .then(result => {
                this.enquiryObject = result;
                console.log('Lead Id:', this.leadId);
            })
            .catch(error => {
                console.error('Error fetching Lead Id:', error);
            });

        getApplicationFormId({ enquiryId: this.eid })
            .then(result => {
                this.applicationFormId = result;
                console.log('Application Form Id:', this.applicationFormId);
                getDocumentValidations({ studentId: this.applicationFormId }).then((result) => {
                    console.log('Document Validations:', result);
                    this.documentValidations = result;
                    if (this.isIndian && !this.documentValidations.isGuardian) {
                        this.sectionsTitle = ["Student's Documents", "Parent's Documents"];
                    } else if (this.isIndian) {
                        this.sectionsTitle = ["Student's Documents", "Parent's Documents", "Guardian's Documents"];
                    } else if (!this.documentValidations.isGuardian) {
                        this.sectionsTitle = ["For Foreign Nationals", "Student's Documents", "Parent's Documents"];
                    }
                }).catch((error) => {
                    this.showToast('Error', error?.body?.message, 'error');
                })
                isChildBelowGrade1({ studentId: this.applicationFormId }).then((result) => {
                    console.log('isChildBelowGrade1:', result);
                    this.isBelowGrade1 = result;

                }).catch((error) => {
                    this.showToast('Error', error?.body?.message, 'error');
                })
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

    openFileDialog(event) {
        let dataId = event.currentTarget.dataset.id;
        console.log('dataId openFileDialog', dataId);
        this.template.querySelector('.' + dataId).click();
    }

    checkIfMobile() {
        this.isMobile = window.innerWidth <= 700;
    }

    get sectionClass() {
        return this.isMobile ? 'slds-size_8-of-8' : 'slds-size_8-of-8 slds-p-around_x-small';
    }

    get itemSize() {
        return this.isMobile ? '12' : '10';
    }

    renderedCallback() {
        console.log('this.schoolCard', this.schoolCard);
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
    }

    get cardClass() {
        return 'cards ' + this.schoolCard;
    }

    get isStep1() { return this.currentStep == 1; }
    get isStep2() { return this.currentStep == 2; }
    get isStep3() { return this.currentStep == 3; }
    get isStep4() { return this.currentStep == 4; }

    sections = [
        {
            title: 'For Foreign Nationals',
            documents: this.grouped([
                'Passport (first and last page)',
                'OCI/Visa'
            ])
        },
        {
            title: "Student's Documents",
            documents: this.grouped([
                'Birth Certificate (mandatory)',
                'School Leaving Certificate (mandatory before joining)',
                'Student Aadhar Card (for Grade 2 onward)',
                'Latest Marksheet (for Grade-2 and above)',
                'Caste Certificate (if Caste is not \'General\')'
            ])
        },
        {
            title: "Parent's Documents",
            documents: this.grouped([
                'Father Aadhar Card (mandatory)',
                'Mother Aadhar Card (mandatory)',
                'Father PAN Card',
                'Mother PAN Card',
                'Evidence or Affidavit for legal guardianship (mandatory for single parents)'
            ])
        },
        {
            title: "Guardian's Documents",
            documents: this.grouped([
                'Guardian Aadhar Card (mandatory for legal guardian)',
                'Guardian PAN Card (mandatory for legal guardian)',
                'Affidavit for Legal Guardian (mandatory for legal guardian)'
            ])
        }
    ];

    get isIndian() {
        return !this.documentValidations.isForeign;
    }

    get showPassportUploadText() {
        return this.studentFiles.passport != null &&
            'fileName' in this.studentFiles.passport &&
            'base64' in this.studentFiles.passport;
    }

    get showPassportValidation() {
        return this.isSaveClicked && this.documentValidations.isForeign && !this.showPassportUploadText;
    }

    get showOciVisaUploadText() {
        return this.studentFiles.ociVisa != null &&
            'fileName' in this.studentFiles.ociVisa &&
            'base64' in this.studentFiles.ociVisa;
    }

    get showOciVisaValidation() {
        return this.isSaveClicked && this.documentValidations.isForeign && this.documentValidations.isOciVisaAvailable && !this.showOciVisaUploadText;
    }

    get showBirthCertificateUploadText() {
        return this.studentFiles.birthCertificate != null &&
            'fileName' in this.studentFiles.birthCertificate &&
            'base64' in this.studentFiles.birthCertificate;
    }

    get showBirthCertificateValidation() {
        return this.isSaveClicked && !this.showBirthCertificateUploadText;
    }

    get showSchoolLeavingCertificateUploadText() {
        return this.studentFiles.schoolLeavingCertificate != null &&
            'fileName' in this.studentFiles.schoolLeavingCertificate &&
            'base64' in this.studentFiles.schoolLeavingCertificate;
    }

    get showSchoolLeavingCertificateValidation() {
        return this.isSaveClicked && !this.isBelowGrade1 && !this.showSchoolLeavingCertificateUploadText;
    }

    get showStudentAadharCardUploadText() {
        return this.studentFiles.studentAadharCard != null &&
            'fileName' in this.studentFiles.studentAadharCard &&
            'base64' in this.studentFiles.studentAadharCard;
    }

    get showStudentAadharCardValidation() {
        return this.isSaveClicked && !this.documentValidations.isForeign && !this.showStudentAadharCardUploadText;
    }

    get showLatestMarksheetForGrade2AndAboveUploadText() {
        return this.studentFiles.latestMarksheet != null &&
            'fileName' in this.studentFiles.latestMarksheet &&
            'base64' in this.studentFiles.latestMarksheet;
    }

    get showCasteCertificateUploadText() {
        return this.studentFiles.casteCertificate != null &&
            'fileName' in this.studentFiles.casteCertificate &&
            'base64' in this.studentFiles.casteCertificate;
    }

    get showCasteCertificateValidation() {
        return this.isSaveClicked && !this.documentValidations.isForeign && !this.documentValidations.isCasteGen && !this.showCasteCertificateUploadText;
    }

    get showFatherAadharCardUploadText() {
        return this.studentFiles.fatherAadharCard != null &&
            'fileName' in this.studentFiles.fatherAadharCard &&
            'base64' in this.studentFiles.fatherAadharCard;
    }

    get showFatherAadharCardValidation() {
        return this.isSaveClicked && !this.documentValidations.isForeign && !this.documentValidations.isSingleParentMother && this.documentValidations.isFatherIndianCitizen && !this.showFatherAadharCardUploadText;
    }

    get showMotherAadharCardUploadText() {
        return this.studentFiles.motherAadharCard != null &&
            'fileName' in this.studentFiles.motherAadharCard &&
            'base64' in this.studentFiles.motherAadharCard;
    }

    get showMotherAadharCardValidation() {
        return this.isSaveClicked && !this.documentValidations.isForeign && !this.documentValidations.isSingleParentFather && this.documentValidations.isMotherIndianCitizen && !this.showMotherAadharCardUploadText;
    }

    get showFatherPanCardUploadText() {
        return this.studentFiles.fatherPanCard != null &&
            'fileName' in this.studentFiles.fatherPanCard &&
            'base64' in this.studentFiles.fatherPanCard;
    }

    get showFatherPanCardValidation() {
        return this.isSaveClicked && !this.documentValidations.isForeign && !this.documentValidations.isSingleParentMother && this.documentValidations.isFatherIndianCitizen && !this.showFatherPanCardUploadText;
    }

    get showMotherPanCardUploadText() {
        return this.studentFiles.motherPanCard != null &&
            'fileName' in this.studentFiles.motherPanCard &&
            'base64' in this.studentFiles.motherPanCard;
    }

    get showMotherPanCardValidation() {
        return this.isSaveClicked && !this.documentValidations.isForeign && !this.documentValidations.isSingleParentFather && this.documentValidations.isMotherIndianCitizen && !this.showMotherPanCardUploadText;
    }

    get showEvidenceOrAffidavitForLegalGuardianshipApplicableToSingleParentsUploadText() {
        return this.studentFiles.evidenceOrAffidavitForLegalGuardianship != null &&
            'fileName' in this.studentFiles.evidenceOrAffidavitForLegalGuardianship &&
            'base64' in this.studentFiles.evidenceOrAffidavitForLegalGuardianship;
    }

    get showEvidenceOrAffidavitForLegalGuardianshipApplicableToSingleParentsValidation() {
        return this.isSaveClicked && !this.documentValidations.isForeign && this.documentValidations.isSingleParent && !this.showEvidenceOrAffidavitForLegalGuardianshipApplicableToSingleParentsUploadText;
    }

    get showGuardianAadharCardUploadText() {
        return this.studentFiles.guardianAadharCard != null &&
            'fileName' in this.studentFiles.guardianAadharCard &&
            'base64' in this.studentFiles.guardianAadharCard;
    }

    get showGuardianAadharCardValidation() {
        return this.isSaveClicked && this.documentValidations.isGuardian && !this.showGuardianAadharCardUploadText;
    }

    get showGuardianPanCardUploadText() {
        return this.studentFiles.guardianPanCard != null &&
            'fileName' in this.studentFiles.guardianPanCard &&
            'base64' in this.studentFiles.guardianPanCard;
    }

    get showGuardianPanCardValidation() {
        return this.isSaveClicked && this.documentValidations.isGuardian && !this.showGuardianPanCardUploadText;
    }

    get showAffidavitForLegalGuardianUploadText() {
        return this.studentFiles.affidavitForLegalGuardian != null &&
            'fileName' in this.studentFiles.affidavitForLegalGuardian &&
            'base64' in this.studentFiles.affidavitForLegalGuardian;
    }

    get showAffidavitForLegalGuardianValidation() {
        return this.isSaveClicked && this.documentValidations.isGuardian && !this.showAffidavitForLegalGuardianUploadText;
    }

    get wholeValidation() {
        return !this.showPassportValidation &&
            !this.showOciVisaValidation &&
            !this.showBirthCertificateValidation &&
            // !this.showSchoolLeavingCertificateValidation &&
            // !this.showStudentAadharCardValidation &&
            !this.showCasteCertificateValidation &&
            !this.showFatherAadharCardValidation &&
            // !this.showFatherPanCardValidation &&
            !this.showMotherAadharCardValidation &&
            // !this.showMotherPanCardValidation &&
            !this.showGuardianAadharCardValidation &&
            // !this.showGuardianPanCardValidation &&
            !this.showAffidavitForLegalGuardianValidation &&
            !this.showEvidenceOrAffidavitForLegalGuardianshipApplicableToSingleParentsValidation;
    }


    grouped(docList) {
        const rows = [];
        for (let i = 0; i < docList.length; i += 1) {
            const items = [];
            let groupedObject = { label: docList[i], uploadLabel: 'Upload ' + docList[i].split('(')[0], dataId: this.toCamelCase(docList[i].split('(')[0]).trim() };
            let validationVariable = ('is' + this.toCamelCase(docList[i].split('(')[0])).trim();
            groupedObject[validationVariable] = true;
            items.push(groupedObject);
            rows.push({ id: i, items });
        }
        return rows;
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        console.log('Uploaded files:', uploadedFiles);
        // Optionally, store info for later
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
        console.log('Sections', JSON.parse(JSON.stringify(this.sections)));
        const dataId = event.target.dataset.id;
        console.log('dataId', dataId);
        const file = event.target.files[0];

        if (!file) {
            this.showToast('Error', 'No file selected.', 'error');
            return;
        }

        const allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];
        const fileName = file.name.toLowerCase();
        const extension = fileName.split('.').pop();

        if (!allowedExtensions.includes(extension)) {
            event.target.value = null;
            alert('Only PDF and image formats are allowed.');
            return;
        }

        if (file.size > 1048576) {
            event.target.value = null;
            alert('File too large. Maximum allowed size is 1MB.');
            return;
        }

        const reader = new FileReader();
        reader.onload = () => {
            const base64 = reader.result.split(',')[1];

            this.studentFiles = {
                ...this.studentFiles,
                [dataId]: {
                    fileName: file.name,
                    base64: base64
                }
            };

            this.sections = this.sections.map(section => {
                const updatedDocs = section.documents.map(doc => {
                    const updatedItems = doc.items.map(item => {
                        if (item.dataId === dataId) {
                            return {
                                ...item,
                                fileName: file.name,
                                previewUrl: reader.result
                            };
                        }
                        return item;
                    });
                    return { ...doc, items: updatedItems };
                });
                return { ...section, documents: updatedDocs };
            });

            console.log('Prepared file:', this.studentFiles);
        };

        reader.onerror = () => {
            this.showToast('Error', 'Error reading file.', 'error');
        };

        reader.readAsDataURL(file);
    }



    toCamelCase(str) {
        return str
            .toLowerCase()
            .replace(/[^a-zA-Z0-9]+(.)/g, (_, chr) => chr.toUpperCase());
    }

    handleSubmit() {
        this.showWaiter();
        this.isSaveClicked = true;
        if (this.wholeValidation) {
            let sliced1 = Object.entries(this.studentFiles).slice(0, 3);
            let sliced2 = Object.entries(this.studentFiles).slice(3, 6);
            let sliced3 = Object.entries(this.studentFiles).slice(6, 9);
            let sliced4 = Object.entries(this.studentFiles).slice(9, 12);
            let sliced5 = Object.entries(this.studentFiles).slice(12);
            const jsonUpload1 = Object.fromEntries(sliced1);
            const jsonUpload2 = Object.fromEntries(sliced2);
            const jsonUpload3 = Object.fromEntries(sliced3);
            const jsonUpload4 = Object.fromEntries(sliced4);
            const jsonUpload5 = Object.fromEntries(sliced5);
            saveStudentInfoPage3({ filesToUpload: jsonUpload1, studentId: this.applicationFormId }).then((result) => {
                if (result == 'Success') {
                    saveStudentInfoPage3({ filesToUpload: jsonUpload2, studentId: this.applicationFormId }).then((result) => {
                        if (result == 'Success') {
                            saveStudentInfoPage3({ filesToUpload: jsonUpload3, studentId: this.applicationFormId }).then((result) => {
                                if (result == 'Success') {
                                    saveStudentInfoPage3({ filesToUpload: jsonUpload4, studentId: this.applicationFormId }).then((result) => {
                                        if (result == 'Success') {
                                            saveStudentInfoPage3({ filesToUpload: jsonUpload5, studentId: this.applicationFormId }).then((result) => {
                                                if (result == 'Success') {
                                                    this.navigateToNext();
                                                } else {
                                                    this.showToast('Error', result, 'error');
                                                    this.hideWaiter();
                                                }
                                            }).catch((error) => {
                                                this.hideWaiter();
                                                console.error('error', error);
                                                this.showToast('Error', error?.body?.message, 'error');
                                            });
                                        } else {
                                            this.showToast('Error', result, 'error');
                                            this.hideWaiter();
                                        }
                                    }).catch((error) => {
                                        this.hideWaiter();
                                        console.error('error', error);
                                        this.showToast('Error', error?.body?.message, 'error');
                                    })
                                } else {
                                    this.showToast('Error', result, 'error');
                                    this.hideWaiter();
                                }
                            }).catch((error) => {
                                this.hideWaiter();
                                console.error('error', error);
                                this.showToast('Error', error?.body?.message, 'error');
                            });
                        } else {
                            this.showToast('Error', result, 'error');
                            this.hideWaiter();
                        }
                    }).catch((error) => {
                        this.hideWaiter();
                        console.error('error', error);
                        this.showToast('Error', error?.body?.message, 'error');
                    });
                } else {
                    this.showToast('Error', result, 'error');
                    this.hideWaiter();
                }
            }).catch((error) => {
                this.hideWaiter();
                console.error('error', error);
                this.showToast('Error', error?.body?.message, 'error');
            });
        } else {
            this.hideWaiter();
            alert('Please fix all validations before submitting');
        }
    }

    navigateToNext() {
        this.currentStep = parseInt(this.currentStep);
        this.formData.page = this.currentStep + 1;
        this.dispatchEvent(new CustomEvent('navigate', { detail: this.formData }));
    }

    navigateToPrev() {
        this.formData.page = this.currentStep - 1;
        this.dispatchEvent(new CustomEvent('navigate', { detail: this.formData }));
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