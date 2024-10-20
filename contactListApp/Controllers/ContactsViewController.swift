//
//  ContactsViewController.swift
//  contactListApp
//
//  Created by ntvlbl on 19.10.2024.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CreateContactDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UISearchBar!

    var contacts: [Contact] = []
    var data = [Contact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        
        loadContacts() //пихаю все в юзердефолтс чтобы сохраненные контакты были видны

        tableView.delegate = self
        tableView.dataSource = self
        search.delegate = self
        data = contacts
        tableView.reloadData() //апдейт страницы после добавления контакта
    }


    func didCreateContact(_ contact: Contact) {
        contacts.append(contact) //пихаем все в массив
        data = contacts //данные обн
        tableView.reloadData() //обнова тэйбл вью
        saveContacts()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    } //возвращение количества строкк

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        return cell
    } //яечйки чтобы отображать контакты



    func saveContacts() {
        let encoder = JSONEncoder() //создать джсон чтобы сохранять данные в юзер деыолтс
        if let encoded = try? encoder.encode(contacts) { //кодируем кконтакты и сохраняем
            UserDefaults.standard.set(encoded, forKey: "contacts")
        }
    }

 //загрузка уже сохраненных контактов
    func loadContacts() {
        if let savedContacts = UserDefaults.standard.object(forKey: "contacts") as? Data { //чек есть ли данные или нет
            let decoder = JSONDecoder() //декодирование
            if let loadedContacts = try? decoder.decode([Contact].self, from: savedContacts) {
                contacts = loadedContacts
            }
        } else {
            contacts = [ 
                Contact(name: "John Doe", phoneNumber: "123-456-7890", company: "Example Inc", email: "john@example.com"),
                Contact(name: "Jane Smith", phoneNumber: "098-765-4321", company: "Sample LLC", email: "jane@example.com")
            ]
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createContactSegue" {
            let createContactVC = segue.destination as! CreateContactViewController
            createContactVC.delegate = self
        }
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            data = contacts
        } else {
            data = contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }

}
