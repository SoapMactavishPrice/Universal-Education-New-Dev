import { LightningElement, api, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

import StellarWatermark from "@salesforce/resourceUrl/StellarWatermark";
import EIS_Watermark from "@salesforce/resourceUrl/EIS_Watermark";
import Primus_Watermark from "@salesforce/resourceUrl/Primus_Watermark";
import Universal_Watermark from "@salesforce/resourceUrl/Universal_Watermark";
import Alpha_Watermark from "@salesforce/resourceUrl/Alpha_Watermark";
import IHS_Watermark from "@salesforce/resourceUrl/IHS_Watermark";

import Application_Form__c from '@salesforce/schema/Application_Form__c';
import Father_Covid_vaccination_status__c from '@salesforce/schema/Application_Form__c.Father_Covid_vaccination_status__c';
import Application_Form_Relation__c from '@salesforce/schema/Application_Form__c.Application_Form_Relation__c';
import Country_Code__c from '@salesforce/schema/Application_Form__c.Country_Code__c';
import Country1__c from '@salesforce/schema/Application_Form__c.Country1__c';
import Father_Qualification__c from '@salesforce/schema/Application_Form__c.Father_Qualification__c';
import Is_Father_Government_Employee__c from '@salesforce/schema/Application_Form__c.Is_Father_Government_Employee__c';
import State_Picklist__c from '@salesforce/schema/Application_Form__c.State_Picklist__c';

import getEnquiryObject from '@salesforce/apex/StudentApplicationFormController.getEnquiryObject';
import getApplicationFormId from '@salesforce/apex/StudentApplicationFormController.getApplicationFormId';
import getStudentInfoPage2 from '@salesforce/apex/StudentApplicationFormController.getStudentInfoPage2';
import saveStudentInfoPage2 from '@salesforce/apex/StudentApplicationFormController.saveStudentInfoPage2';
import getNationality from '@salesforce/apex/StudentApplicationFormController.getNationality';

export default class StudentApplicationFormlwc extends LightningElement {
    @api eid;

    @track leadId;

    @api currentStep;

    @track nationality;

    @track formData = {};

    @track stellarlogo;

    @api schoolCard;

    @track stellarWatermark;

    @track isMobile = false;

    @track student = {};

    get waterMarkClass() {
        return this.isMobile ? 'watermarkMobile' : 'watermark';
    }

    get itemSize() {
        return this.isMobile ? '12' : '10';
    }

    @track leadRecordId = '';

    @track isSaveClicked = false;

    @track vaccinationOptions = [];

    @track relationOptions = [];

    @track countryCodeOptions = [];

    @track qualificationOptions = [];

    @track governmentEmployeeOptions = [];

    @track countryOptions = [];

    @track stateOptions = [];

    @track enquiryObject = {};

    @track activeSection = ['isSingleParent', 'fatherInformation', 'motherInformation', 'gaurdianInformation'];

    @track isFather = true;

    @track isMother = true;

    connectedCallback() {
        try {
            console.log('Im in second page connected callback')

            getEnquiryObject({ enquiryId: this.eid })
                .then(result => {
                    console.log('getEnquiryObject result', result);
                    this.enquiryObject = result;
                    this.leadId = this.enquiryObject.Lead__c;
                })
                .catch(error => {
                    console.error('Error fetching Lead Id:', error);
                });



            getApplicationFormId({ enquiryId: this.eid })
                .then(result => {
                    this.applicationFormId = result;
                    console.log('Application Form Id:', this.applicationFormId);
                    if (this.applicationFormId) {
                        this.loadStudentData(this.applicationFormId)
                        getNationality({studentId: this.applicationFormId}).then((result)=>{
                            this.nationality = result;
                        }).catch((error)=>{
                            this.showToast('Error', error?.body?.message, 'error');
                        })
                    }
                })
                .catch(error => {
                    this.error = error;
                    console.error('Error fetching Application Form Id:', error);
                });



            this.checkIfMobile();
            window.addEventListener('resize', this.checkIfMobile.bind(this));
            console.log('connectedCallback', this.currentStep);
        } catch (error) {
            console.error(error);
        }

    }

    disconnectedCallback() {
        window.removeEventListener('resize', this.checkIfMobile.bind(this));
    }

    checkIfMobile() {
        this.isMobile = window.innerWidth <= 700;
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
    }

    get cardClass() {
        return 'cards ' + this.schoolCard;
    }

    get isStep1() { return this.currentStep == 1; }
    get isStep2() { return this.currentStep == 2; }
    get isStep3() { return this.currentStep == 3; }
    get isStep4() { return this.currentStep == 4; }

    get isSingleParent() {
        return this.student.isSingleParent ? this.student.isSingleParent : false;
    }

    get isGuardian() {
        return this.student.isGuardian;
    }

    @wire(getObjectInfo, { objectApiName: Application_Form__c })
    formObjectInfo;

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Father_Covid_vaccination_status__c })
    wiredVaccination({ data, error }) {
        if (data) {
            this.vaccinationOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Application_Form_Relation__c })
    wiredParentSelection({ data, error }) {
        if (data) {
            this.relationOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Country_Code__c })
    wiredCountryCode({ data, error }) {
        if (data) {
            this.countryCodeOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Father_Qualification__c })
    wiredQualification({ data, error }) {
        if (data) {
            this.qualificationOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Is_Father_Government_Employee__c })
    wiredGovernmentEmployee({ data, error }) {
        if (data) {
            this.governmentEmployeeOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Country1__c })
    wiredCountry({ data, error }) {
        if (data) {
            this.countryOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

            this.countryOptions.push({
                label: 'India',
                value: 'India'
            })

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: State_Picklist__c })
    wiredState({ data, error }) {
        if (data) {
            this.stateOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    get showFather() {
        return !this.isSingleParent || this.student.singleParentRelation === 'Father';
    }

    get showMother() {
        return !this.isSingleParent || this.student.singleParentRelation === 'Mother';
    }

    get showGuardian() {
        return !this.isSingleParent;
    }

    get isIndian() {
        return this.nationality == 'Indian';
    }

    get isFatherGovernmentEmployee() {
        return this.student.fatherGovernmentEmployee == 'Yes';
    }

    get isMotherGovernmentEmployee() {
        return this.student.motherGovernmentEmployee == 'Yes';
    }

    get isGuardianGovernmentEmployee() {
        return this.student.guardianGovernmentEmployee == 'Yes';
    }

    isEmailValid(email) {
        const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

        if (emailPattern.test(email)) {
            return true;
        } else {
            return false;
        }
    }

    isMobileNumberValid(mobileNumber) {
        return mobileNumber.length == 10;
    }

    /**
     * Validations
     */

    get showSingleParentRelationValidation() {
        return this.isSaveClicked && this.isSingleParent && !this.student.singleParentRelation;
    }

    //Father Validations
    get showFatherFirstNameValidation() {
        return this.isSaveClicked && this.showFather && !this.student.fatherFirstName;
    }
    
    get showFatherLastNameValidation() {
        return this.isSaveClicked && this.showFather && !this.student.fatherLastName;
    }

    get showFatherMobileValidation() {
        return this.isSaveClicked && this.showFather && (!this.student.fatherMobileNo || !this.isMobileNumberValid(this.student.fatherMobileNo));
    }

    get showFatherEmailIdValidation() {
        return this.isSaveClicked && this.showFather && (!this.student.fatherEmailId || !this.isEmailValid(this.student.fatherEmailId));
    }

    get showFatherAadharNumberValidation() {
        return this.isSaveClicked && this.showFather && this.isIndian && (!this.student.fatherAadhaarNo || (this.student.fatherAadhaarNo && this.student.fatherAadhaarNo.length != 12));
    }

    get showFatherPanNumberValidation() {
        return this.isSaveClicked && this.showFather && this.isIndian && (!this.student.fatherPAN || (this.student.fatherPAN && this.student.fatherPAN.length != 10));
    }

    get showFatherEducationQualification() {
        return this.isSaveClicked && this.showFather && !this.student.fatherEducationalQualification;
    }

    get showFatherProfessionValidation() {
        return this.isSaveClicked && this.showFather && !this.student.fatherProfession;
    }

    get showFatherNameOfOrganisation() {
        return this.isSaveClicked && this.showFather && !this.student.fatherNameOfTheOrganisation;
    }

    get showFatherDesignationValidation() {
        return this.isSaveClicked && this.showFather && !this.student.fatherDesignation;
    }

    get showFatherOfficeContactNumberValidation() {
        return this.isSaveClicked && this.showFather && (!this.student.fatherOfficeContactNo || !this.isMobileNumberValid(this.student.fatherOfficeContactNo));
    }

    get showFatherOfficeAddressValidation() {
        return this.isSaveClicked && this.showFather && !this.student.fatherOfficeAddress;
    }

    get showFatherGovernmentEmployee() {
        return this.isSaveClicked && this.showFather && !this.student.fatherGovernmentEmployee;
    }

    get showFatherGovNameOfDepartment() {
        return this.isSaveClicked && this.showFather && this.isFatherGovernmentEmployee && !this.student.fatherNameOfDepartment;
    }

    get showFatherCovidVaccinationValidation() {
        return this.isSaveClicked && this.showFather && !this.student.fatherCovidVaccinationStatus;
    }
    
    //Mother Validations
    get showMotherFirstNameValidation() {
        return this.isSaveClicked && this.showMother && !this.student.motherFirstName;
    }
    
    get showMotherLastNameValidation() {
        return this.isSaveClicked && this.showMother && !this.student.motherLastName;
    }

    get showMotherMobileValidation() {
        return this.isSaveClicked && this.showMother && (!this.student.motherMobileNo || !this.isMobileNumberValid(this.student.motherMobileNo));
    }

    get showMotherEmailIdValidation() {
        return this.isSaveClicked && this.showMother && (!this.student.motherEmail || !this.isEmailValid(this.student.motherEmail));
    }

    get showMotherAadharNumberValidation() {
        return this.isSaveClicked && this.showMother && this.isIndian && (!this.student.motherAadhaar || (this.student.motherAadhaar && this.student.motherAadhaar.length != 12))
    }

    get showMotherPanNumberValidation() {
        return this.isSaveClicked && this.showMother && this.isIndian && (!this.student.motherPAN || (this.student.motherPAN && this.student.motherPAN.length != 10));
    }

    get showMotherEducationQualification() {
        return this.isSaveClicked && this.showMother && !this.student.motherEducationalQualification;
    }

    get showMotherProfessionValidation() {
        return this.isSaveClicked && this.showMother && !this.student.motherProfession;
    }

    get showMotherNameOfOrganisation() {
        return this.isSaveClicked && this.showMother && !this.student.motherNameOfTheOrganisation;
    }

    get showMotherDesignationValidation() {
        return this.isSaveClicked && this.showMother && !this.student.motherDesignation;
    }

    get showMotherOfficeContactNumberValidation() {
        return this.isSaveClicked && this.showMother && (!this.student.motherOfficeContactNo || !this.isMobileNumberValid(this.student.motherOfficeContactNo));
    }

    get showMotherOfficeAddressValidation() {
        return this.isSaveClicked && this.showMother && !this.student.motherOfficeAddress;
    }

    get showMotherCovidVaccinationValidation() {
        return this.isSaveClicked && this.showMother && !this.student.motherCovidVaccinationStatus;
    }

    get showMotherGovernmentEmployee() {
        return this.isSaveClicked && this.showMother && !this.student.motherGovernmentEmployee;
    }

    get showMotherGovNameOfDepartment() {
        return this.isSaveClicked && this.showMother && this.isMotherGovernmentEmployee && !this.student.motherNameOfDepartment;
    }

    //Guardian Validations
    get showGaurdianFullNameValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianName;
    }

    get showGuardianMobileNoValidation() {
        return this.isSaveClicked && this.isGuardian && (!this.student.guardianMobileNo || !this.isMobileNumberValid(this.student.guardianMobileNo));
    }

    get showGuardianEmailIdValidation() {
        return this.isSaveClicked && this.isGuardian && (!this.student.guardianEmailId || !this.isEmailValid(this.student.guardianEmailId));
    }

    get showGuardianAadharNumberValidation() {
        return this.isSaveClicked && this.isGuardian && (!this.student.guardianAadhaarNo || (this.student.guardianAadhaarNo && this.student.guardianAadhaarNo.length != 12));
    }

    get showGuardianPanCardNoValidation() {
        return this.isSaveClicked && this.isGuardian && (!this.student.guardianPAN || (this.student.guardianPAN && this.student.guardianPAN.length != 10));
    }

    get showGuardianQualificationValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianEducationalQualification;
    }

    get showGuardianProfessionValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianProfession;
    }

    get showGuardianNameOfOrgValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianNameOfTheOrganisation;
    }

    get showGuardianDesignationValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianDesignation;
    }

    get showGuardianRelationValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianRelation;
    }

    get showGuardianStateValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianState;
    }

    get showGuardianCountryValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianCountry;
    }

    get showGuardianCityValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianCity;
    }

    get showGuardianOfficeContactNoValidation() {
        return this.isSaveClicked && this.isGuardian && (!this.student.guardianOfficeContactNo || !this.isMobileNumberValid(this.student.guardianOfficeContactNo));
    }

    get showGuardianOfficeAddressValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianOfficeAddress;
    }

    get showGuardianFloorValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianFloorBuildingName;
    }

    get showGuardianStreetValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianStreetLocality;
    }

    get showGuardianPinCodeValidation() {
        return this.isSaveClicked && this.isGuardian && (!this.student.guardianPinCode || (this.student.guardianPinCode && this.student.guardianPinCode.length != 6));
    }

    get showGuardianVaccinationValidation() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianCovidVaccinationStatus;
    }

    get showGuardianGovernmentEmployee() {
        return this.isSaveClicked && this.isGuardian && !this.student.guardianGovernmentEmployee;
    }

    get showGuardianGovNameOfDepartment() {
        return this.isSaveClicked && this.isGuardian && this.isGuardianGovernmentEmployee && !this.student.guardianNameOfDepartment;
    }


    get wholeValidation() {
        return !this.showFatherFirstNameValidation &&
            !this.showFatherLastNameValidation &&
            !this.showFatherMobileValidation &&
            !this.showFatherEmailIdValidation &&
            !this.showFatherAadharNumberValidation &&
            !this.showFatherPanNumberValidation &&
            !this.showFatherEducationQualification &&
            !this.showFatherProfessionValidation &&
            !this.showFatherNameOfOrganisation &&
            !this.showFatherDesignationValidation &&
            !this.showFatherOfficeContactNumberValidation &&
            !this.showFatherOfficeAddressValidation &&
            !this.showFatherGovernmentEmployee &&
            !this.showFatherGovNameOfDepartment &&
            !this.showFatherCovidVaccinationValidation &&
            !this.showMotherFirstNameValidation &&
            !this.showMotherLastNameValidation &&
            !this.showMotherMobileValidation &&
            !this.showMotherEmailIdValidation &&
            !this.showMotherAadharNumberValidation &&
            !this.showMotherPanNumberValidation &&
            !this.showMotherEducationQualification &&
            !this.showMotherProfessionValidation &&
            !this.showMotherNameOfOrganisation &&
            !this.showMotherDesignationValidation &&
            !this.showMotherOfficeContactNumberValidation &&
            !this.showMotherOfficeAddressValidation &&
            !this.showMotherGovernmentEmployee &&
            !this.showMotherGovNameOfDepartment &&
            !this.showMotherCovidVaccinationValidation &&
            !this.showGaurdianFullNameValidation &&
            !this.showGuardianMobileNoValidation &&
            !this.showGuardianEmailIdValidation &&
            !this.showGuardianAadharNumberValidation &&
            !this.showGuardianPanCardNoValidation &&
            !this.showGuardianQualificationValidation &&
            !this.showGuardianProfessionValidation &&
            !this.showGuardianNameOfOrgValidation &&
            !this.showGuardianDesignationValidation &&
            !this.showGuardianRelationValidation &&
            !this.showGuardianStateValidation &&
            !this.showGuardianCountryValidation &&
            !this.showGuardianCityValidation &&
            !this.showGuardianOfficeContactNoValidation &&
            !this.showGuardianOfficeAddressValidation &&
            !this.showGuardianGovernmentEmployee &&
            !this.showGuardianGovNameOfDepartment &&
            !this.showGuardianFloorValidation &&
            !this.showGuardianStreetValidation &&
            !this.showGuardianPinCodeValidation &&
            !this.showSingleParentRelationValidation;
    }


    showToast(title, msg, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: msg,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    loadStudentData(applicationFormId) {
        getStudentInfoPage2({ studentId: applicationFormId }).then((result) => {
            console.log('result', result);
            this.student = result;
            if (this.student.fatherFirstName || this.student.motherFirstName || this.student.guardianName) {
                this.isFather = this.showFather;
                this.isMother = this.showMother;
            }
            this.student.studentId = this.applicationFormId;
            this.student.enquiryId = this.eid;
            this.student.leadRecordId = this.leadId;
            this.student.guardianCountry = 'India';

            this.student.fatherMobileNo = this.removeSubstring(this.student.countryCode, this.student.fatherMobileNo);
            this.student.fatherOfficeContactNo = this.removeSubstring(this.student.countryCode, this.student.fatherOfficeContactNo);
            this.student.motherMobileNo = this.removeSubstring(this.student.countryCode, this.student.motherMobileNo);
            this.student.motherOfficeContactNo = this.removeSubstring(this.student.countryCode, this.student.motherOfficeContactNo);
            this.student.guardianMobileNo = this.removeSubstring(this.student.countryCode, this.student.guardianMobileNo);
        }).catch((error) => {
            console.error('Error:', error);
            this.showToast('Error', error?.body?.message, 'error');
        })
    }

    removeSubstring(substring, originalString) {
        if (!originalString) {
            return originalString;
        }
        if (originalString.includes(substring)) {
            return originalString.replace(substring, '');
        }
        return originalString;
    }

    handleInputChange(event) {
        let field = event.target?.name;

        const value = event.target.type === 'checkbox' ? event.target.checked : event.detail.value;

        console.log('field', field);
        console.log('value', value);

        if (field == 'fatherMobileNo' || field == 'fatherOfficeContactNo' || field == 'motherMobileNo' || field == 'motherOfficeContactNo' || field == 'guardianMobileNo' || field == 'guardianOfficeContactNo' || field == 'fatherAadhaarNo' || field == 'motherAadhaar' || field == 'guardianAadhaarNo' || field == 'fatherPinCode' || field == 'motherPinCode' || field == 'guardianPinCode' || field == 'fatherAnnualIncome' || field == 'motherAnnualIncome' || field == 'guardianAnnualIncome') {
            const input = value.replace(/\D/g, '');
            this.student[field] = input;
            event.target.value = input;
            return;
        }

        if (field == 'fatherFirstName' || field == 'fatherLastName' || field == 'fatherProfession' || field == 'fatherNameOfTheOrganisation' || field == 'fatherDesignation' || field == 'motherFirstName' || field == 'motherLastName' || field == 'motherProfession' || field == 'motherNameOfTheOrganisation' || field == 'motherDesignation' || field == 'guardianName' || field == 'guardianRelation' || field == 'guardianCity' || field == 'guardianState' || field == 'guardianProfession' || field == 'guardianNameOfTheOrganisation' || field == 'guardianDesignation' || field == '' ) {
            const input = value.replace(/\d/g, '');
            this.student[field] = input;
            event.target.value = input;
            return;
        }

        if (field == 'fatherPAN' || field == 'motherPAN' || field == 'guardianPAN') {
            const input = value.toUpperCase();
            this.student = { ...this.student, [field]: input };
            event.target.value = input;
            return;
        }

        if (field == 'isSingleParent') {
            if (!value) {
                this.activeSection = ['isSingleParent', 'fatherInformation', 'motherInformation', 'gaurdianInformation'];
                this.isFather = true;
                this.isMother = true;
            }
        }

        if (field == 'singleParentRelation') {
            if (value == 'Father') {
                this.activeSection = ['isSingleParent', 'fatherInformation'];
                this.isFather = true;
                this.isMother = false;
            } else if (value == 'Mother') {
                this.activeSection = ['isSingleParent', 'motherInformation'];
                this.isMother = true;
                this.isFather = false;
            }
        }

        this.student[field] = value;
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

    saveDetails() {
        this.showWaiter();
        this.isSaveClicked = true;
        if (this.wholeValidation) {
            saveStudentInfoPage2({ studentWrapperStringObject: JSON.stringify(this.student) }).then((result) => {
                if (result == 'Success') {
                    this.showToast('Success', 'Student Information Page 2 Saved Successfully', 'success');
                    this.navigateToNext();
                } else {
                    this.hideWaiter();
                    this.showToast('Error', result, 'error');
                }
            }).catch((error) => {
                this.hideWaiter();
                console.error('Error:', error);
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