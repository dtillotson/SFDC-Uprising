public with sharing class DataCategoryController {
	
	public static String categoryGroupName {get; set;}
	public static String categoryRootName {get; set;}
    
    public Contact UserContact{
        get{
            String ContactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.GetUserId()].ContactId;
            if(UserContact==null&&ContactId!=null){
                UserContact = [SELECT Id, Name FROM Contact WHERE Id = :ContactId];                              
            }
            //system.debug('UserContact =====>' + UserContact);
            return UserContact;
        }
        set;
    }
    
    //return current page name
    public String getPageName(){
    	// Get the current page URL and strip out everything but the page name
        PageReference pageRef = ApexPages.currentPage();
        String currPage = pageRef.getUrl();
        String currPageNameWithParams = currPage.substringAfterLast('/');
        String currPageName = currPageNameWithParams.substringBefore('?');
        return currPageName;
    }
    
    // Schema describe methods
    public List<Schema.DescribeDataCategoryGroupStructureResult> getSchemaDetails () {
    	
    	//Making the call to the describeDataCategoryGroups to
		//get the list of category groups associated
    	List<String> objType = new List<String>();
    	// Use "KnowledgeArticleVersion" to retrieve category groups associated with article types.
		// Use "Question" to retrieve category groups associated with questions.
		objType.add('KnowledgeArticleVersion');
		//objType.add('Question');
		List<Schema.DescribeDataCategoryGroupResult> describeCategoryResult = Schema.describeDataCategoryGroups(objType);
		
		List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
		//Looping throught the first describe result to create
         //the list of pairs for the second describe call
         for(DescribeDataCategoryGroupResult singleResult : 
         describeCategoryResult){
            DataCategoryGroupSobjectTypePair p =
               new DataCategoryGroupSobjectTypePair();
            p.setSobject(singleResult.getSobject());
            p.setDataCategoryGroupName(singleResult.getName());
            pairs.add(p);
         }
		//describeDataCategoryGroupStructures()
		List<Schema.DescribeDataCategoryGroupStructureResult> results = Schema.describeDataCategoryGroupStructures(pairs, true);
		return results;
    }
    
    //Returns array of Category Groups
    public DataCategoryGroupInfo[] getDataCategoryGroupInfo() {
        return DataCategoryUtil.getInstance().getAllCategoryGroups();
    }
    
    //Returns array of Category Info
    public DataCategoryInfo[] getDataCategoryInfo() {
        return DataCategoryUtil.getInstance().getCategoryStructure(categoryGroupName);
    }
    
    public static List<Schema.DescribeDataCategoryGroupResult> getPartnerQuestionsDetails1(){
        List <String> objType = new List<String>();
        List <String> categoryNames1 = new List<String>();
        objType.add('KnowledgeArticleVersion');

        List<Schema.DescribeDataCategoryGroupResult> describeCategoryResult = Schema.describeDataCategoryGroups(objType);
        
        for(DescribeDataCategoryGroupResult singleResult : describeCategoryResult){
            categoryNames1.add(singleResult.getName());
        }
        
        return describeCategoryResult;
    }
    
    public static List<Schema.DescribeDataCategoryGroupStructureResult> getPartnerQuestionsDetails2(){
        List <DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
        List <String> categoryNames2 = new List<String>();

        DataCategoryGroupSobjectTypePair pair1 = new DataCategoryGroupSobjectTypePair();
        pair1.setSobject('KnowledgeArticleVersion');
        pair1.setDataCategoryGroupName(categoryGroupName);

        pairs.add(pair1);

        List<Schema.DescribeDataCategoryGroupStructureResult> results = Schema.describeDataCategoryGroupStructures(pairs, false);
        
        for(DescribeDataCategoryGroupStructureResult singleResult : results){
            categoryNames2.add(singleResult.getName());
        }
        
        return results;
    }
    
    public static List<DescribeDataCategoryGroupResult> getDescribeDataCategoryGroup(){
        List<DescribeDataCategoryGroupResult> describeCategoryResult;
        try {
            //Creating the list of sobjects to use for the describe
            //call
            List<String> objType = new List<String>();
            objType.add('KnowledgeArticleVersion');
            //objType.add('Question');
        
            //Describe Call
            describeCategoryResult = Schema.describeDataCategoryGroups(objType);
   
            //Using the results and retrieving the information
            for(DescribeDataCategoryGroupResult singleResult : describeCategoryResult){
                //Getting the name of the category
                singleResult.getName();
                //Getting the name of label
                singleResult.getLabel();
                //Getting description
                singleResult.getDescription();
                //Getting the sobject
                singleResult.getSobject();
            }         
        } 
        catch(Exception e){
        }
        return describeCategoryResult;
    }
    
    
    //public static List<DescribeDataCategoryGroupStructureResult>
    public static List<DataCategory>
    //public static DataCategory []
    getDescribeDataCategoryGroupStructureResults(){
        List<DescribeDataCategoryGroupResult> describeCategoryResult;
        List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult;
        List<DataCategory> allCategories2;
        DataCategory [] toplevelCategories2;
        DataCategory [] childCategories2;
        try {
            //Making the call to the describeDataCategoryGroups to
            //get the list of category groups associated
            List<String> objType = new List<String>();
            objType.add('KnowledgeArticleVersion');
            //objType.add('Question');
            describeCategoryResult = Schema.describeDataCategoryGroups(objType);
         
            //Creating a list of pair objects to use as a parameter
            //for the describe call
            List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
         
            //Looping throught the first describe result to create
            //the list of pairs for the second describe call
            for(DescribeDataCategoryGroupResult singleResult : 
            describeCategoryResult){
                DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
                p.setSobject(singleResult.getSobject());
                p.setDataCategoryGroupName(singleResult.getName());
                pairs.add(p);
            }
         
            //describeDataCategoryGroupStructures()
            describeCategoryStructureResult = Schema.describeDataCategoryGroupStructures(pairs, false);

            //Getting data from the result
            for(DescribeDataCategoryGroupStructureResult singleResult : describeCategoryStructureResult){
                //Get name of the associated Sobject
                singleResult.getSobject();
                //Get the name of the data category group
                singleResult.getName();
                //Get the name of the data category group
                singleResult.getLabel();
                //Get the description of the data category group
                singleResult.getDescription();
                //Get the top level categories
                DataCategory [] toplevelCategories = singleResult.getTopCategories();
                toplevelCategories2 = toplevelCategories;
                //Recursively get all the categories
                List<DataCategory> allCategories = getAllCategories(toplevelCategories);
                allCategories2 = allCategories;

                for(DataCategory category : allCategories) {
                    //Get the name of the category
                    category.getName();
                    //Get the label of the category
                    category.getLabel();
                    //Get the list of sub categories in the category
                    DataCategory [] childCategories = category.getChildCategories();
                }
            }
        } 
        catch (Exception e){
        }
        //return describeCategoryStructureResult;
        return allCategories2;
        //return toplevelCategories2;
    }

    private static DataCategory[] getAllCategories(DataCategory [] categories){
        if(categories.isEmpty()){
            return new DataCategory[]{};
        } else {
            DataCategory [] categoriesClone = categories.clone();
            DataCategory category = categoriesClone[0];
            DataCategory[] allCategories = new DataCategory[]{category};
            categoriesClone.remove(0);
            categoriesClone.addAll(category.getChildCategories());
            allCategories.addAll(getAllCategories(categoriesClone));
            return allCategories;
        }
    }

}