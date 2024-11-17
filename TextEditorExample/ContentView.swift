//
//  Created by Artem Novichkov on 17.11.2024.
//

import SwiftUI
import SwiftUIIntrospect

struct ContentView: View {

    private enum Constants {

        static let characterLimit = 200
    }

    @State private var text = "It was a great day!"
    @State private var textSelection: TextSelection?
    @FocusState private var isFocused: Bool
    @State private var findNavigatorIsPresented = false
    @State var isEditable = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProgressView(value: Float(text.count),
                             total: Float(Constants.characterLimit))
                TextEditor(text: $text, selection: $textSelection)
                    .onChange(of: textSelection) {
                        guard let textSelection else {
                            return
                        }
                        switch textSelection.indices {
                        case .selection(let range):
                            print(text[range])
                        case .multiSelection(let rangeSet):
                            rangeSet.ranges.forEach { range in
                                print(text[range])
                            }
                        @unknown default:
                            break
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.gray.tertiary)
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .lineSpacing(4)
                    .keyboardType(.default)
                    .submitLabel(.return)
                    .textInputAutocapitalization(.sentences)
                    .autocorrectionDisabled(true)
                    .focused($isFocused)
                    .characterLimit($text, to: Constants.characterLimit)
                    .replaceDisabled(true)
                    .findNavigator(isPresented: $findNavigatorIsPresented)
                    .toolbar {
                        if isEditable {
                            ToolbarItemGroup(placement: .keyboard) {
                                Toggle(isOn: $findNavigatorIsPresented) {
                                    Label("Find and replace", systemImage: "magnifyingglass")
                                }
                            }
                        }
                    }
                    .introspect(.textEditor, on: .iOS(.v18)) { textView in
                        textView.isEditable = isEditable
                    }
                    .writingToolsBehavior(.complete)
            }
            .navigationTitle("Text Editor")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditable ? "Done" : "Edit") {
                        isEditable.toggle()
                        if isEditable {
                            isFocused = true
                        } else {
                            findNavigatorIsPresented = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
