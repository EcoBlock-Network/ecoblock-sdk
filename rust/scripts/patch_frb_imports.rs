use std::fs;

fn main() {
    let path = "src/frb_generated.rs";
    let content = fs::read_to_string(path).expect("Failed to read frb_generated.rs");
    let marker = "// Section: imports\n";
    let import = "use ecoblock_bridge::BridgeError;\n";
    if !content.contains(import) {
        let patched = content.replacen(marker, &format!("{}{}", marker, import), 1);
        fs::write(path, patched).expect("Failed to write patched frb_generated.rs");
        println!("Import added!");
    } else {
        println!("Import already present.");
    }
}
