//
//  AsyncLet.swift
//  SwiftConcurrency
//
//  Created by Darie-Nistor Nicolae on 19.07.2023.
//

import SwiftUI

struct AsyncLet: View {
    
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/200")!
    var body: some View {
        NavigationView  {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let")
            .onAppear {
                Task {
                    do {
                        
                        async let fetchImage = getImage()
                        async let fetchImage2 = getImage()
                        async let fetchImage3 = getImage()
                        async let fetchImage4  = getImage()
                        
                        let (image1, image2, image3, image4) = try await (fetchImage, fetchImage2, fetchImage3, fetchImage4)
                        self.images.append(contentsOf: [image1, image2, image3 , image4])
                        
//                        let image1 = try await getImage()
//                        self.images.append(image1)
//
//                        let image2 = try await getImage()
//                        self.images.append(image2)
                        
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func getImage() async throws -> UIImage {
        do {
            let (data, _ ) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }

    
    struct AsyncLet_Previews: PreviewProvider {
        static var previews: some View {
            AsyncLet()
        }
    }
}
