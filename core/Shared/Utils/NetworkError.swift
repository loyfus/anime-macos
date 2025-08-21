import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError(Error)
    case networkError(Error)
    case httpError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Resposta inválida do servidor"
        case .noData:
            return "Nenhum dado recebido"
        case .decodingError(let error):
            return "Erro ao processar dados: \(error.localizedDescription)"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        case .httpError(let code):
            return "Erro HTTP: \(code)"
        }
    }
}