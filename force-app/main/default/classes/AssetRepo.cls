public class AssetRepo {
    public AssetRepo() {

    }

    public List<Asset__c> queryAllAssets(){
        return [SELECT Name, Category__c, Amount__c FROM Asset__c];
    }
}