//
//  UploadImageView.swift
//  SATTO
//
//  Created by 황인성 on 5/7/24.
//

import SwiftUI
import PhotosUI

struct UploadImageView: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    
    @EnvironmentObject var navPathFinder: EventNavigationPathFinder
    
    @State var selectedImage: UIImage? = nil
    @State var isImagePickerPresented = false
    @State var uploadImageAlert = false
    
    
    var body: some View {
        ZStack {
            
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: 0)
                
                Text("이벤트에 참여하기 위해\n학교 사진을 올려주세요!")
                    .font(.sb16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 28)
                    .padding(.top, 10)
                
                Button(action: {
                    isImagePickerPresented.toggle()
                }, label: {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .frame(width: 167, height: 173)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Rectangle()
                            .fill(Color(red: 0.85, green: 0.85, blue: 0.85))
                            .frame(width: 167, height: 173)
                            .cornerRadius(10)
                            .overlay(
                                VStack(spacing: 0) {
                                    Image(systemName: "plus")
                                        .foregroundColor(Color(red: 0.45, green: 0.47, blue: 0.5))
                                        .padding(.bottom, 14)
                                    
                                    Text("사진  선택")
                                        .font(.m14)
                                        .foregroundColor(Color(red: 0.45, green: 0.47, blue: 0.5))
                                }
                                    .padding(.top, 20)
                            )
                    }
                })
                .padding(.bottom, 26)
                
                Text("욕설, 비방 등 해당 주제와 관련 없는 내용은 통보 없이 삭제될 수 있습니다.")
                    .font(.m14)
                    .foregroundColor(Color(red: 0.45, green: 0.47, blue: 0.5))
                    .padding(.bottom, 36)
                
                Button(action: {
                    eventViewModel.uploadImage(UIImage: selectedImage!, category: eventViewModel.event?.category ?? "category") {
                        uploadImageAlert.toggle()
                    }
                }, label: {
                    Text("사진 등록하기")
                        .font(.sb16)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 69)
                        .padding(.vertical, 9)
                        .background(
                            Rectangle()
                                .fill(selectedImage == nil ? Color.gray : Color.blue)
                                .cornerRadius(8)
                        )
                })
                .disabled(selectedImage == nil)
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .sheet(isPresented: $isImagePickerPresented) {
            SingleImagePickerView(selectedImage: $selectedImage)
        }
        .alert("이벤트 참여되었습니다.", isPresented: $uploadImageAlert) {
            Button("OK", role: .cancel) {
                navPathFinder.path.popLast()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton()
                CustomNavigationTitle(title: "이벤트")
            }
        }
    }
}


struct SingleImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1 // Limit selection to 1 image
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: SingleImagePickerView
        
        init(_ parent: SingleImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let result = results.first {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let error = error {
                            print("Error loading image: \(error.localizedDescription)")
                        } else if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImage = image
                            }
                        }
                    }
                }
            }
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    UploadImageView(eventViewModel: EventViewModel())
}
