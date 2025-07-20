import 'package:ecoblock_mobile/src/rust/frb_generated.dart';

import '../src/rust/api/simple.dart';

class RustBridgeService {
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
    return await frbGenerateKeypair();
  }

  Future<String> getPublicKey() async {
    return await frbGetPublicKey();
  }

  Future<String> getNodeId() async {
    return await frbGetNodeId();
  }

  Future<bool> nodeIsInitialized() async {
    return await frbNodeIsInitialized();
  }

  Future<String> createLocalNode() async {
    return await frbCreateLocalNode();
  }

  Future<void> resetNode() async {
    await frbResetNode();
  }

  Future<void> initializeTangle() async {
    await frbInitializeTangle();
  }

  Future<void> initializeMesh() async {
    await frbInitializeMesh();
  }
}