@IsTest
public class animalResponse_Test {
    
    static testMethod void testParse() {
        String json = '{\"animal\":{\"id\":2,\"name\":\"bear\",\"eats\":\"berries, campers, adam seligman\",\"says\":\"yum yum\"}}';
        animalResponse obj = animalResponse.parse(json);
        System.assert(obj != null);
    }
}