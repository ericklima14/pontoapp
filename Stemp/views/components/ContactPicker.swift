//
//  ContactPicker.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 17/02/26.
//

import SwiftUI
import ContactsUI

struct ContactPicker: UIViewControllerRepresentable{
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        
        picker.predicateForEnablingContact = NSPredicate(
            format: "imageDataAvailable == YES"
        )
        
        return picker
    }
    
    static func fetchMeCard(emailAddress: String, completion: @escaping (CNContact?) -> Void) {
        let store = CNContactStore()
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .notDetermined:
            store.requestAccess(for: .contacts) { (granted, error) in
                if granted {
                    performFetch(email: emailAddress, store: store, completion: completion)
                } else {
                    completion(nil)
                }
            }
        case .authorized:
            performFetch(email: emailAddress, store: store, completion: completion)
        default:
            completion(nil)
        }
    }
    
    private static func performFetch(email: String, store: CNContactStore, completion: @escaping (CNContact?) -> Void){
        let keysToFetch = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactImageDataKey,
            CNContactImageDataAvailableKey
        ] as [CNKeyDescriptor]
        
        let identifier = CNContact.predicateForContacts(matchingEmailAddress: email)
        
        do{
            let contacts = try store.unifiedContacts(matching: identifier, keysToFetch: keysToFetch)
            completion(contacts.first)
        } catch {
            completion(nil)
        }
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPicker

        init(_ parent: ContactPicker) {
            self.parent = parent
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            if let imageData = contact.imageData {
                parent.selectedImage = UIImage(data: imageData)
            }
        }
    }
}
