public class SnapshotRepo {
    public SnapshotRepo() {

    }
    
    public Snapshot__c querySnapshotById (Id recordId){
        return [SELECT Id, Created_Date__c, Net_Worth__c, Total_Assets__c, Total_Liabilities__c, Snapshot_Data__c FROM Snapshot__c WHERE id =: recordId LIMIT 1];
    }

}