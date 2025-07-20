import 'package:ecoblock_mobile/src/rust/frb_generated.dart';
import '../src/rust/api/simple.dart';
import 'package:path_provider/path_provider.dart';

class RustBridgeService {
  Future<String> _getWritablePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
  Future<void> init() async {
    await RustLib.init();
  }

  Future<String> createBlock(List<int> data, List<String> parents) async {
    return await frbCreateBlock(data: data, parents: parents);
  }

  Future<BigInt> getTangleSize() async {
    return await frbGetTangleSize();
  }

  Future<void> addPeerConnection(String from, String to, double weight) async {
    await frbAddPeerConnection(from: from, to: to, weight: weight);
  }

  Future<List<String>> listPeers(String peerId) async {
    return await frbListPeers(peerId: peerId);
  }

  Future<String> createBlockWithParents(List<int> data, List<String> parents) async {
    return await frbCreateBlockWithParents(data: data, parents: parents);
  }

  Future<String> propagateBlock(List<int> data, List<String> parents) async {
    return await frbPropagateBlock(data: data, parents: parents);
  }

  Future<String> generateKeypair() async {
    final path = await _getWritablePath();
    return await frbGenerateKeypair(path: path);
  }

  Future<String> getPublicKey() async {
    final path = await _getWritablePath();
    return await frbGetPublicKey(path: path);
  }

  Future<String> getNodeId() async {
    final path = await _getWritablePath();
    return await frbGetNodeId(path: path);
  }

  Future<bool> nodeIsInitialized() async {
    final path = await _getWritablePath();
    return await frbNodeIsInitialized(path: path);
  }

  Future<String> createLocalNode() async {
    final path = await _getWritablePath();
    return await frbCreateLocalNode(path: path);
  }

  Future<void> resetNode() async {
    final path = await _getWritablePath();
    await frbResetNode(path: path);
  }

  Future<void> initializeTangle() async {
    await frbInitializeTangle();
  }

  Future<void> initializeMesh() async {
    final path = await _getWritablePath();
    await frbInitializeMesh(path: path);
  }
}