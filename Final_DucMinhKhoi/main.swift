//
//  main.swift
//  Final_DucMinhKhoi
//
//  Created by Duc Minh Khoi Tran on 2025-01-22.
//

import Foundation

protocol PropertyDescription {
    func showDetails()
    func calculateCommission() -> Double
}

// Property Class
class Property {
    let propertyID: String
    let address: String
    let area: Double
    var sellingPrice: Double
    var sellingAgent: Agent?
    
    init?(propertyID: String, address: String, area: Double, sellingPrice: Double, sellingAgent: Agent? = nil) {
        
        guard area > 0, sellingPrice > 0 else { return nil }
        self.propertyID = propertyID
        self.address = address
        self.area = area
        self.sellingPrice = sellingPrice
        self.sellingAgent = sellingAgent
    }
}


// Residential Property
class ResidentialProperty: Property, PropertyDescription {
    let numberOfBedrooms: Int
    let numberOfBathrooms: Int
    let propertyType: String
    
    init?(propertyID: String, address: String, area: Double, sellingPrice: Double, numberOfBedrooms: Int, numberOfBathrooms: Int, propertyType: String, sellingAgent: Agent? = nil) {
        
        guard numberOfBedrooms > 0, numberOfBathrooms > 0, !propertyType.isEmpty else { return nil }
        self.numberOfBedrooms = numberOfBedrooms
        self.numberOfBathrooms = numberOfBathrooms
        self.propertyType = propertyType
        
        super.init(propertyID: propertyID, address: address, area: area, sellingPrice: sellingPrice, sellingAgent: sellingAgent)
    }
    
    func showDetails() {
        print("""
        Residential Property:
        ID: \(propertyID),Address: \(address), Area: \(area) sqf, Price: \(sellingPrice), Bedrooms: \(numberOfBedrooms), Bathrooms: \(numberOfBathrooms), Type: \(propertyType)
        """)
    }
    
    func calculateCommission() -> Double {
        return sellingPrice * 0.05
    }
}

// Commercial Property
class CommercialProperty: Property, PropertyDescription {
    
    
    var numberOfShelves: Int
    var numberOfExits: Int
    var numberOfStoreys: Int
    var propertyType: String
    
    init?(propertyID: String, address: String, area: Double, sellingPrice: Double, numberOfShelves: Int, numberOfExits: Int, numberOfStoreys: Int, propertyType: String, sellingAgent: Agent? = nil) {
        guard numberOfShelves >= 0, numberOfExits > 0, numberOfStoreys > 0 else { return nil }
        self.numberOfShelves = numberOfShelves
        self.numberOfExits = numberOfExits
        self.numberOfStoreys = numberOfStoreys
        self.propertyType = propertyType
        super.init(propertyID: propertyID, address: address, area: area, sellingPrice: sellingPrice, sellingAgent: sellingAgent)
    }
    
    func showDetails() {
        print("""
        Commercial Property:
        ID: \(propertyID), Address: \(address), Area: \(area) sqft, Price: \(sellingPrice), Shelves: \(numberOfShelves), Exits: \(numberOfExits), Storeys: \(numberOfStoreys), Type: \(propertyType)
        """)
    }
    
    func calculateCommission() -> Double {
        return sellingPrice * 0.05
    }
}

class Agent {
    let agentID: String
    let name: String
    let email: String
    var propertiesSelling: [Property]
    var propertiesBuying: [Property]
    var totalCommissionEarned: Double
    
    init(agentID: String, name: String, email: String) {
        self.agentID = agentID
        self.name = name
        self.email = email
        self.propertiesSelling = []
        self.propertiesBuying = []
        self.totalCommissionEarned = 0.0
    }
    
    func sellProperty(property: Property) {
        guard property.sellingAgent?.agentID == self.agentID else {
            print("Error: This property is not assigned to this agent for selling.")
            
            return
        }
        
        propertiesSelling.append(property)
        totalCommissionEarned += property.sellingPrice * 0.05
        print("\(name) successfully sold property \(property.propertyID).")
    }
    
    func buyProperty(property: Property) {
        guard property.sellingAgent != nil else {
            print("Error: This property does not have a selling agent.")
            return
        }
        
        guard !propertiesSelling.contains(where: { $0.propertyID == property.propertyID }) else {
            print("Error: Agent cannot buy a property they are selling.")
            return
        }
        propertiesBuying.append(property)
        print("\(name) successfully bought property \(property.propertyID).")
    }
    func showDetails() {
            print("""
            Agent Details:
            ID: \(agentID), Name: \(name), Email: \(email), Total Commission Earned: \(totalCommissionEarned)
            Selling Properties: \(propertiesSelling.map { $0.propertyID })
            Buying Properties: \(propertiesBuying.map { $0.propertyID })
            """)
        }
}

class Manager {
    var properties: [Property]
    
    init() {
        self.properties = []
    }
    
    func addProperty(_ property: Property) {
        properties.append(property)
    }
    
    func removeProperty(propertyID: String) {
        properties.removeAll(where: { $0.propertyID == propertyID })
    }
    
    func updateProperty(propertyID: String, newProperty: Property) {
        if let index = properties.firstIndex(where: { $0.propertyID == propertyID }) {
            properties[index] = newProperty
        }
    }
    
    func assignAgent(to propertyID: String, agent: Agent) {
        guard let property = properties.first(where: { $0.propertyID == propertyID }) else {
            print("ERROR: Property with ID \(propertyID) not found.")
            return
        }
        property.sellingAgent = agent
        print(property.propertyID, "has been assigned to", agent.name)
        
    }
    
    func searchProperties(byType type: String? = nil, address: String? = nil, maxPrice: Double? = nil) -> [Property] {
        return properties.filter { property in
            (type == nil || (property is ResidentialProperty && (property as! ResidentialProperty).propertyType == type) ||
             (property is CommercialProperty && (property as! CommercialProperty).propertyType == type))
            && (address == nil || property.address.contains(address!))
            && (maxPrice == nil || property.sellingPrice <= maxPrice!)
        }
    }
    
    func showAllPropertiesSorted() {
        let sortedProperties = properties.sorted { $0.sellingPrice < $1.sellingPrice }
        for property in sortedProperties {
            if let residential = property as? ResidentialProperty {
                residential.showDetails()
            } else if let commercial = property as? CommercialProperty {
                commercial.showDetails()
            }
        }
    }
}

// Main program with hardcoded data

// Create Residential Properties
let res1 = ResidentialProperty(propertyID: "#R001", address: "123 Dufferin Road", area: 1233, sellingPrice: 700000, numberOfBedrooms: 3, numberOfBathrooms: 2, propertyType: "Town House")
let res2 = ResidentialProperty(propertyID: "#R002", address: "31 Dewry Road", area: 120, sellingPrice: 1500000, numberOfBedrooms: 7, numberOfBathrooms: 5, propertyType: "Single House")
let resInvalid = ResidentialProperty(propertyID: "#R003", address: "892 Yonge Street", area: -156, sellingPrice: -600000, numberOfBedrooms: 0, numberOfBathrooms: 0, propertyType: "" ) // Invalid

// Create Commercial Properties
let com1 = CommercialProperty(propertyID: "#C001", address: "101 Daveford Rd", area: 3124, sellingPrice: 1000000, numberOfShelves: 50, numberOfExits: 4, numberOfStoreys: 1, propertyType: "Warehouse")!
let com2 = CommercialProperty(propertyID: "#C002", address: "202 Queen St", area: 3000, sellingPrice: 750000, numberOfShelves: 20, numberOfExits: 2, numberOfStoreys: 2, propertyType: "Store")!
let comInvalid = CommercialProperty(propertyID: "#C003", address: "123 Woodbine Ave", area: 1500, sellingPrice: 400000, numberOfShelves: -5, numberOfExits: 0, numberOfStoreys: 1, propertyType: "") // Invalid

// Create Agents
let agent1 = Agent(agentID: "#A001", name: "Bryan", email: "Bryan@gmail.com")
let agent2 = Agent(agentID: "#A002", name: "Khoi", email: "Khoi@gmail.com")
let agent3 = Agent(agentID: "#A003", name: "Hannah", email: "Hannah@gmail.com")

// Manager
let manager = Manager()

print("\n--------- Demo ----------\n")

// Add Properties
manager.addProperty(res1!)
manager.addProperty(res2!)
manager.addProperty(com1)
manager.addProperty(com2)

// Assign agents and add Properties
manager.assignAgent(to: "#R001", agent: agent1)
manager.assignAgent(to: "#C002", agent: agent1)
manager.assignAgent(to: "#R002", agent: agent2)
manager.assignAgent(to: "#C001", agent: agent2)



// Show all properties sorted
print("\n--- All Properties Sorted by Price ---\n")
manager.showAllPropertiesSorted()

// Modify an attribute of a property
res1?.sellingPrice = 750000
print("\n--- Modified Property ---")
res1?.showDetails()

// Delete a property
manager.removeProperty(propertyID: "#R002")

print("\n--- All Properties After Deletion ---\n")
manager.showAllPropertiesSorted()

// Search for properties
let searchedProperties = manager.searchProperties(byType: "Warehouse", address: nil, maxPrice: 1800000)
print("Search Results:")
if searchedProperties.isEmpty {
    print( "No properties found." )
} else {
    for property in searchedProperties {
        if let residential = property as? ResidentialProperty {
            residential.showDetails()
        } else if let commercial = property as? CommercialProperty {
            commercial.showDetails()
        }
    }
}

// Agent selling a property
print("\n--- Agent Selling Property ---")
agent1.sellProperty(property: res1!)

// Agent successfully buy properties
print("\n--- Agent Successfully Buying Property ---")
agent1.buyProperty(property: com1)


// Agent unsuccessfully buy a properties
print("\n--- Agent Unsuccessfully Buying Property ---")
agent1.buyProperty(property: res1!)

// Show highest earning agent
print("\n--- Highest Earning Agent ---")
let highestEarningAgent = [agent1, agent2, agent3].max(by: { $0.totalCommissionEarned < $1.totalCommissionEarned })
if let agent = highestEarningAgent {
    agent.showDetails()
} else {
    print( "No agent available." )
}



print("\n===========================================\n")








