#[no_mangle]
pub fn square(num: i32) -> i32 {
    num * num
}

pub fn main() {
	println!("{}", square(33));
}
