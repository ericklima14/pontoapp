//
//  JustifyAbstenceView.swift
//  pontoapp
//
//  Created by Erick Costa on 03/11/25.
//

import SwiftUI

struct JustifyView: View {
    @State var titleText: String
    @State var subtitleText: String
    
    @State private var isImporting: Bool = false
    @State var text: String = ""
    
    let gradientColors: LinearGradient = LinearGradient(gradient: Gradient(colors: [.gradientStart, .gradientEnd]), startPoint: .leading, endPoint: .trailing)
    
    @State var selectedFiles: [URL] = []
    
    var sendJustify: (String, [URL]) -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 25){
            Text(titleText)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 15){
                Text(subtitleText)
                    .font(.headline.bold())
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.horizontal, 20)
                
                TextEditor(text: $text)
                    .focused($isFocused)
                    .padding(10)
                    .frame(maxHeight: 200)
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .background(.bg900)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
            }
            
            Button{
                isImporting = true
            } label: {
                HStack(){
                    Image(systemName: "slider.horizontal.3")
                    Text("Adicionar Arquivos")
                }
                .foregroundStyle(gradientColors)
                .frame(maxWidth: .infinity, minHeight: 50)
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(gradientColors, lineWidth: 1)
                }
                .padding(.horizontal, 20)
                
            }
            
            if !selectedFiles.isEmpty {
                VStack(alignment: .leading, spacing: 5){
                    Text("Arquivos Selecionados:")
                        .font(.headline.bold())
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.horizontal, 20)
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 8) {
                            ForEach(selectedFiles, id: \.self) { url in
                                FileRowView(url: url) {
                                    removeFile(url)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .padding(.horizontal, 15)
                    .frame(maxHeight: 300)
                }
            }
            
            Spacer()
            
            
            YellowButtonView(disabled: .constant(false), text: "Enviar para Análise", iconImage: "person.fill.checkmark"){
                sendJustify(text, selectedFiles)
            }
            .padding(.bottom, 15)
            
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bg950)
        .onTapGesture {
            isFocused = false
        }
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.pdf, .image, .png, .jpeg, .text], allowsMultipleSelection: true){
            result in
            
            switch result {
            case .success(let urls):
                guard urls.isEmpty == false else { return }
                
                DispatchQueue.main.async {
                    self.selectedFiles.append(contentsOf: urls)
                }
                
            case .failure(let error):
                print("Erro ao adicionar os arquivos: \(error.localizedDescription)")
            }
        }
    }
    
    func removeFile(_ url: URL) {
        if let index = selectedFiles.firstIndex(of: url) {
            _ = withAnimation {
                selectedFiles.remove(at: index)
            }
        }
    }
}

#Preview {
    JustifyView(titleText: "Justificar Ausência", subtitleText: "MOTIVO DA SUA AUSÊNCIA", text: "Placeholder", selectedFiles: [URL(filePath: "alguma coisa"), URL(filePath: "alguma coisa"), URL(filePath: "alguma coisa")]){ text, file in
        
    }
}

