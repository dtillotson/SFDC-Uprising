/**
* This class holds the Data Category Group Info.
* from the describe result
*/
public class DataCategoryGroupInfo {
    private String name;
    private String label;
    private String description;
    private DataCategoryInfo[] groupStructure;
    
    public DataCategoryGroupInfo (String name, String label, String description, DataCategoryInfo[] structure) {
        this.name = name;
        this.label = label;
        this.description = description;
        this.groupStructure = structure;
    }
    
    public String getName(){
        return this.name;
    }
    
    
    public String getLabel(){
        return this.label;
    }
    
    public String getDescription(){
        return this.description;
    }
    
    public DataCategoryInfo[] getGroupStructure(){
        return this.groupStructure;
    }
    
    @isTest
    public static void DataCategoryGroupInfoTest(){
        DataCategoryInfo[] structure = new DataCategoryInfo[1];
        structure[0] = new DataCategoryInfo('Product','Product__c','Product__c');
        DataCategoryGroupInfo dataCategoryGroupInfo = new
        DataCategoryGroupInfo('Product','Product__c','Test DataCategoryInfoClass',structure);
        
        System.assertEquals('Product', dataCategoryGroupInfo.getName());
        System.assertEquals('Product__c', dataCategoryGroupInfo.getLabel());
        System.assertEquals('Test DataCategoryInfoClass', dataCategoryGroupInfo.getDescription());
        System.assertEquals(structure.size(),dataCategoryGroupInfo.getGroupStructure().size());
    }
}