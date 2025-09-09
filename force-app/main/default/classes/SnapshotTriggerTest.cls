@isTest
public class SnapshotTriggerTest {
    @TestSetup
    static void makeData(){
        Asset__c asset = new Asset__c(
        	amount__c = 1000.00
        );
        insert asset;
        
        Liability__c liab = new Liability__c(
        	amount__c = 1000.00
        );
        insert liab;
        
        Profile prof = [SELECT Id, Name, UserType, Description FROM Profile WHERE Name like '%System Administrator%' LIMIT 1];
        
        User sysAdmin = new User(
        	Username = 'journalofcode@gmail.com.personally', 
            LastName = 'Journal', 
            Email = 'journalofcode@gmail.com', 
            Alias = 'sjtest', 
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = prof.Id
        );
        insert sysAdmin;
    }

    @isTest static void funcSnapshotWithData(){
        User sysAdmin = [SELECT ID FROM User LIMIT 1];
        System.runAs(sysAdmin){
            Test.startTest();
            Snapshot__c snapshot = new Snapshot__c();
            insert snapshot;
            Test.stopTest();
            Snapshot__c snapshotRec = [SELECT Total_Liabilities__c, Total_Assets__c FROM Snapshot__c LIMIT 1];
            Assert.isNotNull(snapshotRec,'Not able to retrieve Snapshot record.');
            Assert.areEqual(1000.00,snapshotRec.Total_Liabilities__c,'Snapshot Total Liabilities does not equal to expected results.');
            Assert.areEqual(1000.00,snapshotRec.Total_Assets__c,'Snapshot Total Assets does not equal to expected results.');
        }
    }
}