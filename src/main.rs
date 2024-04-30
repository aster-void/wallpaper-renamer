use sha256;
use std::fs;

fn main() {
    let storage: fs::ReadDir = fs::read_dir("./storage/data").unwrap();

    rename_recursive(storage, &sha256_16);
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
        println!(
            "Renaming {:?} -> {}",
            path,
            new_name.to_owned() + "." + extension
        );
        if let Ok(_) = fs::read(new_path.clone())
            && new_path != path
        {
            println!(
                "file name confliction was found; continuing.. \n{}{}",
                "name: ",
                new_name.to_owned() + "." + extension
            )
        }
        fs::rename(p.path(), new_path).expect(&format!("Failed renaming file: {:?}", path));
    }
}
fn sha256_16(data: Vec<u8>) -> String {
    let mut result = sha256::digest(data);
    result.truncate(16);
    return result;
}
