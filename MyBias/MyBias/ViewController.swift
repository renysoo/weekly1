//
//  ViewController.swift
//  MyBias
//
//  Created by René Melo de Lucena on 20/02/19.
//  Copyright © 2019 René Melo de Lucena. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    @IBOutlet weak var groupTableView: UITableView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupBias: UILabel!
    @IBOutlet weak var groupSong: UILabel!
    
    var groups: [NSManagedObject] = []
    var chosenGroup = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Group")
        do {
            groups = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addBiasSong1(_ sender: Any) {
        let alert = UIAlertController(title:"Bias", message: "Qual seu bias no \(groups[chosenGroup].value(forKey: "name") ?? "0")", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Salvar",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        
                                        self.saveBias(name: nameToSave)
                                        
        }
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        reloadNames()
    }
    
    @IBAction func addSong(_ sender: Any) {
        let alert = UIAlertController(title:"Musica", message: "Qual sua música favorita do \(groups[chosenGroup].value(forKey: "name") ?? "0")", preferredStyle: .alert)
                        let saveAction = UIAlertAction(title: "Salvar",
                                                       style: .default) {
                                                        [unowned self] action in
        
                                                        guard let textField = alert.textFields?.first,
                                                            let nameToSave = textField.text else {
                                                                return
                                                        }
        
                                                        self.saveSong(name: nameToSave)
                                                        self.reloadNames()
                        }
                        let cancelAction = UIAlertAction(title: "Cancelar",
                                                         style: .cancel)
                        alert.addTextField()
                        alert.addAction(saveAction)
                        alert.addAction(cancelAction)
                        present(alert, animated: true)
    }
    
    @IBAction func addGroup(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Novo grupo",
                                      message: "Diga um dos seus grupos preferidos",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Salvar",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        
                                        self.save(name: nameToSave)
                                        self.groupTableView.reloadData()
                                        print(self.groups)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func reloadNames(){
        groupName.text = groups[chosenGroup].value(forKeyPath: "name") as? String
        groupBias.text = (groups[chosenGroup].value(forKeyPath: "bias") as? NSManagedObject)?.value(forKeyPath: "name") as? String
        groupSong.text = (groups[chosenGroup].value(forKeyPath: "song") as? NSManagedObject)?.value(forKeyPath: "name") as? String
}
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Group",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            groups.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveBias(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Bias",
                                       in: managedContext)!
        
        let bias = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        bias.setValue(name, forKeyPath: "name")
        bias.setValue(groups[chosenGroup], forKey: "group1")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveSong(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Song",
                                       in: managedContext)!
        
        let song = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        song.setValue(name, forKeyPath: "name")
        song.setValue(groups[chosenGroup], forKey: "group")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupTableView.isEditing = false
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        chosenGroup = indexPath.section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = group.value(forKeyPath: "name") as? String
        return cell
    }
}
