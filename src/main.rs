#[cfg(test)]
mod tests;

use std::net::SocketAddr;

use rocket::{fs::{relative, FileServer}, get, request::FromRequest};




#[get("/")]
fn index(remote_addr: SocketAddr) -> String {
    format!("Remote Address: {:?}", remote_addr)
}


#[rocket::launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", FileServer::from(relative!("public")).rank(1))
        .mount("/rdp", FileServer::from(relative!("rdp")).rank(2))
}
