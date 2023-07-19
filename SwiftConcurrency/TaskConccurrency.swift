//
//  Task.swift
//  SwiftConcurrency
//
//  Created by Darie-Nistor Nicolae on 18.07.2023.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func getImage() async {
        
//        Task.checkCancellation() -> if you have a long task, check for canncellation, otherwise, it'll keep running
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            
            await MainActor.run(body: {
                self.image2 = UIImage(data: data)
                print("DD")
            })
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            self.image = UIImage(data: data)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct TaskHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("Click Me!") {
                    TaskConccurrency()
                }
            }
        }
    }
}

struct TaskConccurrency: View {
    @StateObject var viewModel = TaskViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
           await viewModel.getImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task {
//                await viewModel.getImage()
//            }
            
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.getImage2()
//            }
//
//
//            Task (priority: .low) {
//                print("LOW: \(Thread .current): \(Task.currentPriority)")
//            }
//
//            Task(priority: .medium) {
//                print("Medium: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .high) {
//                try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield()
//                print("High: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .background) {
//                print("Background: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .utility) {
//                print("Utility: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .userInitiated) {
//                print("UserInitiated: \(Thread.current): \(Task.currentPriority)")
//            }
//
//
//            Task(priority: .low) {
//                print("LOW: \(Thread .current): \(Task.currentPriority)")
//
//                Task.detached {
//                    print("LOW: \(Thread .current): \(Task.currentPriority)")
//                }
//            }
            
        }
    }



struct Task_Previews: PreviewProvider {
    @StateObject var viewModel = TaskViewModel()
    static var previews: some View {
        TaskConccurrency()
    }
}
