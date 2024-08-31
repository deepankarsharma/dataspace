use std::ffi::c_void;

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
    _marker: std::marker::PhantomPinned,
}

impl Buffer {
    fn new() -> Self {
        Buffer {
            data: Vec::new(),
            _marker: std::marker::PhantomPinned,
        }
    }
}

// Function to create a buffer
#[no_mangle]
pub extern "C" fn create_buffer() -> Ptr {
    println!("create_buffer called in rust!");
    let buffer = Box::new(Buffer::new());
    Box::into_raw(buffer) as Ptr
}

// Function to destroy a buffer
#[no_mangle]
pub extern "C" fn destroy_buffer(ptr: Ptr) {
    println!("destroy_buffer called in rust!");
    if !ptr.is_null() {
        unsafe {
            let _ = Box::from_raw(ptr as *mut Buffer);
        }
    }
}
