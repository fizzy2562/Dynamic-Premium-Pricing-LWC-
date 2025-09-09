Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
Schema.DescribeSObjectResult d = gd.get('Dynamic_Pricing_Setting__c') != null ? gd.get('Dynamic_Pricing_Setting__c').getDescribe() : null;
if (d == null) {
    System.debug('DPSC not found');
} else {
    Map<String, Schema.SObjectField> fdm = d.fields.getMap();
    System.debug('DPSC has Setting_Type__c: ' + fdm.containsKey('Setting_Type__c'));
    System.debug('DPSC has Is_Enabled__c: ' + fdm.containsKey('Is_Enabled__c'));
    System.debug('DPSC has Created_By__c: ' + fdm.containsKey('Created_By__c'));
    System.debug('DPSC has Last_Modified_By__c: ' + fdm.containsKey('Last_Modified_By__c'));
}
Schema.DescribeSObjectResult p = gd.get('Premium_Appointment_Setting__c') != null ? gd.get('Premium_Appointment_Setting__c').getDescribe() : null;
if (p == null) {
    System.debug('PASC not found');
} else {
    Map<String, Schema.SObjectField> pfm = p.fields.getMap();
    System.debug('PASC has Setting_Type__c: ' + pfm.containsKey('Setting_Type__c'));
    System.debug('PASC has Is_Enabled__c: ' + pfm.containsKey('Is_Enabled__c'));
}
