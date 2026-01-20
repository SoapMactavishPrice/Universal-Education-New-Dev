@isTest
public with sharing class StellarAPICalloutsTest {
    
    @isTest
    public static void makeCalloutTest() {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        System.Test.startTest();
            if(!StellarAPICallouts.checkIfStellarAPIEnabled('test'))
                StellarAPICallouts.makeCallout(
                    'https://www.salesforce.com/invalidurlendpoint/',
                    StellarAPICallouts.GET_METHOD, 
                    StellarAPICallouts.createBody(
                        new List<String>{'param1', 'param2'},
                        new List<String>{'pvalue1', 'pvalue2'}
                    )
                );
        System.Test.stopTest();
    }
}