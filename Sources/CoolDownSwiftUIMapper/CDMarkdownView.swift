//
//  File.swift
//  
//
//  Created by Philip Niedertscheider on 24.05.21.
//

import SwiftUI

@available(iOS 13.0, *)
struct CDMarkdownView: View {

    var body: some View {
        Text("TODO")
    }
}
//import SwiftUI
//import CoolDownParser
//import CoolDownSwiftUIMapper
//
//struct MarkdownViewer: View {
//
//    let nodes: [ASTNode]
//
//    init(_ text: String) {
//        self.nodes = CDParser(text).nodes
//    }
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 10) {
//                content
//            }
//            .padding(.vertical, 20)
//            .padding(.horizontal, 25)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//
//    var content: some View {
//        do {
//            let mapper = CDSwiftUIMapper(from: transform(nodes: nodes))
//            mapper.addResolver(for: HeaderNode.self) { mapper, node in
//                ForEach(node.nodes, id: \.self) { node in
//                    mapper.resolve(node: node)
//                }
//                .font({
//                    switch node.depth {
//                    case 1:
//                        return Font.system(size: 22, weight: .semibold)
//                    default:
//                        return Font.system(size: 18)
//                    }
//                }())
//            }
//            mapper.addResolver(for: TextNode.self) { mapper, node in
//                Text(node.content) // node has type TextNode
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//            mapper.addResolver(for: BoldNode.self) { mapper, node  in
//                Text(node.content)
//                    .bold()
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//            mapper.addResolver(for: CursiveNode.self) { mapper, node  in
//                Text(node.content)
//                    .italic()
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//            mapper.addResolver(for: CursiveBoldNode.self) { mapper, node  in
//                Text(node.content)
//                    .italic()
//                    .bold()
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//            mapper.addResolver(for: ListNode.self) { mapper, node  in
//                VStack(alignment: .leading) {
//                    ForEach(node.nodes, id: \.self) { node in
//                        mapper.resolve(node: node)
//                    }
//                }
//            }
//            mapper.addResolver(for: BulletNode.self, resolver: { mapper, node in
//                HStack(alignment: .top) {
//                    Text("·")
//                    VStack(alignment: .leading) {
//                        ForEach(node.nodes, id: \.self) { node in
//                            mapper.resolve(node: node)
//                        }
//                    }
//                }
//            })
//            mapper.addResolver(for: ParagraphNode.self, resolver: resolveParagraphNode)
//            mapper.addResolver(for: TextNode.self) { mapper, node in
//                HStack(spacing: 0) {
//                    Text(node.content)
//                    Spacer()
//                }
//            }
//            mapper.addResolver(for: CodeNode.self) { mapper, node in
//                HStack(spacing: 0) {
//                    Text(node.content)
//                        .fixedSize(horizontal: false, vertical: true)
//                    Spacer()
//                }
//                .padding(10)
//                .background(Color(white: 0.85))
//                .cornerRadius(10)
//            }
//            mapper.addResolver(for: TextNodesBox.self) { mapper, node in
//                    node.nodes.compactMap { node -> Text? in
//                        if let boldNode = node as? BoldNode {
//                            return Text(boldNode.content).bold()
//                        } else if let cursiveNode = node as? CursiveNode {
//                            return Text(cursiveNode.content).italic()
//                        } else if let boldCursiveNode = node as? CursiveBoldNode {
//                            return Text(boldCursiveNode.content).bold().italic()
//                        } else if let textNode = node as? TextNode {
//                            return Text(textNode.content)
//                        }
//                        return nil
//                    }.reduce(Text(""), +)
//            }
//            return try mapper.resolve()
//        } catch {
//            return AnyView(Text(error.localizedDescription))
//        }
//    }
//
//    @ViewBuilder
//    func resolveParagraphNode(mapper: CDSwiftUIMapper, node: ParagraphNode) -> some View {
//        ForEach(node.nodes, id: \.self) { node in
//            HStack(spacing: 0) {
//                mapper.resolve(node: node)
//                Spacer()
//            }
//        }
//    }
//
//    func transform(nodes: [ASTNode]) -> [ASTNode] {
//        var transformedNodes: [ASTNode] = []
//        for node in nodes {
//            if let textNode = node as? TextNode {
//                if let prev = transformedNodes.last as? TextNodesBox {
//                    transformedNodes[transformedNodes.count - 1] = TextNodesBox(nodes: prev.nodes + [textNode])
//                } else {
//                    transformedNodes.append(TextNodesBox(nodes: [textNode]))
//                }
//            } else if let container = node as? ContainerNode {
//                container.nodes = transform(nodes: container.nodes)
//                transformedNodes.append(container)
//            } else {
//                transformedNodes.append(node)
//            }
//        }
//        return transformedNodes
//    }
//}
//
//
//class TextNodesBox: ContainerNode {
//
//}
