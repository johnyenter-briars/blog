#[cfg(test)]
mod tests;

use rocket::fs::{relative, FileServer};
use std::io::Write;

use rocket::fairing::{Fairing, Info, Kind};
use rocket::{Data, Request, Response};

use chrono;

#[derive(Default)]
struct RuntimeData {
    // get: AtomicUsize,
    // post: AtomicUsize,
    start_time: String,
}

#[rocket::async_trait]
impl Fairing for RuntimeData {
    fn info(&self) -> Info {
        Info {
            name: "Collection of Runtime Data",
            kind: Kind::Request,
        }
    }

    async fn on_request(&self, req: &mut Request<'_>, _: &mut Data<'_>) {
        let ip = match (req.client_ip(), req.real_ip()) {
            (None, None) => panic!("No client ip????"),
            (None, Some(ip)) => ip,
            (Some(ip), None) => ip,
            (Some(_), Some(ip)) => ip,
        };

        let user_agent = req.headers().get("user-agent").collect::<Vec<&str>>();

        let string = format!(
            "Local time: {} | Client ip: {} | Client user agent: {} | Request path: {}\n",
            chrono::offset::Local::now().to_string(),
            ip,
            match user_agent.first() {
                Some(s) => s,
                None => "NA",
            },
            req.uri().path().to_string()
        );

        let path = format!("/var/log/jyb-blog/server_log.{}.log", self.start_time);

        use std::fs::OpenOptions;

        let mut file = OpenOptions::new()
            .write(true)
            .append(true)
            .create(true)
            .open(&path)
            .unwrap();

        match file.write_all(string.as_bytes()) {
            Ok(_) => return,
            Err(_) => panic!("Error writing to file!"),
        }
    }

    async fn on_response<'r>(&self, _: &'r Request<'_>, _: &mut Response<'r>) {}
}

#[rocket::launch]
fn rocket() -> _ {
    let runtime_data = RuntimeData {
        start_time: chrono::offset::Utc::now().to_string(),
    };

    rocket::build()
        .attach(runtime_data)
        .mount("/", FileServer::from(relative!("public")).rank(1))
        .mount("/rdp", FileServer::from(relative!("rdp")).rank(2))
}
