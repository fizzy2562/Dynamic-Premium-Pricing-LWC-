// DynamicPricingController.cls
public with sharing class DynamicPricingController {
    
    @AuraEnabled
    public static void updateDynamicPricingSetting(String settingType, Boolean isEnabled) {
        try {
            // Validate input
            if (String.isBlank(settingType)) {
                throw new AuraHandledException('Setting type is required');
            }
            
            // Check if setting already exists
            List<Dynamic_Pricing_Setting__c> existingSettings = [
                SELECT Id, Is_Enabled__c, Setting_Type__c
                FROM Dynamic_Pricing_Setting__c
                WHERE Setting_Type__c = :settingType
                LIMIT 1
            ];
            
            Dynamic_Pricing_Setting__c setting;
            
            if (!existingSettings.isEmpty()) {
                // Update existing setting
                setting = existingSettings[0];
                setting.Is_Enabled__c = isEnabled;
                
                update setting;
            } else {
                // Create new setting
                setting = new Dynamic_Pricing_Setting__c();
                setting.Setting_Type__c = settingType;
                setting.Is_Enabled__c = isEnabled;
                
                insert setting;
            }
            
            // Log the change
            System.debug('Dynamic Pricing Setting updated: ' + settingType + ' = ' + isEnabled);
            
        } catch (DmlException e) {
            throw new AuraHandledException('Database error: ' + e.getMessage());
        } catch (Exception e) {
            throw new AuraHandledException('Error updating Dynamic Pricing Setting: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Boolean> getDynamicPricingSettings() {
        try {
            Map<String, Boolean> settingsMap = new Map<String, Boolean>();
            
            // Initialize all settings to false
            settingsMap.put('businessUnit', false);
            settingsMap.put('territory', false);
            settingsMap.put('account', false);
            settingsMap.put('channel', false);
            
            // Get current settings from database
            List<Dynamic_Pricing_Setting__c> settings = [
                SELECT Setting_Type__c, Is_Enabled__c
                FROM Dynamic_Pricing_Setting__c
                WHERE Setting_Type__c IN ('businessUnit', 'territory', 'account', 'channel')
            ];
            
            // Update map with actual values
            for (Dynamic_Pricing_Setting__c setting : settings) {
                settingsMap.put(setting.Setting_Type__c, setting.Is_Enabled__c);
            }
            
            return settingsMap;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching Dynamic Pricing Settings: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean isDynamicPricingEnabled(String settingType) {
        try {
            if (String.isBlank(settingType)) {
                return false;
            }
            
            List<Dynamic_Pricing_Setting__c> settings = [
                SELECT Is_Enabled__c
                FROM Dynamic_Pricing_Setting__c
                WHERE Setting_Type__c = :settingType
                LIMIT 1
            ];
            
            return !settings.isEmpty() ? settings[0].Is_Enabled__c : false;
            
        } catch (Exception e) {
            System.debug('Error checking Dynamic Pricing status: ' + e.getMessage());
            return false;
        }
    }
    
    @AuraEnabled
    public static void bulkUpdateDynamicPricingSettings(Map<String, Boolean> settingsMap) {
        try {
            List<Dynamic_Pricing_Setting__c> settingsToUpsert = new List<Dynamic_Pricing_Setting__c>();
            
            // Get existing settings
            Map<String, Dynamic_Pricing_Setting__c> existingSettingsMap = new Map<String, Dynamic_Pricing_Setting__c>();
            for (Dynamic_Pricing_Setting__c setting : [
                SELECT Id, Setting_Type__c, Is_Enabled__c
                FROM Dynamic_Pricing_Setting__c
                WHERE Setting_Type__c IN :settingsMap.keySet()
            ]) {
                existingSettingsMap.put(setting.Setting_Type__c, setting);
            }
            
            // Process each setting
            for (String settingType : settingsMap.keySet()) {
                Boolean isEnabled = settingsMap.get(settingType);
                Dynamic_Pricing_Setting__c setting;
                
                if (existingSettingsMap.containsKey(settingType)) {
                    // Update existing
                    setting = existingSettingsMap.get(settingType);
                    setting.Is_Enabled__c = isEnabled;
                } else {
                    // Create new
                    setting = new Dynamic_Pricing_Setting__c();
                    setting.Setting_Type__c = settingType;
                    setting.Is_Enabled__c = isEnabled;
                }
                
                settingsToUpsert.add(setting);
            }
            
            upsert settingsToUpsert Id;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error bulk updating Dynamic Pricing Settings: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Decimal getDynamicPriceMultiplier(String settingType, String recordId) {
        try {
            // Default multiplier
            Decimal baseMultiplier = 1.0;
            
            // Check if dynamic pricing is enabled for this setting type
            if (!isDynamicPricingEnabled(settingType)) {
                return baseMultiplier;
            }
            
            // You can extend this to calculate actual multipliers based on:
            // - Market conditions
            // - Demand/Supply ratios
            // - Customer tier
            // - Time-based pricing
            // - Inventory levels
            // - Competitive analysis
            
            // For now, return a simple example multiplier
            switch on settingType {
                when 'businessUnit' {
                    return 1.1; // 10% increase for BU level
                }
                when 'territory' {
                    return 1.05; // 5% increase for territory
                }
                when 'account' {
                    return 0.95; // 5% discount for account-specific
                }
                when 'channel' {
                    return 1.15; // 15% increase for channel
                }
                when else {
                    return baseMultiplier;
                }
            }
            
        } catch (Exception e) {
            System.debug('Error calculating dynamic price multiplier: ' + e.getMessage());
            return 1.0; // Return base multiplier on error
        }
    }

    // Legacy method - kept for compatibility
    // Legacy method removed to avoid duplicate signature
}