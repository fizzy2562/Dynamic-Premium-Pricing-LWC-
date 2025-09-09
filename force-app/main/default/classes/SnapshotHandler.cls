public class SnapshotHandler {
    private static AssetRepo assetRepo{
        get{
            if (assetRepo == null) {
                assetRepo = new AssetRepo();
            }
            return assetRepo;
        }
        set;
    }

    private static LiabilityRepo liabilityRepo{
        get{
            if (liabilityRepo == null) {
                liabilityRepo = new LiabilityRepo();
            }
            return liabilityRepo;
        }
        set;
    }

    public static void beforeInsert(List<Snapshot__c> newSnapshotList){
        updateSnapshot(newSnapshotList);
    }

    private static void updateSnapshot(List<Snapshot__c> snapshotList){
        List<Liability__c> liabilityList = new List<Liability__c>(liabilityRepo.queryAllLiabilities());
        List<Asset__c> assetList = new List<Asset__c>(assetRepo.queryAllAssets());
        SnapshotService.snapshotListToUpdate(liabilityList, assetList,snapshotList);
    }
}