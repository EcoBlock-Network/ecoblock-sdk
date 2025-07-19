import '../src/rust/api/simple.dart';

class RustBridgeService {
  final RustApiService _api = RustApiService();

  Future<List<String>> listPeers(String peerId) async {
    return await _api.frbListPeers(peerId: peerId);
  }

  Future<void> addPeerConnection(String from, String to, double weight) async {
    await _api.frbAddPeerConnection(from: from, to: to, weight: weight);
  }

}
