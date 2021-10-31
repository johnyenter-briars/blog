#[cfg(test)]
mod tests;

use rocket::fs::{relative, FileServer};
use std::future::Future;
use std::io::Cursor;
use std::pin::Pin;
use std::sync::atomic::{AtomicUsize, Ordering};

use rocket::fairing::{Fairing, Info, Kind};
use rocket::http::{ContentType, Method, Status};
use rocket::{Data, Request, Response};

#[derive(Default)]
struct Counter {
    get: AtomicUsize,
    post: AtomicUsize,
}

#[rocket::async_trait]
impl Fairing for Counter {
    fn info(&self) -> Info {
        Info {
            name: "GET/POST Counter",
            kind: Kind::Request | Kind::Response,
        }
    }

    async fn on_request(&self, req: &mut Request<'_>, _: &mut Data<'_>) {
        println!("current number? {:?}", self.get);
        println!("client ip: {:?}", req.client_ip());
        if req.method() == Method::Get {
            self.get.fetch_add(1, Ordering::Relaxed);
        } else if req.method() == Method::Post {
            self.post.fetch_add(1, Ordering::Relaxed);
        }
    }

    async fn on_response<'r>(&self, req: &'r Request<'_>, res: &mut Response<'r>) {
        // Don't change a successful user's response, ever.
        if res.status() != Status::NotFound {
            return;
        }

        if req.method() == Method::Get && req.uri().path() == "/counts" {
            let get_count = self.get.load(Ordering::Relaxed);
            let post_count = self.post.load(Ordering::Relaxed);

            let body = format!("Get: {}\nPost: {}", get_count, post_count);
            res.set_status(Status::Ok);
            res.set_header(ContentType::Plain);
            res.set_sized_body(body.len(), Cursor::new(body));
        }
    }
}

#[rocket::launch]
fn rocket() -> _ {
    let counter = Counter {
        get: AtomicUsize::try_from(0).unwrap(),
        post: AtomicUsize::try_from(0).unwrap(),
    };
    rocket::build()
        .attach(counter)
        .mount("/", FileServer::from(relative!("public")).rank(1))
        .mount("/rdp", FileServer::from(relative!("rdp")).rank(2))
}
