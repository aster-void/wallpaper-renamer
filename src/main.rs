use sha256;
use std::fs;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    // copies everything in ./storage/aliases/ to ./storage/data
    let mut command = Command::new("cp");
    command.arg("./storage/new/*");
    command.arg("./storage/data/");
    command.output().expect("couldn't copy from ./storage/new");

    // file renamer
    // renames everything in storage (./storage/data)
    let storage: fs::ReadDir = fs::read_dir("./storage/data").unwrap();
    rename_recursive(storage, &sha256_16);

    // linker
    // links everything in new (./storage/new) to corresponding data in pool (./storage/data), then clears new (./storage/new)
    link(
        "./storage/new",
        "./storage/aliases",
        "./storage/data",
        &sha256_16,
    );
}

fn link(new: &str, links: &str, pool: &str, generate_name: &dyn Fn(Vec<u8>) -> String) {
    let dir = fs::read_dir(new).expect(&format!("directory {} not found!", new));
    for path in dir {
        let Ok(path) = path else { continue };
        let content = fs::read(path.path()).expect("couldn't read a file");
        let bind = path.path();
        let ext = bind.extension().unwrap().to_str().unwrap();
        let new_name = &generate_name(content);
        let hashed_name = pool.to_owned() + "/" + new_name + "." + ext;
        let original_name = format!(
            "{}/{}",
            links,
            &path.file_name().to_os_string().into_string().unwrap(),
        );
        println!("making symlink: {} -> {}", &original_name, &hashed_name);
        let mut command = Command::new("ln");
        command.arg("-s");
        command.arg(hashed_name); // original name in pool
        command.arg(original_name); // new symlink in symlink dir
        command
            .output()
            .expect(&format!("Failed to make a symlink on :{:?}", path));
    }
    fs::remove_dir_all(new).unwrap();
    fs::create_dir(new).unwrap();
}

fn rename_recursive(dir: fs::ReadDir, generate_name: &dyn Fn(Vec<u8>) -> String) {
    for path in dir {
        let Ok(p) = path else { continue };
        let path = &p.path();
        if path.is_dir() {
            let dir = fs::read_dir(path).expect(&format!("Failed reading dir: {:?}", path));
            rename_recursive(dir, &generate_name);
            continue;
        }
        let content = fs::read(p.path());
        let Ok(c) = content else {
            panic!("reading file failed: {:?}", path);
        };
        let new_name = &generate_name(c);
        let bind = p.path();
        let dir_name = bind.parent().expect("this shouldn't be possible");
        let extension = path
            .extension()
            .into_iter()
            .find_map(|os| os.to_str())
            .unwrap_or("");
        let new_path = dir_name.to_str().unwrap().to_owned() + "/" + new_name + "." + extension;

        if PathBuf::from(new_path.clone()) == *path {
            continue;
        }
        println!(
            "Renaming {:?} -> {}",
            path,
            new_name.to_owned() + "." + extension
        );
        fs::rename(p.path(), new_path).expect(&format!("Failed renaming file: {:?}", path));
    }
}
fn sha256_16(data: Vec<u8>) -> String {
    let mut result = sha256::digest(data);
    result.truncate(16);
    return result;
}
