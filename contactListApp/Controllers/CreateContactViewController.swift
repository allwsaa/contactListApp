import UIKit

protocol CreateContactDelegate: AnyObject {
    func didCreateContact(_ contact: Contact)
}

class CreateContactViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var addPhone: UITextField!
    @IBOutlet weak var addGmail: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    weak var delegate: CreateContactDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        doneButton.isEnabled = false
        
        
        firstName.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        addPhone.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
    }

    //кнопка не будет работтаь пока не пройдет проверку заполнения данных
    @objc func textFieldsChanged() {
        if let firstNameText = firstName.text, !firstNameText.isEmpty,
           let lastNameText = lastName.text, !lastNameText.isEmpty,
           let phoneText = addPhone.text, !phoneText.isEmpty {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }

    @IBAction func saveContact(_ sender: Any) {

        guard let firstName = firstName.text, !firstName.isEmpty,
              let lastName = lastName.text, !lastName.isEmpty,
              let phone = addPhone.text, !phone.isEmpty else {
            return
        }

        let newContact = Contact(
            name: firstName,
            phoneNumber: phone,
            company: company.text ?? "No Company",
            email: addGmail.text ?? "No Email"
        )

        guard let delegate = delegate else {
                print("delegate is nil")
                return
            }
            
            delegate.didCreateContact(newContact)

            navigationController?.popViewController(animated: true)
    }
}
