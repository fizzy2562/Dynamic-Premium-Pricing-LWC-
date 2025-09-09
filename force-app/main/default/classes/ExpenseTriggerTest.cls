@isTest
public class ExpenseTriggerTest {
	@TestSetup
    static void makeData(){
        Budget__c budget = new Budget__c();
        budget.Name = 'TEST MONTH-2024';
        insert budget;
        
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
    
    @isTest
    static void testAfterInsert(){
        User sysAdmin = [SELECT ID FROM User LIMIT 1];
        Budget__c budget = [SELECT ID FROM Budget__c LIMIT 1];
        System.runAs(sysAdmin){
        	Expense__c expense = new Expense__c(budget__c = budget.Id, Amount__c = 1000.00);
            Test.startTest();
            insert expense;
            Test.stopTest();
        }
        Budget__c budgetRec = [SELECT ID, Total_Expenses__c FROM Budget__c LIMIT 1];
        Assert.areEqual(1000.00,budgetRec.Total_Expenses__c,'Total Expense does not match expected results.');
    }
    
    @isTest
    static void testAfterUpdate(){
        User sysAdmin = [SELECT ID FROM User LIMIT 1];
        Budget__c budget = [SELECT ID FROM Budget__c LIMIT 1];
        System.runAs(sysAdmin){
        	Expense__c expense = new Expense__c(budget__c = budget.Id, Amount__c = 1000.00);
            Test.startTest();
            insert expense;
            
            Expense__c expenseUpdate = [SELECT ID, Amount__c FROM Expense__c LIMIT 1];
            expenseUpdate.Amount__c = 1200.00;
            update expenseUpdate;
            Test.stopTest();
        }
        Budget__c budgetRec = [SELECT ID, Total_Expenses__c FROM Budget__c LIMIT 1];
        Assert.areEqual(1200.00,budgetRec.Total_Expenses__c,'Total Expense does not match expected results.');
    }
    
    @isTest
    static void testAfterDelete(){
        User sysAdmin = [SELECT ID FROM User LIMIT 1];
        Budget__c budget = [SELECT ID FROM Budget__c LIMIT 1];
        System.runAs(sysAdmin){
        	Expense__c expense = new Expense__c(budget__c = budget.Id, Amount__c = 1000.00);
            Income__c income = new Income__c(budget__c = budget.Id, Amount__c = 1000.00);
            Test.startTest();
            insert expense;
            insert income;
            
            Expense__c expenseDelete = [SELECT ID, Amount__c FROM Expense__c LIMIT 1];
            delete expenseDelete;
            Test.stopTest();
        }
        Budget__c budgetRec = [SELECT ID, Total_Expenses__c FROM Budget__c LIMIT 1];
        Assert.areEqual(0.00,budgetRec.Total_Expenses__c,'Total Expense does not match expected results.');
    }
}