import Foundation
import SwiftUI

// MARK: - User Profile

struct UserProfile: Identifiable, Hashable {
    let id: UUID
    let name: String
    let role: String
    let organization: String

    static let mock = UserProfile(
        id: UUID(), name: "Max Socha", role: "CEO", organization: "Zen Crypted")
}

// MARK: - Inbox Folder

struct InboxFolder: Identifiable, Hashable {
    let id: String
    let name: String
    let iconName: String
    var incomingCounter: Int
    var badgeColor: Color

    static let mockFolders: [InboxFolder] = [
        InboxFolder(
            id: "for_me", name: "Inbox", iconName: "tray.and.arrow.down", incomingCounter: 12,
            badgeColor: .blue),
        InboxFolder(
            id: "for_execution", name: "Execution", iconName: "doc.badge.gearshape",
            incomingCounter: 5, badgeColor: .orange),
        InboxFolder(
            id: "for_approval", name: "Approval", iconName: "checkmark.seal", incomingCounter: 3,
            badgeColor: .green),
        InboxFolder(
            id: "for_agreement", name: "Agreement", iconName: "hand.raised", incomingCounter: 1,
            badgeColor: .teal),
        InboxFolder(
            id: "for_signing", name: "Signing", iconName: "signature", incomingCounter: 8,
            badgeColor: .purple),
        InboxFolder(
            id: "for_acknowledge", name: "Acknowledge", iconName: "eye", incomingCounter: 0,
            badgeColor: .gray),
        InboxFolder(
            id: "my_resolution", name: "Resolution", iconName: "text.badge.checkmark",
            incomingCounter: 2, badgeColor: .cyan),
        InboxFolder(
            id: "first_view", name: "Initial", iconName: "01.circle", incomingCounter: 4,
            badgeColor: .indigo),
        InboxFolder(
            id: "on_control", name: "Control", iconName: "lock.shield", incomingCounter: 0,
            badgeColor: .gray),
        InboxFolder(
            id: "urgent", name: "Urgent", iconName: "exclamationmark.triangle", incomingCounter: 7,
            badgeColor: .red),
        InboxFolder(
            id: "created_by_me", name: "Originated", iconName: "doc.badge.plus", incomingCounter: 0,
            badgeColor: .gray),
        InboxFolder(
            id: "rejected", name: "Rejected", iconName: "arrow.uturn.backward", incomingCounter: 1,
            badgeColor: .yellow),
        InboxFolder(
            id: "returned", name: "Returned", iconName: "arrow.uturn.forward", incomingCounter: 0,
            badgeColor: .gray),
        InboxFolder(
            id: "from_me", name: "Outbox", iconName: "paperplane", incomingCounter: 0,
            badgeColor: .gray),
        InboxFolder(
            id: "finished", name: "Finished", iconName: "archivebox", incomingCounter: 0,
            badgeColor: .gray),
        InboxFolder(
            id: "favorite", name: "Favorite", iconName: "star", incomingCounter: 2,
            badgeColor: .yellow),
    ]
}

// MARK: - Document

struct Document: Identifiable, Hashable {
    let id: UUID
    var type: String
    var initiator: String
    var addressedTo: String
    var stage: String
    var documentNumber: String
    var date: Date
    var correspondent: String
    var shortSummary: String
    var outgoingNumber: String

    var pdfURL: URL?  // URL to the scanned pdf

    static let mockDocuments: [Document] = [
        Document(
            id: UUID(),
            type: "Contract",
            initiator: "Alice Smith",
            addressedTo: "John Doe",
            stage: "Pending Signature",
            documentNumber: "CTR-2026-001",
            date: Date().addingTimeInterval(-86400),
            correspondent: "Global Tech Inc",
            shortSummary: "Annual service agreement renewal.",
            outgoingNumber: "OUT-001-A"
        ),
        Document(
            id: UUID(),
            type: "Invoice",
            initiator: "Finance Dept",
            addressedTo: "John Doe",
            stage: "For Approval",
            documentNumber: "INV-5542",
            date: Date().addingTimeInterval(-172800),
            correspondent: "Office Supplies Co",
            shortSummary: "Q1 Office Supplies procurement.",
            outgoingNumber: "OUT-002-B"
        ),
        Document(
            id: UUID(),
            type: "Memo",
            initiator: "HR Dept",
            addressedTo: "All Employees",
            stage: "For Acknowledge",
            documentNumber: "MEM-2026-012",
            date: Date().addingTimeInterval(-3600),
            correspondent: "Internal",
            shortSummary: "Updated company policies regarding remote work.",
            outgoingNumber: "N/A"
        ),
        Document(
            id: UUID(),
            type: "Report",
            initiator: "Bob Jones",
            addressedTo: "John Doe",
            stage: "For Review",
            documentNumber: "REP-Q4-2025",
            date: Date().addingTimeInterval(-432000),
            correspondent: "Analytics Team",
            shortSummary: "Q4 2025 Performance Analytics Report.",
            outgoingNumber: "OUT-005-X"
        ),
        Document(
            id: UUID(),
            type: "Letter",
            initiator: "Legal Dept",
            addressedTo: "Jane F.",
            stage: "Urgent",
            documentNumber: "LGL-992",
            date: Date(),
            correspondent: "External Counsel",
            shortSummary: "Response to compliance inquiry.",
            outgoingNumber: "OUT-088-L"
        ),
        Document(
            id: UUID(),
            type: "Directive",
            initiator: "Maxim Sokhatsky",
            addressedTo: "All Departments",
            stage: "Active",
            documentNumber: "DIR-2026-003",
            date: Date().addingTimeInterval(-259200),
            correspondent: "Internal",
            shortSummary: "New security protocols for Q1 2026.",
            outgoingNumber: "N/A"
        ),
        Document(
            id: UUID(),
            type: "Contract",
            initiator: "Procurement",
            addressedTo: "Maxim Sokhatsky",
            stage: "For Signing",
            documentNumber: "CTR-2026-015",
            date: Date().addingTimeInterval(-43200),
            correspondent: "CloudServe Ltd",
            shortSummary: "Cloud infrastructure hosting agreement.",
            outgoingNumber: "OUT-015-C"
        ),
        Document(
            id: UUID(),
            type: "NDA",
            initiator: "Legal Dept",
            addressedTo: "Alice Smith",
            stage: "Pending Signature",
            documentNumber: "NDA-2026-007",
            date: Date().addingTimeInterval(-518400),
            correspondent: "Partner Corp",
            shortSummary: "Non-disclosure agreement for joint project.",
            outgoingNumber: "OUT-007-N"
        ),
        Document(
            id: UUID(),
            type: "Invoice",
            initiator: "Finance Dept",
            addressedTo: "Accounting",
            stage: "For Approval",
            documentNumber: "INV-5600",
            date: Date().addingTimeInterval(-604800),
            correspondent: "DataCenter Pro",
            shortSummary: "Monthly server hosting fees - January.",
            outgoingNumber: "OUT-100-F"
        ),
        Document(
            id: UUID(),
            type: "Report",
            initiator: "Security Team",
            addressedTo: "Maxim Sokhatsky",
            stage: "For Review",
            documentNumber: "SEC-2026-001",
            date: Date().addingTimeInterval(-7200),
            correspondent: "Internal Audit",
            shortSummary: "Annual security audit findings and recommendations.",
            outgoingNumber: "N/A"
        ),
        Document(
            id: UUID(),
            type: "Memo",
            initiator: "IT Department",
            addressedTo: "All Employees",
            stage: "For Acknowledge",
            documentNumber: "MEM-2026-045",
            date: Date().addingTimeInterval(-14400),
            correspondent: "Internal",
            shortSummary: "Scheduled maintenance window notification.",
            outgoingNumber: "N/A"
        ),
        Document(
            id: UUID(),
            type: "Contract",
            initiator: "HR Dept",
            addressedTo: "Eva Martinez",
            stage: "Active",
            documentNumber: "EMP-2026-022",
            date: Date().addingTimeInterval(-1_296_000),
            correspondent: "Internal",
            shortSummary: "Employment agreement for Senior Developer.",
            outgoingNumber: "N/A"
        ),
        Document(
            id: UUID(),
            type: "Letter",
            initiator: "Maxim Sokhatsky",
            addressedTo: "Board of Directors",
            stage: "Sent",
            documentNumber: "LTR-2026-008",
            date: Date().addingTimeInterval(-345600),
            correspondent: "Board Members",
            shortSummary: "Quarterly strategic update letter.",
            outgoingNumber: "OUT-200-Q"
        ),
        Document(
            id: UUID(),
            type: "Procurement",
            initiator: "Operations",
            addressedTo: "Finance Dept",
            stage: "For Approval",
            documentNumber: "PRC-2026-031",
            date: Date().addingTimeInterval(-28800),
            correspondent: "TechSupply Inc",
            shortSummary: "Laptop procurement request for new hires.",
            outgoingNumber: "OUT-031-P"
        ),
        Document(
            id: UUID(),
            type: "Resolution",
            initiator: "Board Secretary",
            addressedTo: "Maxim Sokhatsky",
            stage: "For Signing",
            documentNumber: "RES-2026-002",
            date: Date().addingTimeInterval(-172800),
            correspondent: "Board",
            shortSummary: "Board resolution on budget allocation.",
            outgoingNumber: "N/A"
        ),
    ]
}

// MARK: - Dynamic Templates

enum FormFieldType: Hashable, Sendable {
    case text
    case date
    case datetime
    case number
    case currency
    case toggle
    case dropdown(options: [String])
    case searchDropdown(options: [String])
}

struct FormField: Identifiable, Hashable {
    let id: UUID
    let title: String
    let type: FormFieldType
    let isRequired: Bool

    init(id: UUID = UUID(), title: String, type: FormFieldType, isRequired: Bool = false) {
        self.id = id
        self.title = title
        self.type = type
        self.isRequired = isRequired
    }
}

struct DocumentTemplate: Identifiable, Hashable {
    let id: UUID = UUID()
    let templateName: String
    let iconName: String
    let requiredFields: [FormField]
    let description: String
}

struct TemplateCategory: Identifiable, Hashable {
    let id: UUID = UUID()
    let categoryName: String
    let iconName: String
    let templates: [DocumentTemplate]

    static let mockCategories: [TemplateCategory] = [
        // MARK: - Інструкція з діловодства №370
        TemplateCategory(
            categoryName: "Інструкція з діловодства №40",
            iconName: "doc.text.fill",
            templates: [
                DocumentTemplate(
                    templateName: "Наказ командира",
                    iconName: "scroll",
                    requiredFields: [
                        FormField(title: "Номер наказу", type: .text, isRequired: true),
                        FormField(title: "Дата видання", type: .date, isRequired: true),
                        FormField(title: "Вид наказу", type: .dropdown(options: ["По особовому складу", "По стройовій частині"]), isRequired: true),
                        FormField(title: "Підстава", type: .text, isRequired: true),
                        FormField(title: "Виконавець (посада, ПІБ, телефон)", type: .text, isRequired: true)
                    ],
                    description: "Основний розпорядчий документ командира (керівника) військової частини (установи), виданий на правах єдиноначальності."
                ),
                DocumentTemplate(
                    templateName: "Директива",
                    iconName: "lock.doc.fill",
                    requiredFields: [
                        FormField(title: "Номер директиви", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Адресат (орган/підрозділ)", type: .text, isRequired: true),
                        FormField(title: "Заголовок", type: .text, isRequired: true),
                        FormField(title: "Підстава", type: .text, isRequired: true)
                    ],
                    description: "Вид розпорядчого документа, який видається органом військового управління з метою забезпечення виконання прийнятого його керівником рішення щодо підготовки та ведення бойових дій, питань бойової і мобілізаційної готовності, всебічного забезпечення військ (сил), організації бойової, оперативної, мобілізаційної підготовки, навчання, виховання, штатної організації та інших питань життєдіяльності Збройних Сил України."
                ),
                DocumentTemplate(
                    templateName: "Бойове розпорядження",
                    iconName: "person.text.rectangle.fill",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Завдання", type: .text, isRequired: true),
                        FormField(title: "Виконавець (підрозділ)", type: .text, isRequired: true),
                        FormField(title: "Термін виконання", type: .date, isRequired: true)
                    ],
                    description: "Розпорядчий документ, яким доводяться бойові завдання підпорядкованим військовим частинам (установам) і підрозділам. Бойове розпорядження доводиться після вироблення замислу (плану) та визначення завдань військовим частинам і підрозділам."
                ),
                DocumentTemplate(
                    templateName: "Бойовий наказ",
                    iconName: "flag.fill",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Завдання", type: .text, isRequired: true),
                        FormField(title: "Виконавець", type: .text, isRequired: true),
                        FormField(title: "Підстава", type: .text, isRequired: true)
                    ],
                    description: "Акт військового управління за встановленою формою, яким відповідно до плану операції (бойових дій) доводяться бойові завдання підпорядкованим військам (силам). Як правило, використовується для постановки бойових завдань в оперативно-тактичній та тактичній ланці."
                ),
                DocumentTemplate(
                    templateName: "Доповідна записка",
                    iconName: "briefcase.fill",
                    requiredFields: [
                        FormField(title: "Адресат", type: .text, isRequired: true),
                        FormField(title: "Тема", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Зміст", type: .text, isRequired: true),
                        FormField(title: "Пропозиції", type: .text, isRequired: false)
                    ],
                    description: "Службовий документ, адресований командиру (керівнику) військової частини (установи), з інформацією про ситуацію, що склалася, наявні факти, певні події, явища, виконану роботу з висновками та пропозиціями автора, виконання окремих завдань, службових доручень тощо."
                ),
                DocumentTemplate(
                    templateName: "Доповідь",
                    iconName: "briefcase.fill",
                    requiredFields: [
                        FormField(title: "Адресат", type: .text, isRequired: true),
                        FormField(title: "Тема", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Зміст", type: .text, isRequired: true)
                    ],
                    description: "Документ, що містить виклад певних питань з висновками та пропозиціями."
                ),
                DocumentTemplate(
                    templateName: "Звіт",
                    iconName: "chart.bar.fill",
                    requiredFields: [
                        FormField(title: "Тип звіту", type: .dropdown(options: ["Фінансовий", "Операційний", "Аналітичний", "Бойовий"]), isRequired: true),
                        FormField(title: "Період", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Виконавець", type: .text, isRequired: true)
                    ],
                    description: "Документ, що містить відомості про виконання плану, завдання, підготовку заходів, доручень і проведення заходів та подається вищій посадовій особі чи до військової частини (установи)."
                ),
                DocumentTemplate(
                    templateName: "Акт",
                    iconName: "doc.on.doc.fill",
                    requiredFields: [
                        FormField(title: "Тип акту", type: .dropdown(options: ["Приймання-передачі", "Інвентаризації", "Обстеження", "Службовий"]), isRequired: true),
                        FormField(title: "Дата складання", type: .date, isRequired: true),
                        FormField(title: "Комісія (склад)", type: .text, isRequired: true),
                        FormField(title: "Підстава", type: .text, isRequired: true)
                    ],
                    description: "Офіційний документ, складений кількома особами, що підтверджує встановлені факти чи події та підлягає затвердженню посадовою особою в межах повноважень."
                ),
                DocumentTemplate(
                    templateName: "Довідка",
                    iconName: "info.circle.fill",
                    requiredFields: [
                        FormField(title: "Тип довідки", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Адресат", type: .text, isRequired: true),
                        FormField(title: "Зміст", type: .text, isRequired: true)
                    ],
                    description: "Документ інформаційного характеру, що підтверджує факти з життя чи діяльності військовослужбовців (працівників) і різні обставини діяльності військових частин (установ)."
                ),
                DocumentTemplate(
                    templateName: "Доручення",
                    iconName: "arrowshape.turn.up.right.fill",
                    requiredFields: [
                        FormField(title: "Номер доручення", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Тема (короткий зміст)", type: .text, isRequired: true),
                        FormField(title: "Виконавець (посада, ПІБ)", type: .text, isRequired: true),
                        FormField(title: "Термін виконання", type: .date, isRequired: true),
                        FormField(title: "Контроль", type: .toggle, isRequired: false)
                    ],
                    description: "Доручення керівника."
                ),
                DocumentTemplate(
                    templateName: "Розпорядження",
                    iconName: "list.bullet",
                    requiredFields: [
                        FormField(title: "Номер розпорядження", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Заголовок", type: .text, isRequired: true),
                        FormField(title: "Виконавець", type: .text, isRequired: true),
                        FormField(title: "Термін виконання", type: .date, isRequired: true),
                        FormField(title: "Підстава", type: .text, isRequired: false)
                   ],
                    description: "Розпорядчий документ, виданий начальником штабу військової частини, першим заступником керівника установи, а в разі його відсутності – одним із заступників керівника, з метою вирішення окремих оперативних питань, спрямованих на всебічне забезпечення життєдіяльності та функціонування військової частини (установи), доведення вказівок підпорядкованим штабам, військовим частинам і підрозділам щодо майбутніх дій військ (сил), управління військами, взаємодії, введення в оману, по видах забезпечення і має обмежений строк дії."
                ),
                DocumentTemplate(
                    templateName: "Протокол",
                    iconName: "doc.on.doc",
                    requiredFields: [
                        FormField(title: "Номер протоколу", type: .text, isRequired: true),
                        FormField(title: "Дата засідання", type: .date, isRequired: true),
                        FormField(title: "Тип засідання", type: .text, isRequired: true),
                        FormField(title: "Голова", type: .text, isRequired: true),
                        FormField(title: "Порядок денний", type: .text, isRequired: true)
                    ],
                    description: "Документ, в якому записується хід обговорення питань і прийняття рішень колегіальних органів на зборах, нарадах, конференціях, засіданнях тощо."
                ),
                DocumentTemplate(
                    templateName: "План",
                    iconName: "calendar",
                    requiredFields: [
                        FormField(title: "Номер плану", type: .text, isRequired: true),
                        FormField(title: "Назва плану", type: .text, isRequired: true),
                        FormField(title: "Період", type: .text, isRequired: true),
                        FormField(title: "Дата затвердження", type: .date, isRequired: true),
                        FormField(title: "Відповідальний", type: .text, isRequired: true)
                    ],
                    description: "Перелік запланованих до виконання робіт або заходів, їх послідовність із визначенням строків виконання і виконавців."
                ),
                DocumentTemplate(
                    templateName: "Положення",
                    iconName: "book.pages",
                    requiredFields: [
                        FormField(title: "Назва положення", type: .text, isRequired: true),
                        FormField(title: "Дата затвердження", type: .date, isRequired: true),
                        FormField(title: "Підстава", type: .text, isRequired: true)
                    ],
                    description: "Нормативно-правовий акт, в якому визначаються структура, функції, обов’язки та права військової частини (установи)."
                ),
                DocumentTemplate(
                    templateName: "Інструкція",
                    iconName: "book",
                    requiredFields: [
                        FormField(title: "Назва інструкції", type: .text, isRequired: true),
                        FormField(title: "Дата затвердження", type: .date, isRequired: true),
                        FormField(title: "Підстава", type: .text, isRequired: true)
                    ],
                    description: "Організаційний документ, в якому визначаються правила, які регулюють організаційні, науково-технічні, господарські, фінансові та інші спеціальні сторони діяльності військових частин (установ) та посадових осіб."
                ),
                DocumentTemplate(
                    templateName: "Історичний формуляр",
                    iconName: "bubble.left.and.bubble.right",
                    requiredFields: [
                        FormField(title: "Номер формуляра", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Тема (період)", type: .text, isRequired: true)
                    ],
                    description: "Документ, в якому відображається організаційний розвиток і бойова діяльність військової частини, важливі події, стан бойової підготовки, військової дисципліни та інші відомості."
                ),
                DocumentTemplate(
                    templateName: "Формуляр військової частини",
                    iconName: "bubble.left.and.bubble.right",
                    requiredFields: [
                        FormField(title: "Номер формуляра", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Найменування частини", type: .text, isRequired: true)
                    ],
                    description: "Документ, що містить інформацію про військову частину (установу), яка необхідна для організації її повсякденної діяльності, підтримання бойової та мобілізаційної готовності, підготовки до виконання завдань за призначенням відповідно до ситуації застосування Збройних Сил України."
                ),
                DocumentTemplate(
                    templateName: "Окреме доручення",
                    iconName: "bubble.left.and.bubble.right",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Тема", type: .text, isRequired: true),
                        FormField(title: "Виконавець", type: .text, isRequired: true),
                        FormField(title: "Термін", type: .date, isRequired: true)
                    ],
                    description: "форма реалізації управлінських повноважень командира (керівника), що передбачає визначення конкретного завдання, мети, строку та відповідальної за виконання посадової особи. Доручення надається до конкретно визначеного документа."
                ),
                DocumentTemplate(
                    templateName: "Постанова",
                    iconName: "bubble.left.and.bubble.right",
                    requiredFields: [
                        FormField(title: "Номер постанови", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Тема", type: .text, isRequired: true),
                        FormField(title: "Голова", type: .text, isRequired: true)
                    ],
                    description: "Правовий нормативний акт, який приймається вищими і деякими центральними органами колегіального управління."
                ),
                DocumentTemplate(
                    templateName: "Пояснювальна записка",
                    iconName: "briefcase.fill",
                    requiredFields: [
                        FormField(title: "Адресат", type: .text, isRequired: true),
                        FormField(title: "Тема", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Зміст", type: .text, isRequired: true)
                    ],
                    description: "Письмове пояснення дійсної ситуації, фактів, дій або вчинків військовослужбовця (працівника) на вимогу його командира (керівника), а в деяких випадках – з ініціативи підлеглого."
                ),
                DocumentTemplate(
                    templateName: "Припис",
                    iconName: "arrow.right.doc",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Адресат", type: .text, isRequired: true),
                        FormField(title: "Зміст", type: .text, isRequired: true)
                    ],
                    description: "Документ із вказівкою або порадою діяти певним чином."
                ),
                DocumentTemplate(
                    templateName: "Посвідчення про відрядження",
                    iconName: "arrow.right.doc",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "ПІБ відрядженого", type: .text, isRequired: true),
                        FormField(title: "Мета відрядження", type: .text, isRequired: true),
                        FormField(title: "Термін", type: .date, isRequired: true)
                    ],
                    description: "Документ встановленого зразка, що дається особі, яка відряджається для виконання службового доручення."
                ),
                DocumentTemplate(
                    templateName: "Відпускний квиток",
                    iconName: "arrow.right.doc",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "ПІБ", type: .text, isRequired: true),
                        FormField(title: "Вид відпустки", type: .text, isRequired: true),
                        FormField(title: "Період", type: .text, isRequired: true)
                    ],
                    description: "Документ встановленого зразка, що надає право військовослужбовцю під час відпустки вибувати за межі гарнізону."
                ),
                DocumentTemplate(
                    templateName: "Графік відпусток",
                    iconName: "envelope",
                    requiredFields: [
                        FormField(title: "Період графіка", type: .text, isRequired: true),
                        FormField(title: "Дата затвердження", type: .date, isRequired: true),
                        FormField(title: "Категорія", type: .dropdown(options: ["Звичайна", "Термінова", "Навчальна"]), isRequired: true)                    ],
                    description: "Документ, в якому зазначаються дати відпусток."
                ),
                DocumentTemplate(
                    templateName: "Обхідний лист",
                    iconName: "envelope",
                    requiredFields: [
                        FormField(title: "ПІБ", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Категорія", type: .dropdown(options: ["Звичайний", "Терміновий"]), isRequired: true)
                    ],
                    description: "Документ, в якому зазначено структурні підрозділи, керівники яких мають засвідчити відсутність заборгованості військовослужбовця (працівника) перед ними."
                ),
                DocumentTemplate(
                    templateName: "Телеграма",
                    iconName: "envelope",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .datetime, isRequired: true),
                        FormField(title: "Адресат", type: .text, isRequired: true),
                        FormField(title: "Категорія", type: .dropdown(options: ["Звичайна", "Термінова", "Урядова"]), isRequired: true)
                    ],
                    description: "Телеграма."
                ),
                DocumentTemplate(
                    templateName: "Телефонограма",
                    iconName: "envelope",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .datetime, isRequired: true),
                        FormField(title: "Адресат", type: .text, isRequired: true),
                        FormField(title: "Категорія", type: .dropdown(options: ["Звичайна", "Термінова"]), isRequired: true)
                    ],
                    description: "Невідкладне, термінове повідомлення, яке передається телефоном, фіксується у спеціальній книзі (журналі) і містить розпорядження або інформацію."
                ),
                DocumentTemplate(
                    templateName: "Факсограма",
                    iconName: "envelope",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .datetime, isRequired: true),
                        FormField(title: "Адресат", type: .text, isRequired: true),
                        FormField(title: "Категорія", type: .dropdown(options: ["Звичайна", "Термінова"]), isRequired: true)
                    ],
                    description: "Паперова копія документа, що передається засобами факсимільного зв’язку (телефаксом)."
                ),
                DocumentTemplate(
                    templateName: "Службовий акт",
                    iconName: "doc.text.magnifyingglass",
                    requiredFields: [
                        FormField(title: "Тип акту", type: .text, isRequired: true),
                        FormField(title: "Дата складання", type: .date, isRequired: true),
                        FormField(title: "Підстава", type: .text, isRequired: true)
                    ],
                    description: "Службовий акт."
                ),
                DocumentTemplate(
                    templateName: "Службовий лист",
                    iconName: "doc.text.magnifyingglass",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Адресат", type: .text, isRequired: true),
                        FormField(title: "Заголовок", type: .text, isRequired: true)
                    ],
                    description: "Документ, який є одним із основних засобів спілкування, обміну інформацією та оперативного управління найрізноманітнішими процесами діяльності військ (сил)."
                ),
                DocumentTemplate(
                    templateName: "Програма",
                    iconName: "list.star",
                    requiredFields: [
                        FormField(title: "Назва програми", type: .text, isRequired: true),
                        FormField(title: "Період", type: .text, isRequired: true),
                        FormField(title: "Дата затвердження", type: .date, isRequired: true)
                    ],
                    description: "Документ, в якому передбачається продуманий план певної роботи."
                ),
                DocumentTemplate(
                    templateName: "Припис",
                    iconName: "arrow.right.doc",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Зміст", type: .text, isRequired: true)
                    ],
                    description: "Припис."
                ),
                DocumentTemplate(
                    templateName: "Алгоритм",
                    iconName: "arrow.right.doc",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Назва", type: .text, isRequired: true)
                    ],
                    description: "Документ, в якому описано систему правил виконання певного класу завдань."
                ),
                DocumentTemplate(
                    templateName: "Правила",
                    iconName: "arrow.right.doc",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Назва", type: .text, isRequired: true)
                    ],
                    description: "Нормативний документ, який конкретизує нормативні приписи загального характеру з метою регулювання поведінки службових осіб у певних галузях і вирішує процедурні питання."
                ),
                DocumentTemplate(
                    templateName: "Рішення",
                    iconName: "arrow.right.doc",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Тема", type: .text, isRequired: true),
                        FormField(title: "Голова", type: .text, isRequired: true)
                    ],
                    description: "Вид документа розпорядчого характеру, що ухвалюється в колегіальному порядку для вирішення найбільш важливих питань. Текст рішення складається з двох частин: констатуючої та регулятивної. У регулятивній частині визначаються конкретні завдання, виконавці та строки виконання."
                ),
                DocumentTemplate(
                    templateName: "Методичні рекомендації",
                    iconName: "arrow.right.doc",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Назва", type: .text, isRequired: true)
                    ],
                    description: "Документ із визначенням послідовних, систематичних порад, вказівок, пропозицій, виконання яких виключає негативний вплив на виконання певних дій."
                ),
                DocumentTemplate(
                    templateName: "Рапорт",
                    iconName: "chart.bar.fill",
                    requiredFields: [
                        FormField(title: "Адресат", type: .text, isRequired: true),
                        FormField(title: "Тема", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Зміст", type: .text, isRequired: true),
                        FormField(title: "Тип рапорту", type: .dropdown(options: ["Про відпустку", "Про звільнення", "Про преміювання", "Про стан справ"]), isRequired: true)
                    ],
                    description: "Письмове звернення військовослужбовця (працівника) до вищої посадової особи з проханням (надання відпустки, матеріальної допомоги, поліпшення житлових умов, переведення, звільнення тощо) чи пояснення особистого характеру."
                ),
            ]
        ),

        // MARK: - Постанова КМУ №55
        TemplateCategory(
            categoryName: "Постанова КМУ №55",
            iconName: "building.columns.fill",
            templates: [
                DocumentTemplate(
                    templateName: "Звернення громадян",
                    iconName: "megaphone.fill",
                    requiredFields: [
                        FormField(title: "ПІБ громадянина", type: .text, isRequired: true),
                        FormField(title: "Дата звернення", type: .date, isRequired: true),
                        FormField(title: "Тема", type: .text, isRequired: true)
                    ],
                    description: "Звернення громадян."
                ),
                DocumentTemplate(
                    templateName: "Резолюція",
                    iconName: "checkmark.circle.fill",
                    requiredFields: [
                        FormField(title: "Номер документа", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Текст резолюції", type: .text, isRequired: true),
                        FormField(title: "Виконавець", type: .text, isRequired: true)
                    ],
                    description: "Резолюція керівника."
                ),
                DocumentTemplate(
                    templateName: "Автозадача",
                    iconName: "clock.arrow.circlepath",
                    requiredFields: [
                        FormField(title: "Назва задачі", type: .text, isRequired: true),
                        FormField(title: "Термін", type: .datetime, isRequired: true)
                    ],
                    description: "Автоматично створена задача."
                ),
                DocumentTemplate(
                    templateName: "Задача контролю",
                    iconName: "target",
                    requiredFields: [
                        FormField(title: "Назва", type: .text, isRequired: true),
                        FormField(title: "Термін контролю", type: .date, isRequired: true),
                        FormField(title: "Відповідальний", type: .text, isRequired: true)
                    ],
                    description: "Задача на контролі."
                ),
                DocumentTemplate(
                    templateName: "Задача до відома",
                    iconName: "eye.fill",
                    requiredFields: [
                        FormField(title: "Назва", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true)
                    ],
                    description: "Інформація до відома."
                ),
                DocumentTemplate(
                    templateName: "Вхідний документ",
                    iconName: "tray.and.arrow.down.fill",
                    requiredFields: [
                        FormField(title: "Номер вхідний", type: .text, isRequired: true),
                        FormField(title: "Дата отримання", type: .date, isRequired: true),
                        FormField(title: "Відправник", type: .text, isRequired: true)
                    ],
                    description: "Зареєстрований вхідний документ."
                ),
                DocumentTemplate(
                    templateName: "Вихідний документ",
                    iconName: "paperplane.fill",
                    requiredFields: [
                        FormField(title: "Номер вихідний", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Отримувач", type: .text, isRequired: true)
                    ],
                    description: "Вихідний документ."
                ),
                DocumentTemplate(
                    templateName: "Документ СЕВ",
                    iconName: "network",
                    requiredFields: [
                        FormField(title: "Номер", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true)
                    ],
                    description: "Документ системи електронної взаємодії."
                ),
                DocumentTemplate(
                    templateName: "Документ Email",
                    iconName: "envelope.fill",
                    requiredFields: [
                        FormField(title: "Тема", type: .text, isRequired: true),
                        FormField(title: "Дата", type: .datetime, isRequired: true),
                        FormField(title: "Відправник", type: .text, isRequired: true)
                    ],
                    description: "Електронний лист."
                ),
                DocumentTemplate(
                    templateName: "Внутрішній документ",
                    iconName: "exclamationmark.shield.fill",
                    requiredFields: [
                        FormField(title: "Тип", type: .searchDropdown(options: ["Наказ", "Звіт", "Довідка"]), isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true)
                    ],
                    description: "Внутрішній документ організації."
                ),
                DocumentTemplate(
                    templateName: "Організаційно-розпорядчий документ",
                    iconName: "folder.badge.plus",
                    requiredFields: [
                        FormField(title: "Вид документа", type: .dropdown(options: ["Наказ", "Розпорядження", "Протокол"]), isRequired: true),
                        FormField(title: "Дата", type: .date, isRequired: true),
                        FormField(title: "Назва", type: .text, isRequired: true)
                    ],
                    description: "Організаційно-розпорядчий документ."
                )
            ]
        )
    ]
}
