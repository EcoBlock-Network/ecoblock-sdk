

use ecoblock_bridge::{
    create_block,
    get_tangle_size,
    add_peer_connection,
    list_peers,
    CONTEXT,
};

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}


/// Wrapper pour créer un bloc depuis Flutter
#[flutter_rust_bridge::frb]
pub fn frb_create_block(data: Vec<u8>, parents: Vec<String>) -> String {
    create_block(data, parents)
}

/// Wrapper pour obtenir la taille du tangle depuis Flutter
#[flutter_rust_bridge::frb]
pub fn frb_get_tangle_size() -> usize {
    get_tangle_size()
}

/// Wrapper pour ajouter une connexion entre deux peers
#[flutter_rust_bridge::frb]
pub fn frb_add_peer_connection(from: String, to: String, weight: f32) {
    add_peer_connection(from, to, weight)
}

/// Wrapper pour lister les voisins d'un peer
#[flutter_rust_bridge::frb]
pub fn frb_list_peers(peer_id: String) -> Vec<String> {
    list_peers(peer_id)
}

/// Wrapper complet pour créer un bloc avec parents
#[flutter_rust_bridge::frb]
pub fn frb_create_block_with_parents(data: Vec<u8>, parents: Vec<String>) -> String {
    create_block(data, parents)
}

// Expose la clé publique du contexte (format hex, via bridge)
#[flutter_rust_bridge::frb]
pub fn frb_get_public_key() -> String {
    CONTEXT.lock().unwrap().keypair.public_key().as_bytes().iter().map(|b| format!("{:02x}", b)).collect()
}

// Expose la propagation d’un bloc (retourne l'id, via le wrapper create_block)
#[flutter_rust_bridge::frb]
pub fn frb_propagate_block(data: Vec<u8>, parents: Vec<String>) -> String {
    create_block(data, parents)
}