<aura:application access="GLOBAL" extends="ltng:outApp"
    implements="ltng:allowGuestAccess">

    <aura:dependency resource="c:parentStudentApplicationForm"/>

    <c:parentStudentApplicationForm enquiryId="{!$CurrentPage.parameters.enquiryId}"/>

</aura:application>