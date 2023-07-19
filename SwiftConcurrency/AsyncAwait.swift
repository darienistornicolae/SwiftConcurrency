//
//  AsyncAwait.swift
//  SwiftConcurrency
//
//  Created by Darie-Nistor Nicolae on 18.07.2023.
//

import SwiftUI

class AsycnAwaitClass: ObservableObject {
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter (deadline: .now () + 2) {
            self.dataArray.append ("Title1: \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter (deadline: .now() + 2) {
            let title = "Title2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
            }
        }
    }
    
    
    func addAuthor() async {
        let author1 = "Author \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author2 : \(Thread.current)"
        self.dataArray.append(author2)
        
        await MainActor.run(body: {
            self.dataArray.append (author2)
            let author3 = "Author3: \(Thread.current)"
            self.dataArray.append(author3)
        })
        await addSomething()
    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let something1 = "Something1: \(Thread.current)"
        await MainActor.run(body: {
        self.dataArray.append (something1)
        let something2 = "Something2 : \(Thread.current)"
    })
    }
}

struct AsyncAwait: View {
    
    @StateObject private var viewModel = AsycnAwaitClass()
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \ .self) { data in
                Text(data)
            }
        }
        .onAppear {
            Task {
                await viewModel.addAuthor()
                let finalText = "FINAL TEXT : \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
        }
    }
}

struct AsyncAwait_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwait()
    }
}
