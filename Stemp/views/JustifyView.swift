//
//  JustifyAbstenceView.swift
//  pontoapp
//
//  Created by Erick Costa on 03/11/25.
//

import SwiftUI

struct JustifyView: View {
    let titleText: String
    let subtitleText: String
    
    @State private var isImporting: Bool = false
    @State var text: String = ""
    
    let gradientColors: LinearGradient = LinearGradient(gradient: Gradient(colors: [.gradientStart, .gradientEnd]), startPoint: .leading, endPoint: .trailing)
    
    @State var selectedFiles: [AttachmentModel] = []
    @State private var isSending: Bool = false
    @State private var submitErrorMessage: String?
    @State private var attachmentErrorMessage: String?
    @Environment(\.dismiss) private var dismiss
    
    let sendJustify: (String, [AttachmentModel]) async throws -> Void
    
    @FocusState private var isFocused: Bool
    
    private func submitJustify() async {
        isSending = true
        defer {
            isSending = false
        }
        submitErrorMessage = nil
        
        do {
            try await sendJustify(text, selectedFiles)
            dismiss()
        } catch {
            submitErrorMessage = error.localizedDescription
        }
        
    }
    
    private var counterColor: Color {
        let remaining = JustificationRules.maxCharacters - text.count
        
        if remaining <= 0 {
            return .red
        } else if remaining <= 50 {
            return .orange
        } else {
            return .white.opacity(0.6)
        }
    }

    
    var body: some View {
        VStack(spacing: 25){
            Text(titleText)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 15){
                HStack(spacing: 5){
                    Text("\(subtitleText)")
                        .font(.headline.bold())
                        .foregroundStyle(.white.opacity(0.6))
                    Text("*")
                        .font(.headline.bold())
                        .foregroundStyle(.red.opacity(0.6))
                }
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
                    .onChange(of: text) { _, newValue in
                        if newValue.count > JustificationRules.maxCharacters {
                            text = String(newValue.prefix(JustificationRules.maxCharacters))
                        }
                    }
                    
                
                HStack {
                    Spacer()
                    Text("\(text.count)/\(JustificationRules.maxCharacters)")
                        .font(.caption)
                        .foregroundStyle(counterColor)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.2), value: text.count)
                }
                .padding(.horizontal, 20)
                
                HStack(spacing: 5){
                    Text("*")
                        .font(.headline.bold())
                        .foregroundStyle(.red.opacity(0.6))
                    Text("Campo obrigatório a ser preenchido")
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.6))
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.2), value: text.count)
                    Spacer()
                }
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
                            ForEach(selectedFiles) { attachment in
                                FileRowView(attachment: attachment) {
                                    removeFile(attachment)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .padding(.horizontal, 15)
                    .frame(maxHeight: 300)
                }
            }
            
            if let message = attachmentErrorMessage {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.red.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                YellowButtonView(disabled: text.trimmingCharacters(in: .whitespacesAndNewlines).count < JustificationRules.minimumCharacters || isSending, text: "Enviar para Análise", iconImage: "person.fill.checkmark") {
                    await submitJustify()
                }
                
                if let message = submitErrorMessage {
                    Text("Não foi possivel enviar a justificativa agora. Tente novamente! \(message)")
                        .font(.subheadline)
                        .foregroundStyle(.red.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
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
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            isFocused = false
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if isFocused{
                    Button("Concluir") {
                        isFocused = false
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.85)))
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isFocused)
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.pdf, .image, .text], allowsMultipleSelection: true) {
            result in
            
            attachmentErrorMessage = nil
            
            switch result {
            case .success(let urls):
                guard urls.isEmpty == false else { return }
                
                var attachments: [AttachmentModel] = []
                var failedFileNames: [String] = []
                
                for url in urls {
                    do {
                        let attach = try AttachmentModel(url: url)
                        attachments.append(attach)
                    } catch {
                        failedFileNames.append(url.lastPathComponent)
                    }
                }
                
                self.selectedFiles.append(contentsOf: attachments)
                
                if !failedFileNames.isEmpty {
                    attachmentErrorMessage = "Não foi possível anexar os seguintes arquivos: \(failedFileNames.joined(separator: ", "))"
                }
                
            case .failure(let error):
                attachmentErrorMessage = error.localizedDescription
            }
        }
    }
    
    func removeFile(_ attachment: AttachmentModel) {
        selectedFiles.removeAll(where: {
            $0.id == attachment.id
        })
    }
}

#Preview {
    JustifyView(titleText: "Justificar Ausência", subtitleText: "MOTIVO DA SUA AUSÊNCIA", text: "Placeholder", selectedFiles: []){ text, file in
        
    }
}

