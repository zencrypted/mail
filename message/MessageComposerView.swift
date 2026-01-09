// MessageComposerView.swift

import SwiftUI

struct MessageComposerView: View {
    @Binding var messageText: String
    @Binding var isShowingAttachmentPicker: Bool
    let matchingGeometryID: String
    let attachmentPickerAnimation: Namespace.ID
    @Binding var attachments: [Attachment]
    @Bindable var photoSelectorVM: PhotoSelectorViewModel

    var body: some View {
        HStack(alignment: .bottom) {
            Button {
                withAnimation {
                    isShowingAttachmentPicker.toggle()
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
            }
            .matchedGeometryEffect(id: matchingGeometryID, in: attachmentPickerAnimation, isSource: true)

            VStack(spacing: 0) {
                if !photoSelectorVM.images.isEmpty {
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.fixed(100))]) {
                            ForEach(0..<photoSelectorVM.images.count, id: \.self) { index in
                                if !photoSelectorVM.images.isEmpty {
                                    Image(platformImage: photoSelectorVM.images[index])
                                        .resizable()
                                        .scaledToFit()
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                photoSelectorVM.images.remove(at: index)
                                            } label: {
                                                Image(systemName: "xmark")
                                                    .foregroundStyle(.white)
                                                    .padding(4)
                                                    .background(.secondary)
                                                    .clipShape(Circle())
                                            }.buttonStyle(.plain)
                                        }
                                }
                            }
                        }
                    }
                    .frame(height: 100)
                    .padding(.vertical, 4)
                    .contentMargins(4, for: .scrollContent)
                    .overlay {
                        Rectangle()
                            .fill(.clear)
                            .roundedCornerWithBorder(borderColor: .secondary, radius: 8, corners: [.topLeft, .topRight])
                    }
                }
                TextField("Message Input", text: $messageText, prompt: Text("Message"), axis: .vertical)
                    .padding(4)
                    .overlay {
                        Rectangle()
                            .fill(.clear)
                            .roundedCornerWithBorder(
                                borderColor: .secondary,
                                radius: 8,
                                corners: photoSelectorVM.images.isEmpty ? [.allCorners] : [.bottomLeft, .bottomRight]
                            )
                    }
            }
            if messageText.isEmpty {
                EmptyView()
            } else {
                Button {
                    // send message
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .imageScale(.large)
                }
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var attachmentPickerAnimation
    MessageComposerView(
        messageText: .constant(""),
        isShowingAttachmentPicker: .constant(false),
        matchingGeometryID: "attachments",
        attachmentPickerAnimation: attachmentPickerAnimation,
        attachments: .constant([]),
        photoSelectorVM: PhotoSelectorViewModel()
    )
}
