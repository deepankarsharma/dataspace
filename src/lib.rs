use lazy_static::lazy_static;
use std::ffi::c_void;
use std::sync::Mutex;

type Ptr = *const c_void;
type VoidFn = unsafe extern "C" fn();

#[no_mangle]
pub extern "C" fn hello() {
    println!("rust hello")
}

#[no_mangle]
pub extern "C" fn invoke(scheme_cb: Ptr) {
    unsafe {
        let func: VoidFn = std::mem::transmute(scheme_cb);
        func();
    }
}

// Define the Buffer struct
pub struct Buffer {
    data: Vec<u8>,
}

// Global vector to maintain buffers
lazy_static! {
    static ref BUFFERS: Mutex<Vec<Option<Buffer>>> = Mutex::new(Vec::new());
}

// Function to create a buffer
#[no_mangle]
pub extern "C" fn create_buffer(size: usize) -> i32 {
    let buffer = Buffer {
        data: vec![0; size],
    };

    let mut buffers = BUFFERS.lock().unwrap();
    let id = buffers.len() as i32;
    buffers.push(Some(buffer));
    id
}

// Function to destroy a buffer
#[no_mangle]
pub extern "C" fn destroy_buffer(id: i32) -> bool {
    let mut buffers = BUFFERS.lock().unwrap();
    if id < 0 || id as usize >= buffers.len() {
        return false;
    }

    if buffers[id as usize].is_some() {
        buffers[id as usize] = None;
        true
    } else {
        false
    }
}
