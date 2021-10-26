#[cfg(test)]
mod tests;

use rocket::fs::{relative, FileServer};

#[rocket::launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", FileServer::from(relative!("public")).rank(1))
        .mount("/rdp", FileServer::from(relative!("rdp")).rank(2))
}
