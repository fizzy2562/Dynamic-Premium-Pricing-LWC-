public with sharing class DynamicPricingController {
    
    @AuraEnabled(cacheable=true)
    public static List<Dynamic_Pricing_Setting__c> getDynamicPricingSettings() {
        return [SELECT Id, Name FROM Dynamic_Pricing_Setting__c LIMIT 10];
    }
    
}