// PremiumAppointmentController.cls
public with sharing class PremiumAppointmentController {
    
    @AuraEnabled
    public static void updatePremiumAppointmentSetting(String settingType, Boolean isEnabled) {
        try {
            // Validate input
            if (String.isBlank(settingType)) {
                throw new AuraHandledException('Setting type is required');
            }
            
            // Check if setting already exists
            List<Premium_Appointment_Setting__c> existingSettings = [
                SELECT Id, Is_Enabled__c, Setting_Type__c
                FROM Premium_Appointment_Setting__c
                WHERE Setting_Type__c = :settingType
                LIMIT 1
            ];
            
            Premium_Appointment_Setting__c setting;
            
            if (!existingSettings.isEmpty()) {
                // Update existing setting
                setting = existingSettings[0];
                setting.Is_Enabled__c = isEnabled;
                
                update setting;
            } else {
                // Create new setting
                setting = new Premium_Appointment_Setting__c();
                setting.Setting_Type__c = settingType;
                setting.Is_Enabled__c = isEnabled;
                
                insert setting;
            }
            
            // Log the change
            System.debug('Premium Appointment Setting updated: ' + settingType + ' = ' + isEnabled);
            
        } catch (DmlException e) {
            throw new AuraHandledException('Database error: ' + e.getMessage());
        } catch (Exception e) {
            throw new AuraHandledException('Error updating Premium Appointment Setting: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Boolean> getPremiumAppointmentSettings() {
        try {
            Map<String, Boolean> settingsMap = new Map<String, Boolean>();
            
            // Initialize all settings to false
            settingsMap.put('businessUnit', false);
            settingsMap.put('territory', false);
            settingsMap.put('account', false);
            settingsMap.put('channel', false);
            
            // Get current settings from database
            List<Premium_Appointment_Setting__c> settings = [
                SELECT Setting_Type__c, Is_Enabled__c
                FROM Premium_Appointment_Setting__c
                WHERE Setting_Type__c IN ('businessUnit', 'territory', 'account', 'channel')
            ];
            
            // Update map with actual values
            for (Premium_Appointment_Setting__c setting : settings) {
                settingsMap.put(setting.Setting_Type__c, setting.Is_Enabled__c);
            }
            
            return settingsMap;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching Premium Appointment Settings: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean isPremiumAppointmentEnabled(String settingType) {
        try {
            if (String.isBlank(settingType)) {
                return false;
            }
            
            List<Premium_Appointment_Setting__c> settings = [
                SELECT Is_Enabled__c
                FROM Premium_Appointment_Setting__c
                WHERE Setting_Type__c = :settingType
                LIMIT 1
            ];
            
            return !settings.isEmpty() ? settings[0].Is_Enabled__c : false;
            
        } catch (Exception e) {
            System.debug('Error checking Premium Appointment status: ' + e.getMessage());
            return false;
        }
    }
    
    @AuraEnabled
    public static void bulkUpdatePremiumAppointmentSettings(Map<String, Boolean> settingsMap) {
        try {
            List<Premium_Appointment_Setting__c> settingsToUpsert = new List<Premium_Appointment_Setting__c>();
            
            // Get existing settings
            Map<String, Premium_Appointment_Setting__c> existingSettingsMap = new Map<String, Premium_Appointment_Setting__c>();
            for (Premium_Appointment_Setting__c setting : [
                SELECT Id, Setting_Type__c, Is_Enabled__c
                FROM Premium_Appointment_Setting__c
                WHERE Setting_Type__c IN :settingsMap.keySet()
            ]) {
                existingSettingsMap.put(setting.Setting_Type__c, setting);
            }
            
            // Process each setting
            for (String settingType : settingsMap.keySet()) {
                Boolean isEnabled = settingsMap.get(settingType);
                Premium_Appointment_Setting__c setting;
                
                if (existingSettingsMap.containsKey(settingType)) {
                    // Update existing
                    setting = existingSettingsMap.get(settingType);
                    setting.Is_Enabled__c = isEnabled;
                } else {
                    // Create new
                    setting = new Premium_Appointment_Setting__c();
                    setting.Setting_Type__c = settingType;
                    setting.Is_Enabled__c = isEnabled;
                }
                
                settingsToUpsert.add(setting);
            }
            
            upsert settingsToUpsert Id;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error bulk updating Premium Appointment Settings: ' + e.getMessage());
        }
    }

    // Legacy method - kept for compatibility
    @AuraEnabled(cacheable=true)
    public static List<Premium_Appointment_Setting__c> getPremiumAppointments() {
        return [SELECT Id, Name FROM Premium_Appointment_Setting__c LIMIT 10];
    }
}