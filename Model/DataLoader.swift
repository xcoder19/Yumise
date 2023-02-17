

import Foundation


public class DataLoader {
    
    @Published var foodAdditives = [Additive]()
    @Published var foodAdditivesDescription = [String]()
    
    init() {
        load()
    }
    func load()  {
        if let fileLocation = Bundle.main.url(forResource: "additives", withExtension: "json")  {
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([Additive].self, from: data)
                self.foodAdditives = dataFromJson
                dataFromJson.forEach { additive in
                    self.foodAdditivesDescription.append(additive.descriptionAdditive)
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    
}
