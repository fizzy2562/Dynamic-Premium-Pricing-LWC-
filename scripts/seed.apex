List<String> types = new List<String>{'businessUnit','territory','account','channel'};
// Dynamic Pricing settings
Map<String, Dynamic_Pricing_Setting__c> existingD = new Map<String, Dynamic_Pricing_Setting__c>([
    SELECT Id, Setting_Type__c FROM Dynamic_Pricing_Setting__c WHERE Setting_Type__c IN :types
]);
List<Dynamic_Pricing_Setting__c> toInsertD = new List<Dynamic_Pricing_Setting__c>();
for (String t : types) {
    if (!existingD.containsKey(t)) {
        Dynamic_Pricing_Setting__c s = new Dynamic_Pricing_Setting__c();
        s.Name = t;
        s.Setting_Type__c = t;
        s.Is_Enabled__c = false;
        s.Created_Date__c = System.now();
        s.Last_Modified_Date__c = System.now();
        s.Created_By__c = UserInfo.getUserId();
        s.Last_Modified_By__c = UserInfo.getUserId();
        toInsertD.add(s);
    }
}
if (!toInsertD.isEmpty()) insert toInsertD;

// Premium Appointment settings
Map<String, Premium_Appointment_Setting__c> existingP = new Map<String, Premium_Appointment_Setting__c>([
    SELECT Id, Setting_Type__c FROM Premium_Appointment_Setting__c WHERE Setting_Type__c IN :types
]);
List<Premium_Appointment_Setting__c> toInsertP = new List<Premium_Appointment_Setting__c>();
for (String t : types) {
    if (!existingP.containsKey(t)) {
        Premium_Appointment_Setting__c s = new Premium_Appointment_Setting__c();
        s.Name = t;
        s.Setting_Type__c = t;
        s.Is_Enabled__c = false;
        s.Created_Date__c = System.now();
        s.Last_Modified_Date__c = System.now();
        s.Created_By__c = UserInfo.getUserId();
        s.Last_Modified_By__c = UserInfo.getUserId();
        toInsertP.add(s);
    }
}
if (!toInsertP.isEmpty()) insert toInsertP;
