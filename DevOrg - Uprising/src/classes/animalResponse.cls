public class animalResponse {
    public Animal animal;

    public class Animal {
        public String Id;
        public String Name;
        public String Eats;
        public String Says;
    }

    public static animalResponse parse(String json) {
        return (animalResponse)System.JSON.deserialize(json, animalResponse.class);
    }
}