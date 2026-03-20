//
//  ProfileSetupViewModel.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 13/03/26.
//

import Foundation
import SwiftUI

class ProfileSetupViewModel: ObservableObject {
    @AppStorage("name") private var name: String = ""
    @AppStorage("studentId") private var studentId: String = ""
    private var webService = WebService()
    private var dropboxService = DropboxService()
    
    func saveProfileImage(profileImage: UIImage) {
        guard let data = profileImage.pngData() else { return }
        let fileName = "\(name.trimingWhitespaces())-memoji.png"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let filePath = path.first?.appendingPathComponent(fileName){
            do {
                try data.write(to: filePath)
                UserDefaults.standard.set(fileName, forKey: "profileImageName")
            } catch {
                print("Erro ao salvar memoji: \(error.localizedDescription)")
            }
        }
    }
    
    static func loadImageFromDisk() -> UIImage? {
        guard let fileName = UserDefaults.standard.string(forKey: "profileImageName") else { return nil }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let filePath = paths.first?.appendingPathComponent(fileName) {
            return UIImage(contentsOfFile: filePath.path)
        }
        return nil
    }
    
    func sendMemojiToDropbox(completion: @escaping(Bool) -> Void) {
        guard let fileName = UserDefaults.standard.string(forKey: "profileImageName") else {
            print("Não foi possivel recuperar o memoji para ser enviado para o airtable")
            completion(false)
            return
        }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let filePath = paths.first?.appendingPathComponent(fileName) else {
            completion(false)
            return
        }
        
        do {
            let fileData = try Data(contentsOf: filePath)
            
            dropboxService.uploadFileAndGetLink(studentId: studentId, studentName: name, fileData: fileData, fileName: fileName) { [weak self] urlResult in
                
                guard let self = self else { return }
                
                if let url = urlResult {
                    print("Upload concluído! URL: \(url)")
                    
                    self.webService.updateStudentMemoji(recordId: self.studentId, memojiPublicUrl: url){ [weak self] result in
                    
                        guard let self = self else { return }
                        
                        switch result {
                            case .success:
                                print("Memoji do aluno \(self.name) foi adicionado com sucesso!")
                                completion(true)
                            case .failure(let error):
                                print("Falha ao adicionar o Memoji do aluno \(self.name): \(error.localizedDescription)")
                                completion(false)
                            
                        }
                    }
                } else {
                    print("Falha ao subir o memoji para o Dropbox.")
                    completion(false)
                }
            }
        } catch {
            print("Erro ao ler os bytes da imagem do disco: \(error.localizedDescription)")
            completion(false)
        }
    }
}
