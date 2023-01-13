//
//  ViewController.swift
//  BasicExample
//
//  Created by Deepa on 26/12/22.
//

import UIKit
import Segment

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Unique Id for Segment
        Analytics.main.identify(userId: "Deepa")
    }

    func getFormattedDate() -> String? {
        let format = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
            cell.titleLabel.text = Rows.allCases[indexPath.row].rawValue
            return cell
        }
        return UITableViewCell()
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentRowSelected = Rows.allCases[indexPath.row]
        switch currentRowSelected {
        case .setAlias:
            Analytics.main.alias(newId: "MoEngage-Alias")
        case .setPhone:
            let phoneTrait = ["phone": "1-234-5678"]
            Analytics.main.identify(traits: phoneTrait)
        case .setGender:
            let genderTrait = ["gender": "male"]
            Analytics.main.identify(traits: genderTrait)
        case .setLastName:
            let lastNameTrait = ["lastName": "lnu"]
            Analytics.main.identify(traits: lastNameTrait)
        case .setFirstName:
            let firstNameTrait = ["firstName": "fnu"]
            Analytics.main.identify(traits: firstNameTrait)
            Analytics.main.identify(traits: firstNameTrait)
        case .setEmail:
            let emailTrait = ["email": "moe@test.com"]
            Analytics.main.identify(traits: emailTrait)
        case .setBirthdate:
            let birthdayTrait = ["birthday": Date()]
            Analytics.main.identify(traits: birthdayTrait)
        case .setisoBirthDay:
            let isoBirthdayTrait = ["isoBirthday": getFormattedDate()]
            Analytics.main.identify(traits: isoBirthdayTrait)
        case .setisoDate:
            let isoDateTrait = ["isoDate": getFormattedDate()]
            Analytics.main.identify(traits: isoDateTrait)
        case .setLocation:
            let locationTrait = ["location": ["latitude":74.0, "longitude": 78.0]]
            Analytics.main.identify(traits: locationTrait)
        case .trackEvents:
            var events = [String:Any]()
            events["dupe"] = "default"
            events["general"] = "value"
            events["audioPlayed"] = "Dangerous"
            events["artist"] = "David Garrett"
            events["testDate"] = getFormattedDate()
            events["testDate2"] = getFormattedDate()
            Analytics.main.track(name: "Test_123", properties: events)
        case .flush:
            Analytics.main.flush()
        case .resetUser:
            Analytics.main.reset()
        }
        
    }
}

enum Rows: String, CaseIterable {
    case setAlias = "Set Alias"
    case setPhone = "Set Phone Number"
    case setGender = "Set Gender"
    case setLastName = "Set LastName"
    case setFirstName = "Set FirstName"
    case setEmail = "Set Email"
    case setBirthdate = "Set Birthday"
    case setisoBirthDay = "Set ISO birthday"
    case setisoDate = "Set ISO date"
    case setLocation = "Set Location"
    case trackEvents = "Track Events"
    case flush = "Flush Data"
    case resetUser = "Reset User"
}
