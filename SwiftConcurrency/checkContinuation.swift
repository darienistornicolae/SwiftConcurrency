//
//  checkContinuation.swift
//  SwiftConcurrency
//
//  Created by Darie-Nistor Nicolae on 20.07.2023.
//

import SwiftUI

class continuationManager {
    
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        
        return try await withCheckedThrowingContinuation { continuation in
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
        
    }
    
    func getHeartImageFromDb(completionHandler : @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageFromDb() async -> UIImage {
         await withCheckedContinuation { continuation in
            getHeartImageFromDb { image in
                continuation.resume(returning: image)
            }
        }
    }
    
    class checkContinuationViewModel: ObservableObject {
        
        @Published var image: UIImage? = nil
        let manager = continuationManager()
        
        func getImage() async {
            guard let url = URL(string: "https://picsum.photos/300") else { return }
            do {
                let data = try await manager.getData2(url: url)
                if let image = UIImage(data: data) {
                    await MainActor.run(body: {
                        self.image = image
                    })
                }
            } catch  {
                print(error)
            }
        }
        
//        func getHeartImage() async {
//            manager.getHeartImageFromDb { [weak self] image in
//                self?.image = image
//            }
//        }
        
        func getHeartImage() async {
            self.image = await manager.getHeartImageFromDb()
             
        }
        
        
    }
    
    struct checkContinuation: View {
        @StateObject var viewModel = checkContinuationViewModel()
        var body: some View {
            ZStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                }
            }
            .task {
                await viewModel.getImage()
            }
        }
    }
    
    struct checkContinuation_Previews: PreviewProvider {
        static var previews: some View {
            checkContinuation()
        }
    }
}
