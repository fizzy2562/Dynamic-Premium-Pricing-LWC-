public class LiabilityRepo {
    public LiabilityRepo() {

    }

    public List<Liability__c> queryAllLiabilities(){
        return [SELECT Name, Category__c, Amount__c FROM Liability__c];
    }
}