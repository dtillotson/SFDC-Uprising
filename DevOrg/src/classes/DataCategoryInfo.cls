/**
* This class holds the Data Category Info. from
* the describe result
*/
public class DataCategoryInfo {

    private String name;
    private String label;
    private String displayName;
    
    public DataCategoryInfo (String name, String label, String displayName) {
        this.name = name;
        this.label = label;
        this.displayName = displayName;
    }

    public String getName() {
        return this.name;
    }

    public String getLabel() {
        return this.label;
    }

    public String getDisplayName() {
        return this.displayName;
    }

    @isTest
    public static void DataCategoryInfoTest() {
        DataCategoryInfo dataCategoryInfo = new DataCategoryInfo('Products__c', 'Products__c','Products');
        System.assertEquals('Products__c',dataCategoryInfo.getName());
        System.assertEquals('Products__c',dataCategoryInfo.getLabel());
        System.assertEquals('Products',dataCategoryInfo.getDisplayName());
    }
}