public with sharing class PremiumAppointmentController {
    
    @AuraEnabled(cacheable=true)
    public static List<Premium_Appointment_Setting__c> getPremiumAppointments() {
        return [SELECT Id, Name FROM Premium_Appointment_Setting__c LIMIT 10];
    }
    
}