use ecoblock_bridge::{
    add_peer_connection, create_block, create_local_node, get_node_id,
    get_public_key, get_tangle_size, initialize_mesh, initialize_tangle, list_peers,
    node_is_initialized, reset_node
};

#[flutter_rust_bridge::frb(sync)]
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

#[flutter_rust_bridge::frb]
pub fn frb_create_block(data: Vec<u8>, parents: Vec<String>) -> String {
    create_block(data, parents)
}

#[flutter_rust_bridge::frb]
pub fn frb_get_tangle_size() -> usize {
    get_tangle_size()
}

#[flutter_rust_bridge::frb]
pub fn frb_add_peer_connection(from: String, to: String, weight: f32) {
    add_peer_connection(from, to, weight)
}

#[flutter_rust_bridge::frb]
pub fn frb_list_peers(peer_id: String) -> Vec<String> {
    list_peers(peer_id)
}

#[flutter_rust_bridge::frb]
pub fn frb_create_block_with_parents(data: Vec<u8>, parents: Vec<String>) -> String {
    create_block(data, parents)
}

#[flutter_rust_bridge::frb]
pub fn frb_propagate_block(data: Vec<u8>, parents: Vec<String>) -> String {
    create_block(data, parents)
}

#[flutter_rust_bridge::frb]
pub fn frb_generate_keypair(path: String) -> Result<String, String> {
    ecoblock_bridge::generate_keypair(path)
}

#[flutter_rust_bridge::frb]
pub fn frb_get_public_key(path: String) -> Result<String, String> {
    get_public_key(path)
}

#[flutter_rust_bridge::frb]
pub fn frb_get_node_id(path: String) -> Result<String, String> {
    get_node_id(path)
}

#[flutter_rust_bridge::frb]
pub fn frb_node_is_initialized(path: String) -> Result<bool, String> {
    node_is_initialized(path)
}

#[flutter_rust_bridge::frb]
pub fn frb_create_local_node(path: String) -> Result<String, String> {
    create_local_node(path)
}

#[flutter_rust_bridge::frb]
pub fn frb_reset_node(path: String) -> Result<(), String> {
    reset_node(path)
}

#[flutter_rust_bridge::frb]
pub fn frb_initialize_tangle() -> Result<(), String> {
    initialize_tangle()
}

#[flutter_rust_bridge::frb]
pub fn frb_initialize_mesh(path: String) -> Result<(), String> {
    initialize_mesh(path)
}

// -------------- TESTS UNITAIRES -----------------

#[cfg(test)]
mod tests {
    use super::*;
    use serial_test::serial;
    use std::env;
    use std::fs;

    fn test_env(name: &str) -> String {
        let path = format!("/tmp/frb_simple_test_{}", name);
        let _ = fs::remove_dir_all(&path);
        let _ = fs::create_dir_all(&path);
        env::set_var("ECOBLOCK_TEST_KEYPAIR", &path);
        path
    }

    fn cleanup_env() {
        if let Ok(p) = env::var("ECOBLOCK_TEST_KEYPAIR") {
            let _ = fs::remove_dir_all(&p);
        }
        env::remove_var("ECOBLOCK_TEST_KEYPAIR");
    }

    #[test]
    #[serial]
    fn test_frb_generate_keypair_and_get_public_key() {
    let path = test_env("frb_generate_keypair");
    let pubkey = frb_generate_keypair(path.clone()).expect("FRB: Should generate keypair");
    assert!(!pubkey.is_empty());
    let pubkey2 = frb_get_public_key(path.clone()).expect("FRB: Should get public key");
        assert_eq!(pubkey, pubkey2);
        cleanup_env();
    }

    #[test]
    #[serial]
    fn test_frb_get_node_id() {
    let path = test_env("frb_get_node_id");
    let _ = frb_generate_keypair(path.clone());
    let node_id = frb_get_node_id(path.clone()).expect("FRB: Should get node id");
        assert!(!node_id.is_empty());
        cleanup_env();
    }

    #[test]
    #[serial]
    fn test_frb_node_is_initialized() {
    let path = test_env("frb_node_is_initialized");
    assert_eq!(frb_node_is_initialized(path.clone()).unwrap(), false);
    let _ = frb_generate_keypair(path.clone());
    assert_eq!(frb_node_is_initialized(path.clone()).unwrap(), true);
        cleanup_env();
    }

    #[test]
    #[serial]
    fn test_frb_reset_node() {
    let path = test_env("frb_reset_node");
    let _ = frb_generate_keypair(path.clone());
    assert_eq!(frb_node_is_initialized(path.clone()).unwrap(), true);
    frb_reset_node(path.clone()).unwrap();
    assert_eq!(frb_node_is_initialized(path.clone()).unwrap(), false);
        cleanup_env();
    }

    #[test]
    #[serial]
    fn test_frb_create_local_node() {
    let path = test_env("frb_create_local_node");
    let node_id = frb_create_local_node(path.clone()).expect("FRB: Should create local node");
    assert!(!node_id.is_empty());
    let result = frb_create_local_node(path.clone());
        assert!(result.is_err());
        cleanup_env();
    }

    #[test]
    #[serial]
    fn test_frb_initialize_tangle_and_mesh() {
    let path = test_env("frb_initialize_tangle_mesh");
    let _ = frb_generate_keypair(path.clone());
    assert!(frb_initialize_tangle().is_ok());
    assert!(frb_initialize_mesh(path.clone()).is_ok());
        cleanup_env();
    }

    #[test]
    #[serial]
    fn test_frb_create_block_and_get_tangle_size() {
    let path = test_env("frb_create_block");
    let _ = frb_create_local_node(path.clone());
        // Génère un SensorData JSON minimal
        let data = serde_json::to_vec(&serde_json::json!({
            "pm25": 5.0, "co2": 400.0, "temperature": 21.0, "humidity": 45.0, "timestamp": 12345678
        })).unwrap();
        let id = frb_create_block(data.clone(), vec![]);
        assert!(!id.is_empty());
        let size = frb_get_tangle_size();
        assert_eq!(size, 1); // 1 bloc créé
        cleanup_env();
    }

    #[test]
    #[serial]
    fn test_frb_add_peer_connection_and_list_peers() {
    let path = test_env("frb_peers");
    let _ = frb_create_local_node(path.clone());
    let node_id = frb_get_node_id(path.clone()).unwrap();
        let peer_id = "test_peer_1".to_string();
        frb_add_peer_connection(node_id.clone(), peer_id.clone(), 1.0);
        let neighbors = frb_list_peers(node_id.clone());
        assert!(neighbors.contains(&peer_id));
        cleanup_env();
    }

    // Facultatif : tests de frb_create_block_with_parents/frb_propagate_block
}