//
//  UploadView.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 11/11/2025.
//

import SwiftUI
import PhotosUI

struct UploadView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var birdName = ""
    @State private var photographer = ""
    @State private var selectedLicense = ImageLicense.ccBy
    @State private var photographerLink = ""
    @State private var birdLink = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var isUploading = false
    @State private var uploadSuccess = false
    @State private var errorMessage: String?
    @State private var showAlert = false
    
    var isFormValid: Bool {
        !birdName.isEmpty &&
        !photographer.isEmpty &&
        !photographerLink.isEmpty &&
        !birdLink.isEmpty &&
        selectedImage != nil
    }
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading, spacing: 25){
                    // Header
                    VStack(spacing: 10){
                        Image(systemName: "square.and.arrow.up.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.purple)
                        
                        Text("Upload Bird Photo")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Share your bird photo with the community")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    
                    // Image selection
                    VStack(alignment: .leading, spacing: 10){
                        Text("Photo")
                            .font(.headline)
                        
                        if let image = selectedImage {
                            ZStack(alignment: .topTrailing){
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                    .cornerRadius(15)
                                
                                Button(action: {
                                    selectedImage = nil
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding(10)
                            }
                        } else {
                            VStack(spacing: 15){
                                Button(action: {
                                    showImagePicker = true
                                }) {
                                    VStack(spacing: 10){
                                        Image(systemName: "photo.on.rectangle.angled")
                                            .font(.largeTitle)
                                        Text("Choose from library")
                                            .fontWeight(.medium)
                                    }
                                    .foregroundStyle(.purple)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 100)
                                    .background(Color.purple.opacity(0.1))
                                    .cornerRadius(15)
                                    
                                }
                                
                                Button(action: {
                                    showCamera = true
                                }) {
                                    VStack(spacing: 10){
                                        Image(systemName: "camera.fill")
                                            .font(.largeTitle)
                                        Text("Take Photo")
                                            .fontWeight(.medium)
                                    }
                                    .foregroundStyle(.purple)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 100)
                                    .background(Color.purple.opacity(0.1))
                                    .cornerRadius(15)
                                }
                            }
                        }
                    }
                    
                    // Form fields
                    VStack(alignment: .leading, spacing: 20){
                        FormField(
                            label: "Bird Name",
                            icon: "bird.fill",
                            placeholder: "e.g., American Robin",
                            text: $birdName
                        )
                        
                        FormField(
                            label: "Photographer",
                            icon: "person.fill",
                            placeholder: "Your name",
                            text: $photographer
                        )
                        
                        VStack(alignment: .leading, spacing: 8){
                            Label("license", systemImage: "doc.text.fill")
                                .font(.headline)
                            
                            Picker("License", selection: $selectedLicense){
                                ForEach(ImageLicense.allCases, id: \.self){
                                    license in
                                    Text(license.rawValue).tag(license)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                        
                        FormField(
                            label: "Photographer Link",
                            icon: "link",
                            placeholder: "https://...",
                            text: $photographerLink
                        )
                        
                        FormField(
                            label: "Bird Wikipedia Link",
                            icon: "link",
                            placeholder: "https://en.wikipedia.org/wiki/...",
                            text: $birdLink
                        )
                    }
                    
                    // Upload button
                    Button(action : uploadBird){
                        HStack {
                            if isUploading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "arrow.up.circle.fill")
                                Text("Upload Bird")
                                    .fontWeight(.semibold)
                            }
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.purple : Color.gray)
                        .cornerRadius(15)
                    }
                    .disabled(!isFormValid || isUploading)
                    
                    // Info notic
                    HStack(alignment: .top, spacing: 10){
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.blue)
                        Text("By uploading, you confirm you have the rights to share this image under the selected license.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Upload")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showImagePicker){
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
            }
            .sheet(isPresented: $showCamera){
                ImagePicker(image: $selectedImage, sourceType: .camera)
            }
            .alert(uploadSuccess ? "Success" : "Error", isPresented: $showAlert){
                Button("OK"){
                    if uploadSuccess {
                        dismiss()
                    }
                }
            } message: {
                Text(uploadSuccess ? "Your bird photo has been uploaded successfully!" : errorMessage ?? "Upload failed")
            }
        }
    }
    
    private func uploadBird() {
        guard let image = selectedImage else {
            return
        }
        
        isUploading = true
        
        NetworkService.shared.uploadBirdImage(
            name: birdName,
            image: image,
            photographerName: photographer,
            license: selectedLicense.rawValue,
            photographerLink: photographerLink,
            birdLink: birdLink,
            completion: { [self] result in
                DispatchQueue.main.async {
                    isUploading = false
                    
                    switch result {
                    case .success:
                        uploadSuccess = true
                        showAlert = true
                    case .failure(let error):
                            uploadSuccess = false
                        errorMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            })
    }
}

// Form Field Component
struct FormField: View {
    let label: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
                Label(label, systemImage: icon)
                    .font(.headline)
                
                TextField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
        }
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss
    let sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
            if let image = info[.originalImage] as? UIImage{
                parent.image = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    UploadView()
}
