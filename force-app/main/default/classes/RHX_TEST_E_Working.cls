@isTest(SeeAllData=true)
public class RHX_TEST_E_Working {
 static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
                   FROM E_Working__c ORDER BY LastModifiedDate DESC LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new E_Working__c()
            );
        }
      rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}