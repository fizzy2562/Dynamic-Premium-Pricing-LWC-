public class SnapshotController {
    private static SnapshotRepo snapshotRepo{
        get{
            if (snapshotRepo == null) {
                snapshotRepo = new SnapshotRepo();
            }
            return snapshotRepo;
        }
        set;
    }

    @AuraEnabled(cacheable=true)
    public static Snapshot__c getSnapshot(Id recordId){
        return snapshotRepo.querySnapshotById(recordId);
    }
}