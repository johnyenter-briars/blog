#[cfg(test)]
mod tests;

use rocket::fs::{relative, FileServer};

// If we wanted or needed to serve files manually, we'd use `NamedFile`. Always
// prefer to use `FileServer`!
mod manual {
    use rocket::fs::NamedFile;
    use std::path::{Path, PathBuf};

    #[rocket::get("/second/<path..>")]
    pub async fn second(path: PathBuf) -> Option<NamedFile> {
        let mut path = Path::new(super::relative!("static")).join(path);
        if path.is_dir() {
            path.push("index.html");
        }

        NamedFile::open(path).await.ok()
    }
}

#[rocket::launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", FileServer::from(relative!("blog")).rank(1))
        .mount(
            "/reverse-date-parser",
            FileServer::from(relative!("reverse-date-parser")).rank(2),
        )
}
