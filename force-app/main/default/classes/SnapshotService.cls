public class SnapshotService {

    public static void snapshotListToUpdate(List<Liability__c> liabList,List<Asset__c> assetList, List<Snapshot__c> snapshotList){
        Decimal totalLiabAmount = 0.00;
        Decimal totalAssetAmount = 0.00;

        for(Liability__c liab: liabList){
            totalLiabAmount+=liab.Amount__c;
        }

        for(Asset__c asset: assetList){
            totalAssetAmount+=asset.Amount__c;
        }

        for(Snapshot__c snap: snapshotList){
            snap.Total_Liabilities__c = totalLiabAmount;
            snap.Total_Assets__c = totalAssetAmount;
            snap.Created_Date__c = Date.today();
            snap.Snapshot_Data__c = generateSnapshotJSONData(liabList,assetList);
        }
    }

    public static String generateSnapshotJSONData(List<Liability__c> liabs, List<Asset__c> assets){
        List<SnapshotData> snapshotDataList = new List<SnapshotData>();
        for(Asset__c asset:assets){
            SnapshotData data = new SnapshotData();
            data.id = asset.Id;
            data.name = asset.Name;
            data.category = asset.Category__c;
            data.amount = asset.Amount__c;
            data.isAsset = true;
            snapshotDataList.add(data);
        }

        for (Liability__c liab : liabs) {
            SnapshotData data = new SnapshotData();
            data.id = liab.Id;
            data.name = liab.Name;
            data.category = liab.Category__c;
            data.amount = liab.Amount__c;
            data.isAsset = false;
            snapshotDataList.add(data);
        }

        return JSON.serialize(snapshotDataList);
    }

    private class SnapshotData{
        public String id;
        public String name;
        public String category; 
        public Decimal amount;
        public Boolean isAsset;
    }
}