import { LightningElement, api, track, wire } from "lwc";

import StellarWatermark from "@salesforce/resourceUrl/StellarWatermark";
import EIS_Watermark from "@salesforce/resourceUrl/EIS_Watermark";
import Primus_Watermark from "@salesforce/resourceUrl/Primus_Watermark";
import Universal_Watermark from "@salesforce/resourceUrl/Universal_Watermark";
import Alpha_Watermark from "@salesforce/resourceUrl/Alpha_Watermark";
import IHS_Watermark from "@salesforce/resourceUrl/IHS_Watermark";

import Application_Form__c from '@salesforce/schema/Application_Form__c';
import Gender__c from '@salesforce/schema/Application_Form__c.Gender__c';
import Caste__c from '@salesforce/schema/Application_Form__c.Caste__c';
import Sibling_Status__c from '@salesforce/schema/Application_Form__c.Sibling_Status__c';
import Is_the_child_taking_any_medication__c from '@salesforce/schema/Application_Form__c.Is_the_child_taking_any_medication__c';
import Allergies__c from '@salesforce/schema/Application_Form__c.Allergies__c';
import Curriculum__c from '@salesforce/schema/Application_Form__c.Curriculum__c';
import OCI_VISA__c from '@salesforce/schema/Application_Form__c.OCI_VISA__c';
import Country_Code__c from '@salesforce/schema/Application_Form__c.Country_Code__c';
import Blood_Group__c from '@salesforce/schema/Application_Form__c.Blood_Group__c';
import Country1__c from '@salesforce/schema/Application_Form__c.Country1__c';
import Any_mental_physical_problem__c from '@salesforce/schema/Application_Form__c.Any_mental_physical_problem__c';
import State_Picklist__c from '@salesforce/schema/Application_Form__c.State_Picklist__c';
import Religion__c from '@salesforce/schema/Application_Form__c.Religion__c';

import saveStudentInfo from '@salesforce/apex/StudentApplicationFormController.saveStudentInfo';
import getStudentInfo from '@salesforce/apex/StudentApplicationFormController.getStudentInfo';
import getEnquiryObject from '@salesforce/apex/StudentApplicationFormController.getEnquiryObject';
import getApplicationFormId from '@salesforce/apex/StudentApplicationFormController.getApplicationFormId';
import getGrade from '@salesforce/apex/StudentApplicationFormController.getGrade';
import getGradeForSibling from '@salesforce/apex/StudentApplicationFormController.getGradeForSibling';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

import bowserLib from '@salesforce/resourceUrl/BrowserDetails';
import { loadScript } from 'lightning/platformResourceLoader';


export default class StudentApplicationFormlwc extends LightningElement {

    @api eid;
    
    @track leadId;

    @api studentId;
    @api currentStep;
    // @track currentStep = 1;
    @track stellarlogo;

    @track stellarWatermark;

    @api schoolCard;

    @track formData = {};

    @track isMobile = false;

    @track genderOptions = [];

    @track casteOptions = [];
    
    @track siblingOptions = [];

    @track medicationOptions = [];

    @track allegyOptions = [];

    @track curriculumOptions = [];

    @track ociVisaOptions = [];

    @track countryCodeOptions = [];

    @track bloodGroupOptions = [];

    @track countryOptions = [];

    @track mentalOptions = [];

    @track stateOptions = [];

    @track gradeOptions = [];

    @track siblingGradeOptions = [];

    @track religionOptions = [];

    @track isSaveClicked = false;

    @track enquiryObject = {};

    @track bowserInitialized = false;

    get itemSize() {
        return this.isMobile ? '12' : '10';
    }

    get isOciVisaAvailable() {
        return this.student.ociVisa == 'Avaliable';
    }

    get isIndian() {
        if (this.student.nationality == 'Indian') {
            this.student.countryCode = '+91';
        }
        return this.student.nationality == 'Indian';
    }

    get isOtherCountry() {
        return !this.isIndian;
    }

    get waterMarkClass() {
        return this.isMobile ? 'watermarkMobile' : 'watermark';
    }

    get isSiblingInformation() {
        return (this.student.isSiblingInformation == null || this.student.isSiblingInformation == undefined) ? false : this.student.isSiblingInformation;
    }

    /**
     * Picklist
     */
    @wire(getObjectInfo, { objectApiName: Application_Form__c })
    formObjectInfo;

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Gender__c })
    wiredGender({ data, error }) {
        if (data) {
            this.genderOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Caste__c })
    wiredCaste({ data, error }) {
        if (data) {
            this.casteOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Sibling_Status__c })
    wiredSibling({ data, error }) {
        if (data) {
            this.siblingOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Is_the_child_taking_any_medication__c })
    wiredMedication({ data, error }) {
        if (data) {
            this.medicationOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Allergies__c })
    wiredAllergies({ data, error }) {
        if (data) {
            this.allegyOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Curriculum__c })
    wiredCurriculum({ data, error }) {
        if (data) {
            this.curriculumOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: OCI_VISA__c })
    wiredOci({ data, error }) {
        if (data) {
            this.ociVisaOptions = data.values.map(item => ({
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

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Blood_Group__c })
    wiredBloodGroup({ data, error }) {
        if (data) {
            this.bloodGroupOptions = data.values.map(item => ({
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

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Any_mental_physical_problem__c })
    wiredMentalProblem({ data, error }) {
        if (data) {
            this.mentalOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

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

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Religion__c })
    wiredReligion({ data, error }) {
        if (data) {
            this.religionOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @track nationalityOptions = [
        { label: 'Indian', value: 'Indian' },
        { label: 'Other', value: 'Other' }
    ];

    @track yesNoOptions = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' }
    ]

    get isApplyingSibling() {
        return this.student.siblingStatus === 'Applying for admissions in our school';
    }

    get isStudyingSibling() {
        return this.student.siblingStatus === 'Currently studying in our school';
    }

    get isOtherSibling() {
        return this.student.siblingStatus === 'Other';
    }

    get isChildTakingMedicine() {
        return this.student.isChildTakingMedicine == 'Yes';
    }

    get isChildHavingAllergy() {
        return this.student.isChildHavingAllergy == 'Yes';
    }

    get isChildHavingMentalProblem() {
        return this.student.doesChildHaveMentalProblem == 'Yes';
    }

    isPassportNumberValid(passportNumber) {
        return true;
    }

    isMobileNumberValid(mobileNumber) {
        return mobileNumber.length == 10;
    }

    isFutureDate(dateStr) {
        const inputDate = new Date(dateStr);
        const today = new Date();

        // Remove time part for accurate date-only comparison
        today.setHours(0, 0, 0, 0);
        inputDate.setHours(0, 0, 0, 0);

        return inputDate > today;
    }

    /**
     * Validations
     */
    get showAcademicYearValidation() {
        return this.isSaveClicked && !this.student.academicYear;
    }

    get showStudentNameValidation() {
        return this.isSaveClicked && !this.student.studentName;
    }

    get showGenderValidation() {
        return this.isSaveClicked && !this.student.gender;
    }

    get showCurriculamValidation() {
        return this.isSaveClicked && !this.student.curriculum;
    }

    get showCategoryValidation() {
        return this.isSaveClicked && !this.student.category;
    }

    get showGradeValidation() {
        return this.isSaveClicked && !this.student.gradeApplyingFor;
    }

    get showEmailIdValidation() {
        return this.isSaveClicked && !this.student.email;
    }

    get showEnquiryNumberValidation() {
        return this.isSaveClicked && !this.student.enquiryNumber;
    }

    get showMobileValidation() {
        return this.isSaveClicked && (!this.student.mobileNumber);
    }

    get showNationalityValidation() {
        return this.isSaveClicked && !this.isIndian && !this.student.nationality;
    }

    get showCountryCodeValidation() {
        return this.isSaveClicked && !this.isIndian && !this.student.countryCode;
    }

    get showCountryValidation() {
        return this.isSaveClicked && !this.isIndian && !this.student.country;
    }

    get showPassportValidation() {
        return this.isSaveClicked && !this.isIndian && (!this.student.passportNo || !this.isPassportNumberValid(this.student.passportNo))
    }

    get showExpiryValidation() {
        return this.isSaveClicked && !this.isIndian && (!this.student.expiryDate || !this.isFutureDate(this.student.expiryDate));
    }

    get expiryFieldRequiredValidation() {
        return this.isSaveClicked && !this.isIndian && !this.student.expiryDate;
    }

    get expiryPastDateValidation() {
        return this.isSaveClicked && !this.isIndian && !this.isFutureDate(this.student.expiryDate);
    }

    get expiryValidationPhrase() {
        if (this.expiryFieldRequiredValidation) {
            return 'This field is required!'
        } else if (this.expiryPastDateValidation) {
            return 'Expiry date should be in future!'
        }
    }

    get showOCIVisaValidation() {
        return this.isSaveClicked && !this.isIndian && !this.student.ociVisa;
    }

    get showFlatNoValidation() {
        return this.isSaveClicked && !this.student.flatNo;
    }

    get showBuildingNameValidation() {
        return this.isSaveClicked && !this.student.buildingName;
    }

    get showStreetValidation() {
        return this.isSaveClicked && !this.student.street;
    }

    get showLandmarkValidation() {
        return this.isSaveClicked && !this.student.landmark;
    }

    get showAreaValidation() {
        return this.isSaveClicked && !this.student.area;
    }

    get showCityValidation() {
        return this.isSaveClicked && !this.student.city;
    }

    get showStateValidation() {
        return this.isSaveClicked && !this.student.state;
    }

    get showPinCodeValidation() {
        return this.isSaveClicked && (!this.student.pinCode || (this.student.pinCode && this.student.pinCode.length != 6));
    }

    get showAadharCardValidation() {
        return this.isSaveClicked && this.student.aadharNo && this.student.aadharNo.length != 12;
    }

    get showUdiseNoValidation() {
        return this.isSaveClicked && this.student.udiseNo && this.student.udiseNo.length != 11;
    }

    get showPenNoValidation() {
        return this.isSaveClicked && this.student.penNo && this.student.penNo.length != 12;
    }

    get showDobValidation() {
        return this.isSaveClicked && (!this.student.dob || this.isFutureDate(this.student.dob));
    }

    get dobFieldRequiredValidation() {
        return this.isSaveClicked && !this.student.dob;
    }

    get dobFutureDateValidation() {
        return this.isSaveClicked && this.isFutureDate(this.student.dob);
    }

    get dobValidationPhrase() {
        if (this.dobFieldRequiredValidation) {
            return 'This field is required!'
        } else if (this.dobFutureDateValidation) {
            return 'DOB should be in past!'
        }
    }

    get showBirthPlaceValidation() {
        return this.isSaveClicked && !this.student.birthPlace;
    }

    get showReligionValidation() {
        return this.isSaveClicked && !this.student.religion;
    }

    get showCasteValidation() {
        return this.isSaveClicked && !this.student.caste;
    }

    get showContactNameValidation() {
        return this.isSaveClicked && !this.student.contactName;
    }

    get showContactMobileValidation() {
        return this.isSaveClicked && (!this.student.contactMobile || !this.isMobileNumberValid(this.student.contactMobile));
    }

    get showContactRelationValidation() {
        return this.isSaveClicked && !this.student.contactRelation;
    }

    get showSiblingFirstNameValidation() {
        return this.isSaveClicked && this.isSiblingInformation && !this.student.siblingFirstName;
    }

    get showSiblingLastNameValidation() {
        return this.isSaveClicked && this.isSiblingInformation && !this.student.siblingLastName;
    }

    get showSiblingGenderValidation() {
        return this.isSaveClicked && this.isSiblingInformation && (this.isApplyingSibling || this.isOtherSibling) && !this.student.siblingGender;
    }

    get showSiblingDobValidation() {
        return this.isSaveClicked && this.isSiblingInformation && (this.isApplyingSibling || this.isOtherSibling) && (!this.student.siblingDob || this.isFutureDate(this.student.siblingDob));
    }

    get siblingDobFieldRequiredValidation() {
        return this.isSaveClicked && this.isSiblingInformation && (this.isApplyingSibling || this.isOtherSibling) && !this.student.siblingDob;
    }

    get siblingDobFutureDateValidation() {
        return this.isSaveClicked && this.isSiblingInformation && (this.isApplyingSibling || this.isOtherSibling) && this.isFutureDate(this.student.siblingDob);
    }

    get siblingDobValidationPhrase() {
        if (this.siblingDobFieldRequiredValidation) {
            return 'This field is required!'
        } else if (this.siblingDobFutureDateValidation) {
            return 'DOB should be in past!'
        }
    }

    get showSiblingGradeApplyingforValidation() {
        return this.isSaveClicked && this.isSiblingInformation && this.isApplyingSibling && !this.student.siblingGradeApplyingFor;
    }

    get showSiblingGradeValidation() {
        return this.isSaveClicked && this.isSiblingInformation && this.isStudyingSibling && !this.student.siblingGrade;
    }

    get showSiblingEnrollmentNumberValidation() {
        return this.isSaveClicked && this.isSiblingInformation && this.isStudyingSibling && !this.student.siblingEnrollmentNumber;
    }

    get showSiblingCurrentSchoolValidation() {
        return this.isSaveClicked && this.isSiblingInformation && this.isOtherSibling && !this.student.siblingCurrentSchool;
    }

    get showSiblingStatusValidation() {
        return this.isSaveClicked && this.isSiblingInformation && !this.student.siblingStatus;
    }

    get showIsChildMedicationValidation() {
        return this.isSaveClicked && !this.student.isChildTakingMedicine;
    }

    get showSpecifyMedicationValidation() {
        return this.isSaveClicked && this.isChildTakingMedicine && !this.student.specifyMedication;
    }

    get showIsChildAllergyValidation() {
        return this.isSaveClicked && !this.student.isChildHavingAllergy;
    }

    get showSpecifyAllergyValidation() {
        return this.isSaveClicked && this.isChildHavingAllergy && !this.student.specifyAllergy;
    }

    get showIsChildMentalProblemValidation() {
        return this.isSaveClicked && !this.student.doesChildHaveMentalProblem;
    }

    get showSpecifyMentalProblemValidation() {
        return this.isSaveClicked && this.isChildHavingMentalProblem && !this.student.specifyMentalProblem;
    }

    get showDoctorNameValidation() {
        return this.isSaveClicked && !this.student.doctorName;
    }

    get showDoctorAddressValidation() {
        return this.isSaveClicked && !this.student.doctorAddress;
    }

    get showDoctorMobileNoValidation() {
        return this.isSaveClicked && (!this.student.doctorMobile || !this.isMobileNumberValid(this.student.doctorMobile));
    }

    get showClinePhoneNumberValidation() {
        return this.isSaveClicked && this.student.doctorClinicPhone && !this.isMobileNumberValid(this.student.doctorClinicPhone);
    }

    get showBloodGroupValidation() {
        return this.isSaveClicked && !this.student.bloodGroup;
    }

    get wholeValidation() {
        return !this.showAcademicYearValidation &&
            !this.showStudentNameValidation &&
            !this.showGenderValidation &&
            !this.showGradeValidation &&
            !this.showEmailIdValidation &&
            !this.showMobileValidation &&
            !this.showNationalityValidation &&
            !this.showCountryValidation &&
            !this.showPassportValidation &&
            !this.showExpiryValidation &&
            !this.showOCIVisaValidation &&
            !this.showFlatNoValidation &&
            !this.showBuildingNameValidation &&
            !this.showStreetValidation &&
            !this.showLandmarkValidation &&
            !this.showAreaValidation &&
            !this.showCityValidation &&
            !this.showStateValidation &&
            !this.showPinCodeValidation &&
            !this.showDobValidation &&
            !this.showBirthPlaceValidation &&
            !this.showReligionValidation &&
            !this.showCasteValidation &&
            !this.showContactNameValidation &&
            !this.showContactMobileValidation &&
            !this.showContactRelationValidation &&
            !this.showSiblingFirstNameValidation &&
            !this.showSiblingLastNameValidation &&
            !this.showSiblingGenderValidation &&
            !this.showSiblingDobValidation &&
            !this.showSiblingGradeApplyingforValidation &&
            !this.showSiblingGradeValidation &&
            !this.showSiblingEnrollmentNumberValidation &&
            !this.showSiblingCurrentSchoolValidation &&
            !this.showSiblingStatusValidation &&
            !this.showSpecifyMedicationValidation &&
            !this.showSpecifyAllergyValidation &&
            !this.showIsChildMedicationValidation &&
            !this.showIsChildAllergyValidation &&
            !this.showIsChildMentalProblemValidation &&
            !this.showSpecifyMentalProblemValidation &&
            !this.showDoctorNameValidation &&
            !this.showDoctorAddressValidation &&
            !this.showDoctorMobileNoValidation &&
            !this.showClinePhoneNumberValidation &&
            !this.showAadharCardValidation &&
            !this.showUdiseNoValidation &&
            !this.showBloodGroupValidation &&
            !this.showPenNoValidation;
    }

    get mobileNumberConcatinated() {
        return this.student.countryCode + this.student.mobileNumber;
    }

    get studentMobileNumber() {
        return this.student.mobileNumber;
    }

    @track student = {
        nationality: 'Indian'};

    connectedCallback() {
        console.log('enquiryId', this.eid);
        this.student.enquiryId = this.eid;
        console.log(this.student.enquiryId);

        if (!this.bowserInitialized) {
            loadScript(this, bowserLib)
                .then(() => {
                    this.bowserInitialized = true;
                    this.fetchDetails();
                })
                .catch(error => {
                    console.error('Error loading Bowser library', error);
                });
        }

        getEnquiryObject({ enquiryId: this.eid })
            .then(result => {
                console.log('getEnquiryObject result', result);
                this.enquiryObject = result;
                this.leadId = this.enquiryObject.Lead__c;
                this.student.leadRecordId = this.leadId;
                this.student.gradeApplyingForSchool = this.enquiryObject.School_Institution__c;
                this.student.gradeApplyingFor = this.enquiryObject.Seeking_Grade__c;
                this.student.academicYear = this.enquiryObject.Academic_Year__c;
                this.student.studentName = this.enquiryObject.Student_Full_Name__c;
                this.student.gender = this.enquiryObject.Gender__c;
                this.student.email = this.enquiryObject.Email__c;
                this.student.enquiryNumber = this.enquiryObject.Name;
                this.student.mobileNumber = this.enquiryObject.Mobile_No__c;
                this.student.buildingName = this.enquiryObject.Apartment_Society__c;
                this.student.landmark = this.enquiryObject.Locality__c;
                this.student.pinCode = this.enquiryObject.Demographic_Pin_code__c;
                this.student.currentSchool = this.enquiryObject.Current_school__c;
                this.student.dob = this.enquiryObject.Date_of_Birth__c;
                this.student.isSiblingInformation = false;

                getGrade({schoolId: this.enquiryObject.School_Institution__c}).then((result)=>{
                    this.gradeOptions = result;
                }).catch((error)=>{
                    console.error(error);
                })

                getGradeForSibling({schoolId: this.enquiryObject.School_Institution__c}).then((result)=>{
                    this.siblingGradeOptions = result;
                }).catch((error)=>{
                    console.error(error);
                })
            })
            .catch(error => {
                console.error('Error fetching Lead Id:', error);
            });



        getApplicationFormId({ enquiryId: this.eid })
            .then(result => {
                this.applicationFormId = result;
                console.log('Application Form Id:', this.applicationFormId);
                this.student.id = this.applicationFormId;
                if (this.applicationFormId) {
                    this.loadStudentData(this.applicationFormId)
                }
            })
            .catch(error => {
                this.error = error;
                console.error('Error fetching Application Form Id:', error);
            });



        this.checkIfMobile();
        window.addEventListener('resize', this.checkIfMobile.bind(this));
        console.log('connectedCallback', this.currentStep);

    }

    disconnectedCallback() {
        window.removeEventListener('resize', this.checkIfMobile.bind(this));
    }

    checkIfMobile() {
        console.log('window.innerWidth', window.innerWidth, 'window.innerHeight', window.innerHeight);
        this.isMobile = window.innerWidth <= 1026;
    }

    renderedCallback() {
        // console.log('this.schoolCard', this.schoolCard);
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

    fetchDetails() {
        console.log('Fetching IP and device details...');
        fetch('https://api.ipify.org?format=json')
            .then(response => response.json())
            .then(data => {
                const result = bowser.getParser(navigator.userAgent).getResult();

                this.student.browserName = result.browser.name;
                this.student.browserVersion = result.browser.version;
                this.student.platform = result.platform.type;
                this.student.osName = result.os.name;
                this.student.osVersion = result.os.version;
                this.student.osVersionName = result.os.versionName;
                this.student.ipAddress = data.ip;

                console.log('Browser Details:', JSON.parse(JSON.stringify(result, null, 2)));
                console.log('IP Address:', this.student.ipAddress);
            })
            .catch(error => {
                console.error('Error fetching IP:', error);
            });
    }

    @track activeSection = ['StudentInformation', 'MoreInformation', 'ResidentialAddress', 'AlternateContact', 'SiblingInformation', 'CurrentlyStudying', 'PreviousSchooling', 'CurrentSchool', 'MedicalInformation', 'DoctorContact', 'Nationality'];

    @track errors = {};
    @track isLoading = false;

    loadStudentData(studentId) {
        this.isLoading = true;
        getStudentInfo({ studentId: studentId })
            .then(result => {
                console.log('result', result);

                this.student = {
                    id: studentId,
                    academicYear: result.academicYear || '',
                    studentName: this.enquiryObject.Student_Full_Name__c,
                    gender: this.enquiryObject.Gender__c,
                    curriculum: result.curriculum,
                    category: result.category || '',
                    gradeApplyingFor: this.enquiryObject.Seeking_Grade__c,
                    gradeApplyingForSchool: this.enquiryObject.School_Institution__c,
                    email: this.enquiryObject.Email__c,
                    enquiryNumber: this.enquiryObject.Name,
                    mobileNumber: this.enquiryObject.Mobile_No__c.toString(),
                    leadRecordId: result.leadRecordId || '',
                    enquiryId: result.enquiryId || '',
                    nationality: result.nationality || '',
                    country: result.country || '',
                    passportNo: result.passportNo || '',
                    expiryDate: result.expiryDate || '',
                    ociVisa: result.ociVisa || '',
                    // New fields
                    flatNo: result.flatNo || '',
                    buildingName: result.buildingName || '',
                    street: result.street || '',
                    landmark: result.landmark || '',
                    area: result.area || '',
                    city: result.city || '',
                    state: result.state || '',
                    pinCode: result.pinCode || '',
                    dob: result.dob || '',
                    birthPlace: result.birthPlace || '',
                    religion: result.religion || '',
                    caste: result.caste || '',
                    motherTongue: result.motherTongue || '',
                    aadharNo: result.aadharNo || '',
                    udiseNo: result.udiseNo || '',
                    contactName: result.contactName || '',
                    contactMobile: result.contactMobile.toString(),
                    contactRelation: result.contactRelation || '',
                    currentGrade: result.currentGrade || '',
                    currentSchool: result.currentSchool || '',
                    currentPlace: result.currentPlace || '',
                    bloodGroup: result.bloodGroup || '',
                    isChildTakingMedicine: result.isChildTakingMedicine,
                    isChildHavingAllergy: result.isChildHavingAllergy,
                    doesChildHaveMentalProblem: result.doesChildHaveMentalProblem,
                    specifyMedication: result.specifyMedication,
                    specifyAllergy:result.specifyAllergy,
                    specifyMentalProblem:result.specifyMentalProblem,
                    medicalHistoryDetails: result.medicalHistoryDetails || '',
                    doctorName: result.doctorName || '',
                    doctorAddress: result.doctorAddress || '',
                    doctorClinicPhone: result.doctorClinicPhone.toString() || '',
                    doctorMobile: result.doctorMobile.toString() || '',
                    isSiblingInformation: result.isSiblingInformation,
                    siblingStatus: result.siblingStatus || '',
                    siblingFirstName: result.siblingFirstName,
                    siblingLastName: result.siblingLastName,
                    siblingGender: result.siblingGender,
                    siblingDob: result.siblingDOB,
                    siblingGrade: result.siblingGrade,
                    siblingGradeApplyingFor: result.siblingGradeApplyingFor,
                    siblingEnrollmentNumber: result.siblingEnrollmentNumber,
                    siblingCurrentSchool: result.siblingCurrentSchool,
                    countryCode: result.countryCode,
                    penNo: result.penNo
                };

                this.student.contactMobile = this.removeSubstring(this.student.countryCode, this.student.contactMobile);
                this.student.doctorClinicPhone = this.removeSubstring(this.student.countryCode, this.student.doctorClinicPhone);
                this.student.doctorMobile = this.removeSubstring(this.student.countryCode, this.student.doctorMobile);

                console.log('loadStudentData Page 1', JSON.parse(JSON.stringify(this.student)));
                this.isLoading = false;
            })
            .catch(error => {
                this.isLoading = false;
                console.log('error', error);

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error?.body?.message,
                        variant: 'error'
                    })
                );
            });
    }

    removeSubstring(substring, originalString) {
        if (originalString.includes(substring)) {
            return originalString.replace(substring, '');
        }
        return originalString;
    }


    handleInputChange(event) {
        const field = event.target.name;
        // const value = event.target.value;
        const value = event.target.type === 'checkbox' ? event.target.checked : event.detail.value;

        console.log('field', field);
        console.log('value', value);

        if (field == 'mobileNumber' || field == 'contactMobile' || field == 'doctorMobile' || field == 'aadharNo' || field == 'pinCode' || field == 'doctorClinicPhone' || field == 'udiseNo') {
            const input = value.replace(/\D/g, '');
            this.student = { ...this.student, [field]: input };
            event.target.value = input;
            return;
        }

        if (field == 'city' || field == 'state' || field == 'birthPlace' || field == 'religion' || field == 'motherTongue' || field == 'contactName' || field == 'contactRelation' || field == 'siblingFirstName' || field == 'siblingLastName' || field == 'doctorName' || field == 'currentPlace') {
            const input = value.replace(/\d/g, '');
            this.student = { ...this.student, [field]: input };
            event.target.value = input;
            return;
        }

        if (field == 'passportNo' || field == 'penNo') {
            const input = value.toUpperCase();
            this.student = { ...this.student, [field]: input };
            event.target.value = input;
            return;
        }

        this.student = { ...this.student, [field]: value };

        if (this.errors[field]) {
            this.errors = { ...this.errors, [field]: undefined };
        }
    }

    validateForm() {
        
    }

    validateEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(String(email).toLowerCase());
    }

    validatePhone(phone) {
        const re = /^\d{10}$/;
        return re.test(phone);
    }

    debugWholeValidation() {
        console.log('showAcademicYearValidation:', this.showAcademicYearValidation);
        console.log('showStudentNameValidation:', this.showStudentNameValidation);
        console.log('showGenderValidation:', this.showGenderValidation);
        console.log('showCurriculamValidation:', this.showCurriculamValidation);
        console.log('showGradeValidation:', this.showGradeValidation);
        console.log('showEmailIdValidation:', this.showEmailIdValidation);
        console.log('showMobileValidation:', this.showMobileValidation);
        console.log('showNationalityValidation:', this.showNationalityValidation);
        console.log('showCountryValidation:', this.showCountryValidation);
        console.log('showPassportValidation:', this.showPassportValidation);
        console.log('showExpiryValidation:', this.showExpiryValidation);
        console.log('showOCIVisaValidation:', this.showOCIVisaValidation);
        console.log('showFlatNoValidation:', this.showFlatNoValidation);
        console.log('showBuildingNameValidation:', this.showBuildingNameValidation);
        console.log('showStreetValidation:', this.showStreetValidation);
        console.log('showLandmarkValidation:', this.showLandmarkValidation);
        console.log('showAreaValidation:', this.showAreaValidation);
        console.log('showCityValidation:', this.showCityValidation);
        console.log('showStateValidation:', this.showStateValidation);
        console.log('showPinCodeValidation:', this.showPinCodeValidation);
        console.log('showDobValidation:', this.showDobValidation);
        console.log('showBirthPlaceValidation:', this.showBirthPlaceValidation);
        console.log('showReligionValidation:', this.showReligionValidation);
        console.log('showCasteValidation:', this.showCasteValidation);
        console.log('showContactNameValidation:', this.showContactNameValidation);
        console.log('showContactMobileValidation:', this.showContactMobileValidation);
        console.log('showContactRelationValidation:', this.showContactRelationValidation);
        console.log('showSiblingFirstNameValidation:', this.showSiblingFirstNameValidation);
        console.log('showSiblingLastNameValidation:', this.showSiblingLastNameValidation);
        console.log('showSiblingGenderValidation:', this.showSiblingGenderValidation);
        console.log('showSiblingDobValidation:', this.showSiblingDobValidation);
        console.log('showSiblingGradeApplyingforValidation:', this.showSiblingGradeApplyingforValidation);
        console.log('showSiblingGradeValidation:', this.showSiblingGradeValidation);
        console.log('showSiblingEnrollmentNumberValidation:', this.showSiblingEnrollmentNumberValidation);
        console.log('showSiblingCurrentSchoolValidation:', this.showSiblingCurrentSchoolValidation);
        console.log('showSiblingStatusValidation:', this.showSiblingStatusValidation);
        console.log('showSpecifyMedicationValidation:', this.showSpecifyMedicationValidation);
        console.log('showSpecifyAllergyValidation:', this.showSpecifyAllergyValidation);
        console.log('showIsChildMedicationValidation:', this.showIsChildMedicationValidation);
        console.log('showIsChildAllergyValidation:', this.showIsChildAllergyValidation);
        console.log('showIsChildMentalProblemValidation:', this.showIsChildMentalProblemValidation);
        console.log('showSpecifyMentalProblemValidation:', this.showSpecifyMentalProblemValidation);
        console.log('wholeValidation:', this.wholeValidation);
    }

    handleSave() {
        this.showWaiter();
        this.isSaveClicked = true;
        console.log('curriculam', this.student.curriculum);
        if (this.student.aadharNo) {
            this.student.aadharNo = this.student.aadharNo.toString();
        }
        // this.debugWholeValidation(); //Uncomment it to debug the whole validation.
        console.log('wholeValidation', this.wholeValidation);

        console.log('student info: ', JSON.parse(JSON.stringify(this.student)));

        if (this.isIndian) {
            this.student.country = 'India';
        }
        if (this.wholeValidation) {
            this.isLoading = true;
            saveStudentInfo({ studentData: this.student })
                .then(result => {
                    console.log('result', result);
                    this.isLoading = false;
                    this.student.id = result;
                    console.log('this.student.id', this.student.id);
                    console.log('success', result);
                    
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Student Information Page 1 Saved Successfully',
                            variant: 'success'
                        })
                    );
                    this.navigateToNext();
    
                })
                .catch(error => {
                    this.hideWaiter();
                    this.isLoading = false;
                    console.error('Error saving student:', error);
    
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Failed to save student information: ' + error.body?.message || error?.message,
                            variant: 'error'
                        })
                    );
                });
        } else {
            this.hideWaiter();
            alert('Please fix all validations before submitting');
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

    showValidationErrors() {
        // Highlight error fields (implementation depends on your component structure)
        Object.keys(this.errors).forEach(fieldName => {
            const inputField = this.template.querySelector(`[data-field="${fieldName}"]`);
            if (inputField) {
                inputField.setCustomValidity(this.errors[fieldName]);
                inputField.reportValidity();
            }
        });

        // Show general validation error toast
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Validation Error',
                message: 'Please fix all validation errors before submitting',
                variant: 'error'
            })
        );
    }

    navigateToNext() {
        console.log('navigateToNext');
        this.currentStep = parseInt(this.currentStep);
        this.formData = {
            ...this.formData,
            page: this.currentStep + 1,
            studentId: this.student.id,
            nationality: this.student.nationality
        };

        this.dispatchEvent(new CustomEvent('navigate', {
            detail: this.formData
        }));
    }

    handleRadioChange(event) {
        this.student.nationality = event.detail.value;

    }



}